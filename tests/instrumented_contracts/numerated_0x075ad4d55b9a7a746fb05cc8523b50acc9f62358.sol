1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-10
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 
8 // File: @openzeppelin/contracts/utils/Counters.sol
9 
10 
11 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @title Counters
17  * @author Matt Condon (@shrugs)
18  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
19  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
20  *
21  * Include with `using Counters for Counters.Counter;`
22  */
23 library Counters {
24     struct Counter {
25         // This variable should never be directly accessed by users of the library: interactions must be restricted to
26         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
27         // this feature: see https://github.com/ethereum/solidity/issues/4637
28         uint256 _value; // default: 0
29     }
30 
31     function current(Counter storage counter) internal view returns (uint256) {
32         return counter._value;
33     }
34 
35     function increment(Counter storage counter) internal {
36         unchecked {
37             counter._value += 1;
38         }
39     }
40 
41     function decrement(Counter storage counter) internal {
42         uint256 value = counter._value;
43         require(value > 0, "Counter: decrement overflow");
44         unchecked {
45             counter._value = value - 1;
46         }
47     }
48 
49     function reset(Counter storage counter) internal {
50         counter._value = 0;
51     }
52 }
53 
54 // File: @openzeppelin/contracts/utils/Strings.sol
55 
56 
57 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
58 
59 pragma solidity ^0.8.0;
60 
61 /**
62  * @dev String operations.
63  */
64 library Strings {
65     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
66 
67     /**
68      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
69      */
70     function toString(uint256 value) internal pure returns (string memory) {
71         // Inspired by OraclizeAPI's implementation - MIT licence
72         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
73 
74         if (value == 0) {
75             return "0";
76         }
77         uint256 temp = value;
78         uint256 digits;
79         while (temp != 0) {
80             digits++;
81             temp /= 10;
82         }
83         bytes memory buffer = new bytes(digits);
84         while (value != 0) {
85             digits -= 1;
86             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
87             value /= 10;
88         }
89         return string(buffer);
90     }
91 
92     /**
93      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
94      */
95     function toHexString(uint256 value) internal pure returns (string memory) {
96         if (value == 0) {
97             return "0x00";
98         }
99         uint256 temp = value;
100         uint256 length = 0;
101         while (temp != 0) {
102             length++;
103             temp >>= 8;
104         }
105         return toHexString(value, length);
106     }
107 
108     /**
109      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
110      */
111     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
112         bytes memory buffer = new bytes(2 * length + 2);
113         buffer[0] = "0";
114         buffer[1] = "x";
115         for (uint256 i = 2 * length + 1; i > 1; --i) {
116             buffer[i] = _HEX_SYMBOLS[value & 0xf];
117             value >>= 4;
118         }
119         require(value == 0, "Strings: hex length insufficient");
120         return string(buffer);
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
154 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
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
184      * @dev Returns the address of the current owner.
185      */
186     function owner() public view virtual returns (address) {
187         return _owner;
188     }
189 
190     /**
191      * @dev Throws if called by any account other than the owner.
192      */
193     modifier onlyOwner() {
194         require(owner() == _msgSender(), "Ownable: caller is not the owner");
195         _;
196     }
197 
198     /**
199      * @dev Leaves the contract without owner. It will not be possible to call
200      * `onlyOwner` functions anymore. Can only be called by the current owner.
201      *
202      * NOTE: Renouncing ownership will leave the contract without an owner,
203      * thereby removing any functionality that is only available to the owner.
204      */
205     function renounceOwnership() public virtual onlyOwner {
206         _transferOwnership(address(0));
207     }
208 
209     /**
210      * @dev Transfers ownership of the contract to a new account (`newOwner`).
211      * Can only be called by the current owner.
212      */
213     function transferOwnership(address newOwner) public virtual onlyOwner {
214         require(newOwner != address(0), "Ownable: new owner is the zero address");
215         _transferOwnership(newOwner);
216     }
217 
218     /**
219      * @dev Transfers ownership of the contract to a new account (`newOwner`).
220      * Internal function without access restriction.
221      */
222     function _transferOwnership(address newOwner) internal virtual {
223         address oldOwner = _owner;
224         _owner = newOwner;
225         emit OwnershipTransferred(oldOwner, newOwner);
226     }
227 }
228 
229 // File: @openzeppelin/contracts/utils/Address.sol
230 
231 
232 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
233 
234 pragma solidity ^0.8.1;
235 
236 /**
237  * @dev Collection of functions related to the address type
238  */
239 library Address {
240     /**
241      * @dev Returns true if `account` is a contract.
242      *
243      * [IMPORTANT]
244      * ====
245      * It is unsafe to assume that an address for which this function returns
246      * false is an externally-owned account (EOA) and not a contract.
247      *
248      * Among others, `isContract` will return false for the following
249      * types of addresses:
250      *
251      *  - an externally-owned account
252      *  - a contract in construction
253      *  - an address where a contract will be created
254      *  - an address where a contract lived, but was destroyed
255      * ====
256      *
257      * [IMPORTANT]
258      * ====
259      * You shouldn't rely on `isContract` to protect against flash loan attacks!
260      *
261      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
262      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
263      * constructor.
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // This method relies on extcodesize/address.code.length, which returns 0
268         // for contracts in construction, since the code is only stored at the end
269         // of the constructor execution.
270 
271         return account.code.length > 0;
272     }
273 
274     /**
275      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
276      * `recipient`, forwarding all available gas and reverting on errors.
277      *
278      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
279      * of certain opcodes, possibly making contracts go over the 2300 gas limit
280      * imposed by `transfer`, making them unable to receive funds via
281      * `transfer`. {sendValue} removes this limitation.
282      *
283      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
284      *
285      * IMPORTANT: because control is transferred to `recipient`, care must be
286      * taken to not create reentrancy vulnerabilities. Consider using
287      * {ReentrancyGuard} or the
288      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
289      */
290     function sendValue(address payable recipient, uint256 amount) internal {
291         require(address(this).balance >= amount, "Address: insufficient balance");
292 
293         (bool success, ) = recipient.call{value: amount}("");
294         require(success, "Address: unable to send value, recipient may have reverted");
295     }
296 
297     /**
298      * @dev Performs a Solidity function call using a low level `call`. A
299      * plain `call` is an unsafe replacement for a function call: use this
300      * function instead.
301      *
302      * If `target` reverts with a revert reason, it is bubbled up by this
303      * function (like regular Solidity function calls).
304      *
305      * Returns the raw returned data. To convert to the expected return value,
306      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
307      *
308      * Requirements:
309      *
310      * - `target` must be a contract.
311      * - calling `target` with `data` must not revert.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
316         return functionCall(target, data, "Address: low-level call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
321      * `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(
326         address target,
327         bytes memory data,
328         string memory errorMessage
329     ) internal returns (bytes memory) {
330         return functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(
345         address target,
346         bytes memory data,
347         uint256 value
348     ) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(
359         address target,
360         bytes memory data,
361         uint256 value,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         require(address(this).balance >= value, "Address: insufficient balance for call");
365         require(isContract(target), "Address: call to non-contract");
366 
367         (bool success, bytes memory returndata) = target.call{value: value}(data);
368         return verifyCallResult(success, returndata, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but performing a static call.
374      *
375      * _Available since v3.3._
376      */
377     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
378         return functionStaticCall(target, data, "Address: low-level static call failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
383      * but performing a static call.
384      *
385      * _Available since v3.3._
386      */
387     function functionStaticCall(
388         address target,
389         bytes memory data,
390         string memory errorMessage
391     ) internal view returns (bytes memory) {
392         require(isContract(target), "Address: static call to non-contract");
393 
394         (bool success, bytes memory returndata) = target.staticcall(data);
395         return verifyCallResult(success, returndata, errorMessage);
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
400      * but performing a delegate call.
401      *
402      * _Available since v3.4._
403      */
404     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
405         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
410      * but performing a delegate call.
411      *
412      * _Available since v3.4._
413      */
414     function functionDelegateCall(
415         address target,
416         bytes memory data,
417         string memory errorMessage
418     ) internal returns (bytes memory) {
419         require(isContract(target), "Address: delegate call to non-contract");
420 
421         (bool success, bytes memory returndata) = target.delegatecall(data);
422         return verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
427      * revert reason using the provided one.
428      *
429      * _Available since v4.3._
430      */
431     function verifyCallResult(
432         bool success,
433         bytes memory returndata,
434         string memory errorMessage
435     ) internal pure returns (bytes memory) {
436         if (success) {
437             return returndata;
438         } else {
439             // Look for revert reason and bubble it up if present
440             if (returndata.length > 0) {
441                 // The easiest way to bubble the revert reason is using memory via assembly
442 
443                 assembly {
444                     let returndata_size := mload(returndata)
445                     revert(add(32, returndata), returndata_size)
446                 }
447             } else {
448                 revert(errorMessage);
449             }
450         }
451     }
452 }
453 
454 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
455 
456 
457 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 /**
462  * @title ERC721 token receiver interface
463  * @dev Interface for any contract that wants to support safeTransfers
464  * from ERC721 asset contracts.
465  */
466 interface IERC721Receiver {
467     /**
468      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
469      * by `operator` from `from`, this function is called.
470      *
471      * It must return its Solidity selector to confirm the token transfer.
472      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
473      *
474      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
475      */
476     function onERC721Received(
477         address operator,
478         address from,
479         uint256 tokenId,
480         bytes calldata data
481     ) external returns (bytes4);
482 }
483 
484 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
485 
486 
487 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 /**
492  * @dev Interface of the ERC165 standard, as defined in the
493  * https://eips.ethereum.org/EIPS/eip-165[EIP].
494  *
495  * Implementers can declare support of contract interfaces, which can then be
496  * queried by others ({ERC165Checker}).
497  *
498  * For an implementation, see {ERC165}.
499  */
500 interface IERC165 {
501     /**
502      * @dev Returns true if this contract implements the interface defined by
503      * `interfaceId`. See the corresponding
504      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
505      * to learn more about how these ids are created.
506      *
507      * This function call must use less than 30 000 gas.
508      */
509     function supportsInterface(bytes4 interfaceId) external view returns (bool);
510 }
511 
512 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
513 
514 
515 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
516 
517 pragma solidity ^0.8.0;
518 
519 
520 /**
521  * @dev Implementation of the {IERC165} interface.
522  *
523  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
524  * for the additional interface id that will be supported. For example:
525  *
526  * ```solidity
527  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
528  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
529  * }
530  * ```
531  *
532  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
533  */
534 abstract contract ERC165 is IERC165 {
535     /**
536      * @dev See {IERC165-supportsInterface}.
537      */
538     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
539         return interfaceId == type(IERC165).interfaceId;
540     }
541 }
542 
543 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
544 
545 
546 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 
551 /**
552  * @dev Required interface of an ERC721 compliant contract.
553  */
554 interface IERC721 is IERC165 {
555     /**
556      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
557      */
558     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
559 
560     /**
561      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
562      */
563     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
564 
565     /**
566      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
567      */
568     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
569 
570     /**
571      * @dev Returns the number of tokens in ``owner``'s account.
572      */
573     function balanceOf(address owner) external view returns (uint256 balance);
574 
575     /**
576      * @dev Returns the owner of the `tokenId` token.
577      *
578      * Requirements:
579      *
580      * - `tokenId` must exist.
581      */
582     function ownerOf(uint256 tokenId) external view returns (address owner);
583 
584     /**
585      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
586      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
587      *
588      * Requirements:
589      *
590      * - `from` cannot be the zero address.
591      * - `to` cannot be the zero address.
592      * - `tokenId` token must exist and be owned by `from`.
593      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
594      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
595      *
596      * Emits a {Transfer} event.
597      */
598     function safeTransferFrom(
599         address from,
600         address to,
601         uint256 tokenId
602     ) external;
603 
604     /**
605      * @dev Transfers `tokenId` token from `from` to `to`.
606      *
607      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
608      *
609      * Requirements:
610      *
611      * - `from` cannot be the zero address.
612      * - `to` cannot be the zero address.
613      * - `tokenId` token must be owned by `from`.
614      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
615      *
616      * Emits a {Transfer} event.
617      */
618     function transferFrom(
619         address from,
620         address to,
621         uint256 tokenId
622     ) external;
623 
624     /**
625      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
626      * The approval is cleared when the token is transferred.
627      *
628      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
629      *
630      * Requirements:
631      *
632      * - The caller must own the token or be an approved operator.
633      * - `tokenId` must exist.
634      *
635      * Emits an {Approval} event.
636      */
637     function approve(address to, uint256 tokenId) external;
638 
639     /**
640      * @dev Returns the account approved for `tokenId` token.
641      *
642      * Requirements:
643      *
644      * - `tokenId` must exist.
645      */
646     function getApproved(uint256 tokenId) external view returns (address operator);
647 
648     /**
649      * @dev Approve or remove `operator` as an operator for the caller.
650      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
651      *
652      * Requirements:
653      *
654      * - The `operator` cannot be the caller.
655      *
656      * Emits an {ApprovalForAll} event.
657      */
658     function setApprovalForAll(address operator, bool _approved) external;
659 
660     /**
661      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
662      *
663      * See {setApprovalForAll}
664      */
665     function isApprovedForAll(address owner, address operator) external view returns (bool);
666 
667     /**
668      * @dev Safely transfers `tokenId` token from `from` to `to`.
669      *
670      * Requirements:
671      *
672      * - `from` cannot be the zero address.
673      * - `to` cannot be the zero address.
674      * - `tokenId` token must exist and be owned by `from`.
675      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
676      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
677      *
678      * Emits a {Transfer} event.
679      */
680     function safeTransferFrom(
681         address from,
682         address to,
683         uint256 tokenId,
684         bytes calldata data
685     ) external;
686 }
687 
688 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
689 
690 
691 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
692 
693 pragma solidity ^0.8.0;
694 
695 
696 /**
697  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
698  * @dev See https://eips.ethereum.org/EIPS/eip-721
699  */
700 interface IERC721Metadata is IERC721 {
701     /**
702      * @dev Returns the token collection name.
703      */
704     function name() external view returns (string memory);
705 
706     /**
707      * @dev Returns the token collection symbol.
708      */
709     function symbol() external view returns (string memory);
710 
711     /**
712      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
713      */
714     function tokenURI(uint256 tokenId) external view returns (string memory);
715 }
716 
717 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
718 
719 
720 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
721 
722 pragma solidity ^0.8.0;
723 
724 
725 
726 
727 
728 
729 
730 
731 /**
732  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
733  * the Metadata extension, but not including the Enumerable extension, which is available separately as
734  * {ERC721Enumerable}.
735  */
736 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
737     using Address for address;
738     using Strings for uint256;
739 
740     // Token name
741     string private _name;
742 
743     // Token symbol
744     string private _symbol;
745 
746     // Mapping from token ID to owner address
747     mapping(uint256 => address) private _owners;
748 
749     // Mapping owner address to token count
750     mapping(address => uint256) private _balances;
751 
752     // Mapping from token ID to approved address
753     mapping(uint256 => address) private _tokenApprovals;
754 
755     // Mapping from owner to operator approvals
756     mapping(address => mapping(address => bool)) private _operatorApprovals;
757 
758     /**
759      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
760      */
761     constructor(string memory name_, string memory symbol_) {
762         _name = name_;
763         _symbol = symbol_;
764     }
765 
766     /**
767      * @dev See {IERC165-supportsInterface}.
768      */
769     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
770         return
771             interfaceId == type(IERC721).interfaceId ||
772             interfaceId == type(IERC721Metadata).interfaceId ||
773             super.supportsInterface(interfaceId);
774     }
775 
776     /**
777      * @dev See {IERC721-balanceOf}.
778      */
779     function balanceOf(address owner) public view virtual override returns (uint256) {
780         require(owner != address(0), "ERC721: balance query for the zero address");
781         return _balances[owner];
782     }
783 
784     /**
785      * @dev See {IERC721-ownerOf}.
786      */
787     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
788         address owner = _owners[tokenId];
789         require(owner != address(0), "ERC721: owner query for nonexistent token");
790         return owner;
791     }
792 
793     /**
794      * @dev See {IERC721Metadata-name}.
795      */
796     function name() public view virtual override returns (string memory) {
797         return _name;
798     }
799 
800     /**
801      * @dev See {IERC721Metadata-symbol}.
802      */
803     function symbol() public view virtual override returns (string memory) {
804         return _symbol;
805     }
806 
807     /**
808      * @dev See {IERC721Metadata-tokenURI}.
809      */
810     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
811         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
812 
813         string memory baseURI = _baseURI();
814         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
815     }
816 
817     /**
818      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
819      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
820      * by default, can be overriden in child contracts.
821      */
822     function _baseURI() internal view virtual returns (string memory) {
823         return "";
824     }
825 
826     /**
827      * @dev See {IERC721-approve}.
828      */
829     function approve(address to, uint256 tokenId) public virtual override {
830         address owner = ERC721.ownerOf(tokenId);
831         require(to != owner, "ERC721: approval to current owner");
832 
833         require(
834             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
835             "ERC721: approve caller is not owner nor approved for all"
836         );
837 
838         _approve(to, tokenId);
839     }
840 
841     /**
842      * @dev See {IERC721-getApproved}.
843      */
844     function getApproved(uint256 tokenId) public view virtual override returns (address) {
845         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
846 
847         return _tokenApprovals[tokenId];
848     }
849 
850     /**
851      * @dev See {IERC721-setApprovalForAll}.
852      */
853     function setApprovalForAll(address operator, bool approved) public virtual override {
854         _setApprovalForAll(_msgSender(), operator, approved);
855     }
856 
857     /**
858      * @dev See {IERC721-isApprovedForAll}.
859      */
860     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
861         return _operatorApprovals[owner][operator];
862     }
863 
864     /**
865      * @dev See {IERC721-transferFrom}.
866      */
867     function transferFrom(
868         address from,
869         address to,
870         uint256 tokenId
871     ) public virtual override {
872         //solhint-disable-next-line max-line-length
873         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
874 
875         _transfer(from, to, tokenId);
876     }
877 
878     /**
879      * @dev See {IERC721-safeTransferFrom}.
880      */
881     function safeTransferFrom(
882         address from,
883         address to,
884         uint256 tokenId
885     ) public virtual override {
886         safeTransferFrom(from, to, tokenId, "");
887     }
888 
889     /**
890      * @dev See {IERC721-safeTransferFrom}.
891      */
892     function safeTransferFrom(
893         address from,
894         address to,
895         uint256 tokenId,
896         bytes memory _data
897     ) public virtual override {
898         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
899         _safeTransfer(from, to, tokenId, _data);
900     }
901 
902     /**
903      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
904      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
905      *
906      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
907      *
908      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
909      * implement alternative mechanisms to perform token transfer, such as signature-based.
910      *
911      * Requirements:
912      *
913      * - `from` cannot be the zero address.
914      * - `to` cannot be the zero address.
915      * - `tokenId` token must exist and be owned by `from`.
916      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _safeTransfer(
921         address from,
922         address to,
923         uint256 tokenId,
924         bytes memory _data
925     ) internal virtual {
926         _transfer(from, to, tokenId);
927         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
928     }
929 
930     /**
931      * @dev Returns whether `tokenId` exists.
932      *
933      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
934      *
935      * Tokens start existing when they are minted (`_mint`),
936      * and stop existing when they are burned (`_burn`).
937      */
938     function _exists(uint256 tokenId) internal view virtual returns (bool) {
939         return _owners[tokenId] != address(0);
940     }
941 
942     /**
943      * @dev Returns whether `spender` is allowed to manage `tokenId`.
944      *
945      * Requirements:
946      *
947      * - `tokenId` must exist.
948      */
949     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
950         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
951         address owner = ERC721.ownerOf(tokenId);
952         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
953     }
954 
955     /**
956      * @dev Safely mints `tokenId` and transfers it to `to`.
957      *
958      * Requirements:
959      *
960      * - `tokenId` must not exist.
961      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
962      *
963      * Emits a {Transfer} event.
964      */
965     function _safeMint(address to, uint256 tokenId) internal virtual {
966         _safeMint(to, tokenId, "");
967     }
968 
969     /**
970      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
971      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
972      */
973     function _safeMint(
974         address to,
975         uint256 tokenId,
976         bytes memory _data
977     ) internal virtual {
978         _mint(to, tokenId);
979         require(
980             _checkOnERC721Received(address(0), to, tokenId, _data),
981             "ERC721: transfer to non ERC721Receiver implementer"
982         );
983     }
984 
985     /**
986      * @dev Mints `tokenId` and transfers it to `to`.
987      *
988      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
989      *
990      * Requirements:
991      *
992      * - `tokenId` must not exist.
993      * - `to` cannot be the zero address.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _mint(address to, uint256 tokenId) internal virtual {
998         require(to != address(0), "ERC721: mint to the zero address");
999         require(!_exists(tokenId), "ERC721: token already minted");
1000 
1001         _beforeTokenTransfer(address(0), to, tokenId);
1002 
1003         _balances[to] += 1;
1004         _owners[tokenId] = to;
1005 
1006         emit Transfer(address(0), to, tokenId);
1007 
1008         _afterTokenTransfer(address(0), to, tokenId);
1009     }
1010 
1011     /**
1012      * @dev Destroys `tokenId`.
1013      * The approval is cleared when the token is burned.
1014      *
1015      * Requirements:
1016      *
1017      * - `tokenId` must exist.
1018      *
1019      * Emits a {Transfer} event.
1020      */
1021     function _burn(uint256 tokenId) internal virtual {
1022         address owner = ERC721.ownerOf(tokenId);
1023 
1024         _beforeTokenTransfer(owner, address(0), tokenId);
1025 
1026         // Clear approvals
1027         _approve(address(0), tokenId);
1028 
1029         _balances[owner] -= 1;
1030         delete _owners[tokenId];
1031 
1032         emit Transfer(owner, address(0), tokenId);
1033 
1034         _afterTokenTransfer(owner, address(0), tokenId);
1035     }
1036 
1037     /**
1038      * @dev Transfers `tokenId` from `from` to `to`.
1039      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1040      *
1041      * Requirements:
1042      *
1043      * - `to` cannot be the zero address.
1044      * - `tokenId` token must be owned by `from`.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function _transfer(
1049         address from,
1050         address to,
1051         uint256 tokenId
1052     ) internal virtual {
1053         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1054         require(to != address(0), "ERC721: transfer to the zero address");
1055 
1056         _beforeTokenTransfer(from, to, tokenId);
1057 
1058         // Clear approvals from the previous owner
1059         _approve(address(0), tokenId);
1060 
1061         _balances[from] -= 1;
1062         _balances[to] += 1;
1063         _owners[tokenId] = to;
1064 
1065         emit Transfer(from, to, tokenId);
1066 
1067         _afterTokenTransfer(from, to, tokenId);
1068     }
1069 
1070     /**
1071      * @dev Approve `to` to operate on `tokenId`
1072      *
1073      * Emits a {Approval} event.
1074      */
1075     function _approve(address to, uint256 tokenId) internal virtual {
1076         _tokenApprovals[tokenId] = to;
1077         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1078     }
1079 
1080     /**
1081      * @dev Approve `operator` to operate on all of `owner` tokens
1082      *
1083      * Emits a {ApprovalForAll} event.
1084      */
1085     function _setApprovalForAll(
1086         address owner,
1087         address operator,
1088         bool approved
1089     ) internal virtual {
1090         require(owner != operator, "ERC721: approve to caller");
1091         _operatorApprovals[owner][operator] = approved;
1092         emit ApprovalForAll(owner, operator, approved);
1093     }
1094 
1095     /**
1096      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1097      * The call is not executed if the target address is not a contract.
1098      *
1099      * @param from address representing the previous owner of the given token ID
1100      * @param to target address that will receive the tokens
1101      * @param tokenId uint256 ID of the token to be transferred
1102      * @param _data bytes optional data to send along with the call
1103      * @return bool whether the call correctly returned the expected magic value
1104      */
1105     function _checkOnERC721Received(
1106         address from,
1107         address to,
1108         uint256 tokenId,
1109         bytes memory _data
1110     ) private returns (bool) {
1111         if (to.isContract()) {
1112             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1113                 return retval == IERC721Receiver.onERC721Received.selector;
1114             } catch (bytes memory reason) {
1115                 if (reason.length == 0) {
1116                     revert("ERC721: transfer to non ERC721Receiver implementer");
1117                 } else {
1118                     assembly {
1119                         revert(add(32, reason), mload(reason))
1120                     }
1121                 }
1122             }
1123         } else {
1124             return true;
1125         }
1126     }
1127 
1128     /**
1129      * @dev Hook that is called before any token transfer. This includes minting
1130      * and burning.
1131      *
1132      * Calling conditions:
1133      *
1134      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1135      * transferred to `to`.
1136      * - When `from` is zero, `tokenId` will be minted for `to`.
1137      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1138      * - `from` and `to` are never both zero.
1139      *
1140      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1141      */
1142     function _beforeTokenTransfer(
1143         address from,
1144         address to,
1145         uint256 tokenId
1146     ) internal virtual {}
1147 
1148     /**
1149      * @dev Hook that is called after any transfer of tokens. This includes
1150      * minting and burning.
1151      *
1152      * Calling conditions:
1153      *
1154      * - when `from` and `to` are both non-zero.
1155      * - `from` and `to` are never both zero.
1156      *
1157      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1158      */
1159     function _afterTokenTransfer(
1160         address from,
1161         address to,
1162         uint256 tokenId
1163     ) internal virtual {}
1164 }
1165 
1166 // File: contracts/SimpleNftLowerGas.sol
1167 
1168 
1169 
1170 // Amended by HashLips
1171 /**
1172     !Disclaimer!
1173 
1174     These contracts have been used to create tutorials,
1175     and was created for the purpose to teach people
1176     how to create smart contracts on the blockchain.
1177     please review this code on your own before using any of
1178     the following code for production.
1179     The developer will not be responsible or liable for all loss or 
1180     damage whatsoever caused by you participating in any way in the 
1181     experimental code, whether putting money into the contract or 
1182     using the code for your own project.
1183 */
1184 
1185 pragma solidity >=0.7.0 <0.9.0;
1186 
1187 
1188 
1189 
1190 contract SimpleNftLowerGas_flat is ERC721, Ownable {
1191   using Strings for uint256;
1192   using Counters for Counters.Counter;
1193 
1194   Counters.Counter private supply;
1195 
1196   string public uriPrefix = "";
1197   string public uriSuffix = ".json";
1198   string public hiddenMetadataUri;
1199   
1200   uint256 public cost = 0.0069 ether;
1201   uint256 public maxSupply = 1750;
1202   uint256 public maxMintAmountPerTx = 5;
1203 
1204   bool public paused = false;
1205   bool public revealed = true;
1206 
1207   constructor() ERC721("Goji Bears Test", "GOJI") {
1208     setHiddenMetadataUri("ipfs://QmbqXxrbob8Msv6gzj9djeRyJgk3JMFM4vj7yHK5spMKJ5/");
1209   }
1210 
1211   modifier mintCompliance(uint256 _mintAmount) {
1212     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1213     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1214     _;
1215   }
1216 
1217   function totalSupply() public view returns (uint256) {
1218     return supply.current();
1219   }
1220 
1221   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1222     require(!paused, "The contract is paused!");
1223     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
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
1303   function setPaused(bool _state) public onlyOwner {
1304     paused = _state;
1305   }
1306 
1307   function withdraw() public onlyOwner {
1308 
1309     // This will transfer the remaining contract balance to the owner.
1310     // Do not remove this otherwise you will not be able to withdraw the funds.
1311     // =============================================================================
1312     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1313     require(os);
1314     // =============================================================================
1315   }
1316 
1317   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1318     for (uint256 i = 0; i < _mintAmount; i++) {
1319       supply.increment();
1320       _safeMint(_receiver, supply.current());
1321     }
1322   }
1323 
1324   function _baseURI() internal view virtual override returns (string memory) {
1325     return uriPrefix;
1326   }
1327 }