1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 //Albert Banez
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @title Counters
12  * @author Matt Condon (@shrugs)
13  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
14  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
15  *
16  * Include with `using Counters for Counters.Counter;`
17  */
18 library Counters {
19     struct Counter {
20         // This variable should never be directly accessed by users of the library: interactions must be restricted to
21         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
22         // this feature: see https://github.com/ethereum/solidity/issues/4637
23         uint256 _value; // default: 0
24     }
25 
26     function current(Counter storage counter) internal view returns (uint256) {
27         return counter._value;
28     }
29 
30     function increment(Counter storage counter) internal {
31         unchecked {
32             counter._value += 1;
33         }
34     }
35 
36     function decrement(Counter storage counter) internal {
37         uint256 value = counter._value;
38         require(value > 0, "Counter: decrement overflow");
39         unchecked {
40             counter._value = value - 1;
41         }
42     }
43 
44     function reset(Counter storage counter) internal {
45         counter._value = 0;
46     }
47 }
48 
49 // File: @openzeppelin/contracts/utils/Strings.sol
50 
51 
52 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
53 
54 pragma solidity ^0.8.0;
55 
56 /**
57  * @dev String operations.
58  */
59 library Strings {
60     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
64      */
65     function toString(uint256 value) internal pure returns (string memory) {
66         // Inspired by OraclizeAPI's implementation - MIT licence
67         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
68 
69         if (value == 0) {
70             return "0";
71         }
72         uint256 temp = value;
73         uint256 digits;
74         while (temp != 0) {
75             digits++;
76             temp /= 10;
77         }
78         bytes memory buffer = new bytes(digits);
79         while (value != 0) {
80             digits -= 1;
81             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
82             value /= 10;
83         }
84         return string(buffer);
85     }
86 
87     /**
88      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
89      */
90     function toHexString(uint256 value) internal pure returns (string memory) {
91         if (value == 0) {
92             return "0x00";
93         }
94         uint256 temp = value;
95         uint256 length = 0;
96         while (temp != 0) {
97             length++;
98             temp >>= 8;
99         }
100         return toHexString(value, length);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
105      */
106     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
107         bytes memory buffer = new bytes(2 * length + 2);
108         buffer[0] = "0";
109         buffer[1] = "x";
110         for (uint256 i = 2 * length + 1; i > 1; --i) {
111             buffer[i] = _HEX_SYMBOLS[value & 0xf];
112             value >>= 4;
113         }
114         require(value == 0, "Strings: hex length insufficient");
115         return string(buffer);
116     }
117 }
118 
119 // File: @openzeppelin/contracts/utils/Context.sol
120 
121 
122 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
123 
124 pragma solidity ^0.8.0;
125 
126 /**
127  * @dev Provides information about the current execution context, including the
128  * sender of the transaction and its data. While these are generally available
129  * via msg.sender and msg.data, they should not be accessed in such a direct
130  * manner, since when dealing with meta-transactions the account sending and
131  * paying for execution may not be the actual sender (as far as an application
132  * is concerned).
133  *
134  * This contract is only required for intermediate, library-like contracts.
135  */
136 abstract contract Context {
137     function _msgSender() internal view virtual returns (address) {
138         return msg.sender;
139     }
140 
141     function _msgData() internal view virtual returns (bytes calldata) {
142         return msg.data;
143     }
144 }
145 
146 // File: @openzeppelin/contracts/access/Ownable.sol
147 
148 
149 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 
154 /**
155  * @dev Contract module which provides a basic access control mechanism, where
156  * there is an account (an owner) that can be granted exclusive access to
157  * specific functions.
158  *
159  * By default, the owner account will be the one that deploys the contract. This
160  * can later be changed with {transferOwnership}.
161  *
162  * This module is used through inheritance. It will make available the modifier
163  * `onlyOwner`, which can be applied to your functions to restrict their use to
164  * the owner.
165  */
166 abstract contract Ownable is Context {
167     address private _owner;
168 
169     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
170 
171     /**
172      * @dev Initializes the contract setting the deployer as the initial owner.
173      */
174     constructor() {
175         _transferOwnership(_msgSender());
176     }
177 
178     /**
179      * @dev Returns the address of the current owner.
180      */
181     function owner() public view virtual returns (address) {
182         return _owner;
183     }
184 
185     /**
186      * @dev Throws if called by any account other than the owner.
187      */
188     modifier onlyOwner() {
189         require(owner() == _msgSender(), "Ownable: caller is not the owner");
190         _;
191     }
192 
193     /**
194      * @dev Leaves the contract without owner. It will not be possible to call
195      * `onlyOwner` functions anymore. Can only be called by the current owner.
196      *
197      * NOTE: Renouncing ownership will leave the contract without an owner,
198      * thereby removing any functionality that is only available to the owner.
199      */
200     function renounceOwnership() public virtual onlyOwner {
201         _transferOwnership(address(0));
202     }
203 
204     /**
205      * @dev Transfers ownership of the contract to a new account (`newOwner`).
206      * Can only be called by the current owner.
207      */
208     function transferOwnership(address newOwner) public virtual onlyOwner {
209         require(newOwner != address(0), "Ownable: new owner is the zero address");
210         _transferOwnership(newOwner);
211     }
212 
213     /**
214      * @dev Transfers ownership of the contract to a new account (`newOwner`).
215      * Internal function without access restriction.
216      */
217     function _transferOwnership(address newOwner) internal virtual {
218         address oldOwner = _owner;
219         _owner = newOwner;
220         emit OwnershipTransferred(oldOwner, newOwner);
221     }
222 }
223 
224 // File: @openzeppelin/contracts/utils/Address.sol
225 
226 
227 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
228 
229 pragma solidity ^0.8.1;
230 
231 /**
232  * @dev Collection of functions related to the address type
233  */
234 library Address {
235     /**
236      * @dev Returns true if `account` is a contract.
237      *
238      * [IMPORTANT]
239      * ====
240      * It is unsafe to assume that an address for which this function returns
241      * false is an externally-owned account (EOA) and not a contract.
242      *
243      * Among others, `isContract` will return false for the following
244      * types of addresses:
245      *
246      *  - an externally-owned account
247      *  - a contract in construction
248      *  - an address where a contract will be created
249      *  - an address where a contract lived, but was destroyed
250      * ====
251      *
252      * [IMPORTANT]
253      * ====
254      * You shouldn't rely on `isContract` to protect against flash loan attacks!
255      *
256      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
257      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
258      * constructor.
259      * ====
260      */
261     function isContract(address account) internal view returns (bool) {
262         // This method relies on extcodesize/address.code.length, which returns 0
263         // for contracts in construction, since the code is only stored at the end
264         // of the constructor execution.
265 
266         return account.code.length > 0;
267     }
268 
269     /**
270      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
271      * `recipient`, forwarding all available gas and reverting on errors.
272      *
273      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
274      * of certain opcodes, possibly making contracts go over the 2300 gas limit
275      * imposed by `transfer`, making them unable to receive funds via
276      * `transfer`. {sendValue} removes this limitation.
277      *
278      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
279      *
280      * IMPORTANT: because control is transferred to `recipient`, care must be
281      * taken to not create reentrancy vulnerabilities. Consider using
282      * {ReentrancyGuard} or the
283      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
284      */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         (bool success, ) = recipient.call{value: amount}("");
289         require(success, "Address: unable to send value, recipient may have reverted");
290     }
291 
292     /**
293      * @dev Performs a Solidity function call using a low level `call`. A
294      * plain `call` is an unsafe replacement for a function call: use this
295      * function instead.
296      *
297      * If `target` reverts with a revert reason, it is bubbled up by this
298      * function (like regular Solidity function calls).
299      *
300      * Returns the raw returned data. To convert to the expected return value,
301      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
302      *
303      * Requirements:
304      *
305      * - `target` must be a contract.
306      * - calling `target` with `data` must not revert.
307      *
308      * _Available since v3.1._
309      */
310     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
311         return functionCall(target, data, "Address: low-level call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
316      * `errorMessage` as a fallback revert reason when `target` reverts.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(
321         address target,
322         bytes memory data,
323         string memory errorMessage
324     ) internal returns (bytes memory) {
325         return functionCallWithValue(target, data, 0, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but also transferring `value` wei to `target`.
331      *
332      * Requirements:
333      *
334      * - the calling contract must have an ETH balance of at least `value`.
335      * - the called Solidity function must be `payable`.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(
340         address target,
341         bytes memory data,
342         uint256 value
343     ) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
349      * with `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(
354         address target,
355         bytes memory data,
356         uint256 value,
357         string memory errorMessage
358     ) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         require(isContract(target), "Address: call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.call{value: value}(data);
363         return verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but performing a static call.
369      *
370      * _Available since v3.3._
371      */
372     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
373         return functionStaticCall(target, data, "Address: low-level static call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
378      * but performing a static call.
379      *
380      * _Available since v3.3._
381      */
382     function functionStaticCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal view returns (bytes memory) {
387         require(isContract(target), "Address: static call to non-contract");
388 
389         (bool success, bytes memory returndata) = target.staticcall(data);
390         return verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but performing a delegate call.
396      *
397      * _Available since v3.4._
398      */
399     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
400         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
405      * but performing a delegate call.
406      *
407      * _Available since v3.4._
408      */
409     function functionDelegateCall(
410         address target,
411         bytes memory data,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         require(isContract(target), "Address: delegate call to non-contract");
415 
416         (bool success, bytes memory returndata) = target.delegatecall(data);
417         return verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     /**
421      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
422      * revert reason using the provided one.
423      *
424      * _Available since v4.3._
425      */
426     function verifyCallResult(
427         bool success,
428         bytes memory returndata,
429         string memory errorMessage
430     ) internal pure returns (bytes memory) {
431         if (success) {
432             return returndata;
433         } else {
434             // Look for revert reason and bubble it up if present
435             if (returndata.length > 0) {
436                 // The easiest way to bubble the revert reason is using memory via assembly
437 
438                 assembly {
439                     let returndata_size := mload(returndata)
440                     revert(add(32, returndata), returndata_size)
441                 }
442             } else {
443                 revert(errorMessage);
444             }
445         }
446     }
447 }
448 
449 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
450 
451 
452 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
453 
454 pragma solidity ^0.8.0;
455 
456 /**
457  * @title ERC721 token receiver interface
458  * @dev Interface for any contract that wants to support safeTransfers
459  * from ERC721 asset contracts.
460  */
461 interface IERC721Receiver {
462     /**
463      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
464      * by `operator` from `from`, this function is called.
465      *
466      * It must return its Solidity selector to confirm the token transfer.
467      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
468      *
469      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
470      */
471     function onERC721Received(
472         address operator,
473         address from,
474         uint256 tokenId,
475         bytes calldata data
476     ) external returns (bytes4);
477 }
478 
479 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
480 
481 
482 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
483 
484 pragma solidity ^0.8.0;
485 
486 /**
487  * @dev Interface of the ERC165 standard, as defined in the
488  * https://eips.ethereum.org/EIPS/eip-165[EIP].
489  *
490  * Implementers can declare support of contract interfaces, which can then be
491  * queried by others ({ERC165Checker}).
492  *
493  * For an implementation, see {ERC165}.
494  */
495 interface IERC165 {
496     /**
497      * @dev Returns true if this contract implements the interface defined by
498      * `interfaceId`. See the corresponding
499      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
500      * to learn more about how these ids are created.
501      *
502      * This function call must use less than 30 000 gas.
503      */
504     function supportsInterface(bytes4 interfaceId) external view returns (bool);
505 }
506 
507 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
508 
509 
510 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 
515 /**
516  * @dev Implementation of the {IERC165} interface.
517  *
518  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
519  * for the additional interface id that will be supported. For example:
520  *
521  * ```solidity
522  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
523  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
524  * }
525  * ```
526  *
527  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
528  */
529 abstract contract ERC165 is IERC165 {
530     /**
531      * @dev See {IERC165-supportsInterface}.
532      */
533     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
534         return interfaceId == type(IERC165).interfaceId;
535     }
536 }
537 
538 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
539 
540 
541 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 
546 /**
547  * @dev Required interface of an ERC721 compliant contract.
548  */
549 interface IERC721 is IERC165 {
550     /**
551      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
552      */
553     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
554 
555     /**
556      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
557      */
558     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
559 
560     /**
561      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
562      */
563     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
564 
565     /**
566      * @dev Returns the number of tokens in ``owner``'s account.
567      */
568     function balanceOf(address owner) external view returns (uint256 balance);
569 
570     /**
571      * @dev Returns the owner of the `tokenId` token.
572      *
573      * Requirements:
574      *
575      * - `tokenId` must exist.
576      */
577     function ownerOf(uint256 tokenId) external view returns (address owner);
578 
579     /**
580      * @dev Safely transfers `tokenId` token from `from` to `to`.
581      *
582      * Requirements:
583      *
584      * - `from` cannot be the zero address.
585      * - `to` cannot be the zero address.
586      * - `tokenId` token must exist and be owned by `from`.
587      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
588      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
589      *
590      * Emits a {Transfer} event.
591      */
592     function safeTransferFrom(
593         address from,
594         address to,
595         uint256 tokenId,
596         bytes calldata data
597     ) external;
598 
599     /**
600      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
601      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
602      *
603      * Requirements:
604      *
605      * - `from` cannot be the zero address.
606      * - `to` cannot be the zero address.
607      * - `tokenId` token must exist and be owned by `from`.
608      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
609      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
610      *
611      * Emits a {Transfer} event.
612      */
613     function safeTransferFrom(
614         address from,
615         address to,
616         uint256 tokenId
617     ) external;
618 
619     /**
620      * @dev Transfers `tokenId` token from `from` to `to`.
621      *
622      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
623      *
624      * Requirements:
625      *
626      * - `from` cannot be the zero address.
627      * - `to` cannot be the zero address.
628      * - `tokenId` token must be owned by `from`.
629      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
630      *
631      * Emits a {Transfer} event.
632      */
633     function transferFrom(
634         address from,
635         address to,
636         uint256 tokenId
637     ) external;
638 
639     /**
640      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
641      * The approval is cleared when the token is transferred.
642      *
643      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
644      *
645      * Requirements:
646      *
647      * - The caller must own the token or be an approved operator.
648      * - `tokenId` must exist.
649      *
650      * Emits an {Approval} event.
651      */
652     function approve(address to, uint256 tokenId) external;
653 
654     /**
655      * @dev Approve or remove `operator` as an operator for the caller.
656      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
657      *
658      * Requirements:
659      *
660      * - The `operator` cannot be the caller.
661      *
662      * Emits an {ApprovalForAll} event.
663      */
664     function setApprovalForAll(address operator, bool _approved) external;
665 
666     /**
667      * @dev Returns the account approved for `tokenId` token.
668      *
669      * Requirements:
670      *
671      * - `tokenId` must exist.
672      */
673     function getApproved(uint256 tokenId) external view returns (address operator);
674 
675     /**
676      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
677      *
678      * See {setApprovalForAll}
679      */
680     function isApprovedForAll(address owner, address operator) external view returns (bool);
681 }
682 
683 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
684 
685 
686 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 
691 /**
692  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
693  * @dev See https://eips.ethereum.org/EIPS/eip-721
694  */
695 interface IERC721Metadata is IERC721 {
696     /**
697      * @dev Returns the token collection name.
698      */
699     function name() external view returns (string memory);
700 
701     /**
702      * @dev Returns the token collection symbol.
703      */
704     function symbol() external view returns (string memory);
705 
706     /**
707      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
708      */
709     function tokenURI(uint256 tokenId) external view returns (string memory);
710 }
711 
712 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
713 
714 
715 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
716 
717 pragma solidity ^0.8.0;
718 
719 
720 
721 
722 
723 
724 
725 
726 /**
727  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
728  * the Metadata extension, but not including the Enumerable extension, which is available separately as
729  * {ERC721Enumerable}.
730  */
731 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
732     using Address for address;
733     using Strings for uint256;
734 
735     // Token name
736     string private _name;
737 
738     // Token symbol
739     string private _symbol;
740 
741     // Mapping from token ID to owner address
742     mapping(uint256 => address) private _owners;
743 
744     // Mapping owner address to token count
745     mapping(address => uint256) private _balances;
746 
747     // Mapping from token ID to approved address
748     mapping(uint256 => address) private _tokenApprovals;
749 
750     // Mapping from owner to operator approvals
751     mapping(address => mapping(address => bool)) private _operatorApprovals;
752 
753     /**
754      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
755      */
756     constructor(string memory name_, string memory symbol_) {
757         _name = name_;
758         _symbol = symbol_;
759     }
760 
761     /**
762      * @dev See {IERC165-supportsInterface}.
763      */
764     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
765         return
766             interfaceId == type(IERC721).interfaceId ||
767             interfaceId == type(IERC721Metadata).interfaceId ||
768             super.supportsInterface(interfaceId);
769     }
770 
771     /**
772      * @dev See {IERC721-balanceOf}.
773      */
774     function balanceOf(address owner) public view virtual override returns (uint256) {
775         require(owner != address(0), "ERC721: balance query for the zero address");
776         return _balances[owner];
777     }
778 
779     /**
780      * @dev See {IERC721-ownerOf}.
781      */
782     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
783         address owner = _owners[tokenId];
784         require(owner != address(0), "ERC721: owner query for nonexistent token");
785         return owner;
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-name}.
790      */
791     function name() public view virtual override returns (string memory) {
792         return _name;
793     }
794 
795     /**
796      * @dev See {IERC721Metadata-symbol}.
797      */
798     function symbol() public view virtual override returns (string memory) {
799         return _symbol;
800     }
801 
802     /**
803      * @dev See {IERC721Metadata-tokenURI}.
804      */
805     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
806         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
807 
808         string memory baseURI = _baseURI();
809         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
810     }
811 
812     /**
813      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
814      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
815      * by default, can be overridden in child contracts.
816      */
817     function _baseURI() internal view virtual returns (string memory) {
818         return "";
819     }
820 
821     /**
822      * @dev See {IERC721-approve}.
823      */
824     function approve(address to, uint256 tokenId) public virtual override {
825         address owner = ERC721.ownerOf(tokenId);
826         require(to != owner, "ERC721: approval to current owner");
827 
828         require(
829             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
830             "ERC721: approve caller is not owner nor approved for all"
831         );
832 
833         _approve(to, tokenId);
834     }
835 
836     /**
837      * @dev See {IERC721-getApproved}.
838      */
839     function getApproved(uint256 tokenId) public view virtual override returns (address) {
840         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
841 
842         return _tokenApprovals[tokenId];
843     }
844 
845     /**
846      * @dev See {IERC721-setApprovalForAll}.
847      */
848     function setApprovalForAll(address operator, bool approved) public virtual override {
849         _setApprovalForAll(_msgSender(), operator, approved);
850     }
851 
852     /**
853      * @dev See {IERC721-isApprovedForAll}.
854      */
855     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
856         return _operatorApprovals[owner][operator];
857     }
858 
859     /**
860      * @dev See {IERC721-transferFrom}.
861      */
862     function transferFrom(
863         address from,
864         address to,
865         uint256 tokenId
866     ) public virtual override {
867         //solhint-disable-next-line max-line-length
868         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
869 
870         _transfer(from, to, tokenId);
871     }
872 
873     /**
874      * @dev See {IERC721-safeTransferFrom}.
875      */
876     function safeTransferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) public virtual override {
881         safeTransferFrom(from, to, tokenId, "");
882     }
883 
884     /**
885      * @dev See {IERC721-safeTransferFrom}.
886      */
887     function safeTransferFrom(
888         address from,
889         address to,
890         uint256 tokenId,
891         bytes memory _data
892     ) public virtual override {
893         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
894         _safeTransfer(from, to, tokenId, _data);
895     }
896 
897     /**
898      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
899      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
900      *
901      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
902      *
903      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
904      * implement alternative mechanisms to perform token transfer, such as signature-based.
905      *
906      * Requirements:
907      *
908      * - `from` cannot be the zero address.
909      * - `to` cannot be the zero address.
910      * - `tokenId` token must exist and be owned by `from`.
911      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
912      *
913      * Emits a {Transfer} event.
914      */
915     function _safeTransfer(
916         address from,
917         address to,
918         uint256 tokenId,
919         bytes memory _data
920     ) internal virtual {
921         _transfer(from, to, tokenId);
922         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
923     }
924 
925     /**
926      * @dev Returns whether `tokenId` exists.
927      *
928      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
929      *
930      * Tokens start existing when they are minted (`_mint`),
931      * and stop existing when they are burned (`_burn`).
932      */
933     function _exists(uint256 tokenId) internal view virtual returns (bool) {
934         return _owners[tokenId] != address(0);
935     }
936 
937     /**
938      * @dev Returns whether `spender` is allowed to manage `tokenId`.
939      *
940      * Requirements:
941      *
942      * - `tokenId` must exist.
943      */
944     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
945         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
946         address owner = ERC721.ownerOf(tokenId);
947         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
948     }
949 
950     /**
951      * @dev Safely mints `tokenId` and transfers it to `to`.
952      *
953      * Requirements:
954      *
955      * - `tokenId` must not exist.
956      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _safeMint(address to, uint256 tokenId) internal virtual {
961         _safeMint(to, tokenId, "");
962     }
963 
964     /**
965      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
966      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
967      */
968     function _safeMint(
969         address to,
970         uint256 tokenId,
971         bytes memory _data
972     ) internal virtual {
973         _mint(to, tokenId);
974         require(
975             _checkOnERC721Received(address(0), to, tokenId, _data),
976             "ERC721: transfer to non ERC721Receiver implementer"
977         );
978     }
979 
980     /**
981      * @dev Mints `tokenId` and transfers it to `to`.
982      *
983      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
984      *
985      * Requirements:
986      *
987      * - `tokenId` must not exist.
988      * - `to` cannot be the zero address.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _mint(address to, uint256 tokenId) internal virtual {
993         require(to != address(0), "ERC721: mint to the zero address");
994         require(!_exists(tokenId), "ERC721: token already minted");
995 
996         _beforeTokenTransfer(address(0), to, tokenId);
997 
998         _balances[to] += 1;
999         _owners[tokenId] = to;
1000 
1001         emit Transfer(address(0), to, tokenId);
1002 
1003         _afterTokenTransfer(address(0), to, tokenId);
1004     }
1005 
1006     /**
1007      * @dev Destroys `tokenId`.
1008      * The approval is cleared when the token is burned.
1009      *
1010      * Requirements:
1011      *
1012      * - `tokenId` must exist.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function _burn(uint256 tokenId) internal virtual {
1017         address owner = ERC721.ownerOf(tokenId);
1018 
1019         _beforeTokenTransfer(owner, address(0), tokenId);
1020 
1021         // Clear approvals
1022         _approve(address(0), tokenId);
1023 
1024         _balances[owner] -= 1;
1025         delete _owners[tokenId];
1026 
1027         emit Transfer(owner, address(0), tokenId);
1028 
1029         _afterTokenTransfer(owner, address(0), tokenId);
1030     }
1031 
1032     /**
1033      * @dev Transfers `tokenId` from `from` to `to`.
1034      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1035      *
1036      * Requirements:
1037      *
1038      * - `to` cannot be the zero address.
1039      * - `tokenId` token must be owned by `from`.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function _transfer(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) internal virtual {
1048         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1049         require(to != address(0), "ERC721: transfer to the zero address");
1050 
1051         _beforeTokenTransfer(from, to, tokenId);
1052 
1053         // Clear approvals from the previous owner
1054         _approve(address(0), tokenId);
1055 
1056         _balances[from] -= 1;
1057         _balances[to] += 1;
1058         _owners[tokenId] = to;
1059 
1060         emit Transfer(from, to, tokenId);
1061 
1062         _afterTokenTransfer(from, to, tokenId);
1063     }
1064 
1065     /**
1066      * @dev Approve `to` to operate on `tokenId`
1067      *
1068      * Emits a {Approval} event.
1069      */
1070     function _approve(address to, uint256 tokenId) internal virtual {
1071         _tokenApprovals[tokenId] = to;
1072         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1073     }
1074 
1075     /**
1076      * @dev Approve `operator` to operate on all of `owner` tokens
1077      *
1078      * Emits a {ApprovalForAll} event.
1079      */
1080     function _setApprovalForAll(
1081         address owner,
1082         address operator,
1083         bool approved
1084     ) internal virtual {
1085         require(owner != operator, "ERC721: approve to caller");
1086         _operatorApprovals[owner][operator] = approved;
1087         emit ApprovalForAll(owner, operator, approved);
1088     }
1089 
1090     /**
1091      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1092      * The call is not executed if the target address is not a contract.
1093      *
1094      * @param from address representing the previous owner of the given token ID
1095      * @param to target address that will receive the tokens
1096      * @param tokenId uint256 ID of the token to be transferred
1097      * @param _data bytes optional data to send along with the call
1098      * @return bool whether the call correctly returned the expected magic value
1099      */
1100     function _checkOnERC721Received(
1101         address from,
1102         address to,
1103         uint256 tokenId,
1104         bytes memory _data
1105     ) private returns (bool) {
1106         if (to.isContract()) {
1107             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1108                 return retval == IERC721Receiver.onERC721Received.selector;
1109             } catch (bytes memory reason) {
1110                 if (reason.length == 0) {
1111                     revert("ERC721: transfer to non ERC721Receiver implementer");
1112                 } else {
1113                     assembly {
1114                         revert(add(32, reason), mload(reason))
1115                     }
1116                 }
1117             }
1118         } else {
1119             return true;
1120         }
1121     }
1122 
1123     /**
1124      * @dev Hook that is called before any token transfer. This includes minting
1125      * and burning.
1126      *
1127      * Calling conditions:
1128      *
1129      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1130      * transferred to `to`.
1131      * - When `from` is zero, `tokenId` will be minted for `to`.
1132      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1133      * - `from` and `to` are never both zero.
1134      *
1135      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1136      */
1137     function _beforeTokenTransfer(
1138         address from,
1139         address to,
1140         uint256 tokenId
1141     ) internal virtual {}
1142 
1143     /**
1144      * @dev Hook that is called after any transfer of tokens. This includes
1145      * minting and burning.
1146      *
1147      * Calling conditions:
1148      *
1149      * - when `from` and `to` are both non-zero.
1150      * - `from` and `to` are never both zero.
1151      *
1152      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1153      */
1154     function _afterTokenTransfer(
1155         address from,
1156         address to,
1157         uint256 tokenId
1158     ) internal virtual {}
1159 }
1160 
1161 // File: contracts/FashionCrypto.sol
1162 
1163 
1164 pragma solidity ^0.8.4;
1165 
1166 
1167 
1168 
1169 abstract contract WithLimitedSupply {
1170     using Counters for Counters.Counter;
1171     /// @dev Emitted when the supply of this collection changes
1172     event SupplyChanged(uint256 indexed supply);
1173 
1174     // Keeps track of how many we have minted
1175     Counters.Counter private _tokenCount;
1176 
1177     /// @dev The maximum count of tokens this token tracker will hold.
1178     uint256 private _totalSupply;
1179 
1180     /// Instanciate the contract
1181     /// @param totalSupply_ how many tokens this collection should hold
1182     constructor (uint256 totalSupply_) {
1183         _totalSupply = totalSupply_;
1184     }
1185 
1186     /// @dev Get the max Supply
1187     /// @return the maximum token count
1188     function totalSupply() public view virtual returns (uint256) {
1189         return _totalSupply;
1190     }
1191 
1192     /// @dev Get the current token count
1193     /// @return the created token count
1194     function tokenCount() public view returns (uint256) {
1195         return _tokenCount.current();
1196     }
1197 
1198     /// @dev Check whether tokens are still available
1199     /// @return the available token count
1200     function availableTokenCount() public view returns (uint256) {
1201         return totalSupply() - tokenCount();
1202     }
1203 
1204     /// @dev Increment the token count and fetch the latest count
1205     /// @return the next token id
1206     function nextToken() internal virtual returns (uint256) {
1207         uint256 token = _tokenCount.current();
1208 
1209         _tokenCount.increment();
1210 
1211         return token;
1212     }
1213 
1214     /// @dev Check whether another token is still available
1215     modifier ensureAvailability() {
1216         require(availableTokenCount() > 0, "No more tokens available");
1217         _;
1218     }
1219 
1220     /// @param amount Check whether number of tokens are still available
1221     /// @dev Check whether tokens are still available
1222     modifier ensureAvailabilityFor(uint256 amount) {
1223         require(availableTokenCount() >= amount, "Requested number of tokens not available");
1224         _;
1225     }
1226 
1227     /// Update the supply for the collection
1228     /// @param _supply the new token supply.
1229     /// @dev create additional token supply for this collection.
1230     function _setSupply(uint256 _supply) internal virtual {
1231         require(_supply > tokenCount(), "Can't set the supply to less than the current token count");
1232         _totalSupply = _supply;
1233 
1234         emit SupplyChanged(totalSupply());
1235     }
1236 }
1237 
1238 
1239 abstract contract RandomlyAssigned is WithLimitedSupply {
1240     // Used for random index assignment
1241     mapping(uint256 => uint256) private tokenMatrix;
1242 
1243     // The initial token ID
1244     uint256 private startFrom;
1245 
1246     //uint256 public preSaleStartTime = 1653390000; //May 24, 8PM
1247     //uint256 public preSaleEndTime = 1653940800; //May 30, 8PM
1248 
1249     //Changing the startIndex
1250     event startIndexChange(uint oldValue, uint256 newValue);
1251 
1252     /// Instanciate the contract
1253     /// @param _totalSupply how many tokens this collection should hold
1254     /// @param _startFrom the tokenID with which to start counting
1255     constructor (uint256 _totalSupply, uint256 _startFrom)
1256         WithLimitedSupply(_totalSupply)
1257     {
1258         startFrom = _startFrom;
1259     }
1260 
1261     /// Get the next token ID
1262     /// @dev Randomly gets a new token ID and keeps track of the ones that are still available.
1263     /// @return the next token ID
1264     function nextToken() internal override ensureAvailability returns (uint256) {
1265         uint256 maxIndex = totalSupply() - tokenCount();
1266         uint256 random = uint256(keccak256(
1267             abi.encodePacked(
1268                 msg.sender,
1269                 block.coinbase,
1270                 block.difficulty,
1271                 block.gaslimit,
1272                 block.timestamp
1273             )
1274         )) % maxIndex;
1275 
1276         uint256 value = 0;
1277         if (tokenMatrix[random] == 0) {
1278             // If this matrix position is empty, set the value to the generated random number.
1279             value = random;
1280         } else {
1281             // Otherwise, use the previously stored number from the matrix.
1282             value = tokenMatrix[random];
1283         }
1284 
1285         // If the last available tokenID is still unused...
1286         if (tokenMatrix[maxIndex - 1] == 0) {
1287             // ...store that ID in the current matrix position.
1288             tokenMatrix[random] = maxIndex - 1;
1289         } else {
1290             // ...otherwise copy over the stored number to the current matrix position.
1291             tokenMatrix[random] = tokenMatrix[maxIndex - 1];
1292         }
1293 
1294         // Increment counts
1295         super.nextToken();
1296 
1297         return value + startFrom;
1298     }
1299 
1300     function _setStartFrom(uint256 index) internal virtual {
1301         uint256 prevStarFrom =startFrom;
1302         startFrom = index;
1303         emit startIndexChange(prevStarFrom, index);
1304     }
1305 }
1306 
1307 contract FashionCrypto is ERC721, Ownable, WithLimitedSupply  {
1308     using Strings for uint256;
1309     string public baseURI= "https://fashioncrypto.io/data/fashion/json/";
1310     string baseExtension = ".json";
1311 
1312     uint256 public cost = 0.05 ether;
1313     address public ownerAddress = 0xcff635D73F4Cd7C4005cFC3FE7cc01bb60F42FDd;
1314     bool public blnSale = true;
1315     bool public blnWhitelisted = true;
1316     uint256 public startIndex = 50;
1317     uint256 public endIndex = 250;
1318     uint256[] private usedTokenId;
1319     uint8 public batchMintMaxAmount = 5;    
1320     uint8 public whiteOneMax = 10;    
1321     uint8 public whiteTwoMax = 1;    
1322 
1323 address[] private whitelistedAddressesOne =[0xcff635D73F4Cd7C4005cFC3FE7cc01bb60F42FDd, 0xe03895910e1190d846AeD3BEB317A84E1Ff892d2,
1324 0x4e48783F618ecB06ddFB07D36c49119C2b82F0F4,
1325 0xc20873d40e6F75BF6C39F3BB48bFC1847f335dE2,
1326 0xaA3FcbF8ac0B093C20978EE025e25D95943B7a27,
1327 0x5b2e7eCB43E61B30a7d0B3B698C430b204C22dBD,
1328 0xBA8B0Ea93F9c7cf473e7f99E3bD52AFD37fa55eF,
1329 0xBb209d8F0497e7b64813a7F91960a88d182331E9,
1330 0x7B56dEB150df9dD428C1770fFDf334468f92a444,
1331 0xbaDF8a6bA6EbF14E7690cb95782f5e492Cc47d75,
1332 0x2224BC00EAD1d90365d860ed0C6A21363dA40784,
1333 0x8872485d20694495aEccb098692270C3Ee419935,
1334 0x0fF745e8Df3BCef82D59A8b8fB9cE8c542534136,
1335 0x62017eb3cBc67F977A4bf962cF2Dc49C537f6cCa,
1336 0xF133Ee684d71aA470D7B3ef2868cafaBa53E473e,
1337 0xdf2cd7b522aaeF6dC418CF83cc1e815C1E2Bf8B0,
1338 0x2e2489628CD9f1B98DfB83BB57DA2d0C10109019,
1339 0x9119cc7143250C43b82A02f63BaCF7bDea930669,
1340 0xbA87461c49666f72AFC1D2D805aF6dEB2E193A70,
1341 0x575848A2a2fBf466d31a42820c90F7a71950192D,
1342 0x2a1D69a0830f6094ec318d93A8779dB877871736,
1343 0x500A9D4b9463dA8ef6885b13A66c32916a68af7a,
1344 0x04606154dA2844fa6147F54e3A035651CEB2b197,
1345 0xb6c5feC131aC371456B92B406C25948A83AcaBC1,
1346 0x1cfe6cFD5DbEFD1a5B09524c949e4c4A606972Da,
1347 0x2E8b6a975F7B0edCfe78A2E377329B6c575DC50F,
1348 0x875B1A1Dd84Edf1012fa0d7A0c997425Fda12eFf,
1349 0x138B5C84ba91ea4b95739A527e340489FeF2FE28,
1350 0x3E0034B5D25bdB668EEc68e2643A2DFcFE786766,
1351 0x5DE51b7944c766b1CAdce299463059bdEc38C1BF,
1352 0x23EbD54Fd65825e06a6e5AACc1A0b523BFeb748e,
1353 0xc30d117D16f6eB743BB0019e7863671919368cD1,
1354 0x1557299331AAe614896e4fDC82D882C62Fb62302,
1355 0x108C04d9145c93fE9E3B07Ad27698EDFd5e6e498,
1356 0x4f355A9C74Bd22A90fa32DE4cD129da1999520aA,
1357 0x6cB9C2c61908658e3C9875C864B5e2CAb2f21a4c,
1358 0xE8b7a54AC34D1bA55Fd0E92a79136E7A225C2451,
1359 0xf81Ef872db0ff70bDD3D7b729Ff0440E72b33b18,
1360 0x2eFe4fA1D55880879800638021632F6b9c6F088C,
1361 0xC88f6A403D1F2Ff76c6aB4a71ece88aA6321A40E,
1362 0xd45D61a7762Ed1236b275caDA5f1171D74E008ab,
1363 0x1da10F21F60920d940506939148Cac505315a707,
1364 0xf4a33929872B87BB67dDCAC38548c808DD38F2ae,
1365 0x545FF76F9Ee769B144cb79146c1069cfa0ef2A9f,
1366 0xda4486A591B4543562713cE1413f34b44D3af45A,
1367 0xBD3b7cCd7F58C40DD1150d3487f854f468357D4c,
1368 0x869A83C3D912318fb8FcAC6ADadDaA50c2F373f6,
1369 0xfef634E9Adc613871DE7FE764c38101d8fE85d68,
1370 0x04f7244581360ae45eE6d136dd9ec64926c9386C,
1371 0x012Bf606c1f1AB362A62dBC3e3d3e937027e198D,
1372 0xB18cCecd1FbEBC7C3E30Cc70983720D9d672e8ca,
1373 0x2834e08F4EeCd7b63A6FEFb8eBAadB3fDD277602,
1374 0xE944b8ebBDE99A4D29Ba3faC1931435352d07956,
1375 0xA0DbD3771a4fB21B517BbEa198bC335A44601A4E,
1376 0x2CCc19E242e2f4C2541DAD341be3792Ac0eEd010,
1377 0x16a20ac1719E1F68d663de5504fe58fE9b1ed758,
1378 0xa1ce1e761695fCdB0288d94d3bc08e825064C0a3,
1379 0x67DC869ef404607977833B7810310bA1466324B4,
1380 0x73EB4c1DADb5cee393DA1e80b9a7098fa5afd437,
1381 0x0955C6965Df31558C5D2a7A0F66631c16Dd42980,
1382 0xBE19aa80959bc7c85970AEe306Ecef2cC03844E2,
1383 0x87d7C97B5a69c26C5CBC99b1B27937eDf5ccA10d,
1384 0x5ad430F7eeB9af006001fd21F9Ab27E1b994b506,
1385 0x513db322a397701BF624B517B00291F82B665884,
1386 0x520F3AFd4d156e71Fc26F330AcA6f89E083ff524,
1387 0xF24c2c1A7d479F6B50D6c2065Da97366Ec9Fe39F,
1388 0xe11394F5F5BD7244e73A253B2081Ba5BAA7d2432,
1389 0xf5a9B8Ea9fb71aB2dA81A866d6877b4dd717f9d1,
1390 0x0a1D634e51809b93ae943c9faf6027F117315d7E,
1391 0xeaF63e1917F0B67b8dB58513115764b96Bf90320,
1392 0xD6Fe2aC29E9A8ba1ed61B7689BFA864b31E8f3E6,
1393 0xe2338c6f7148b792CE76a56F6Ff22aFaEbb9c4EA,
1394 0xEF64c2Ac694185DBe61bC74E1505f28C86AB3AC0,
1395 0x669f900DeA5cA376d9a7B6ceDB7D1ec744A24102,
1396 0x0458f111cA216AdA7bB69bD673fF18c2816AeA27,
1397 0xC5D55B32F0D317882c0aAa3b0A963d8CBe094C7c,
1398 0xabe3E2EBd4784Dba6a80Fe341713Fc0532C219fb,
1399 0x9C1c8a2F2AcCc64DAd1C6bd26F0B36aa65Fce219,
1400 0x0A621d9bFf0E8d7978aD40282CBD28944Fef94df,
1401 0xaBc8c7DD623eA76780f9aaA11f429B9602A6ae15,
1402 0x0996Bb48A27E684414B151FfA0e902fB19543021,
1403 0x4AA5C3269420f3D82a96B515a6C470d3fb7db3Fd,
1404 0x31d226B0B94c3d13Cb067960f74e7f1e8aFd2EFD,
1405 0x919aED549781C36882952751AD2A6c33527C0260,
1406 0x4dBE58c21566Ebe2E48E009D4754461b606D990c,
1407 0x3A7546280C77611191e06637adCD0250A2C719Aa,
1408 0xC992BA0cE9aFdADfed23F1C3c654022e9E180686,
1409 0xb49E763A51236602402b3E858Ee76c319F7c27dD,
1410 0x83057f7bFb2d97eA7A9463F683db758aDCA71e8B,
1411 0x251417D5F3315134ffC2295f80D7BfddDB698c14,
1412 0xfB42cDc1EBa64d062Bf50644044aB5fE0E1282E8,
1413 0x4Ab3190Dee3D3191df678A9e324f5D243E0a8B54,
1414 0xd9344A213EAb0A9e8F15Dd3BBb2fDBdba35be368,
1415 0x65d51D3554c6908A75712F1312C971281C8Dd79A,
1416 0xB14Fa6697A7250f237291b56882331567cEFa3d4,
1417 0x29d25f171EDfD17B5bB0b66628fB5286b7D29aea,
1418 0xa3e371b5A01D8ce593A03f7248f42045d84A69F7,
1419 0x13A6FCF17523451716E768fBCf23C150E81d3A24,
1420 0x4eD3A923bD2DeEfaB72cd10E1152C2B5bbeF8506,
1421 0xB4384bbEdDe91d50e257A364f8341B4E73Cb4231,
1422 0xC907C13B7761575C403a6A79f04f9B3fAC6A6D03,
1423 0x5ed20622a0037972644aF6B04E73e80A30C984d2,
1424 0xf9BbD6b7a6224684f40A322232F7A011B96b873D,
1425 0x03E6c622e80b728e93e721AfB51480cbcbc18A60,
1426 0x2d1F22eAaeE458F7aFa58e29d71C746e2C326C27,
1427 0x32E62E30F4c2e93B2D458c99d01e6A129B0da931,
1428 0x87B6E64e98579fd7FB00bb9cEb76170faa8BACf7,
1429 0x8A1182A263A55B4eB07dEEDC301815076739Bd53,
1430 0x9bF8C690917b1a1D87a415a53636D3b0B9DFEBeA,
1431 0xdF5f4DCA715d7F0CA82502E3DA3f3100d0A5fec0,
1432 0x660e3533d3B089e48dEdc8b93A276a88258976a7,
1433 0x5A01887De253D6142ee7db6530F6F749dfE83b76,
1434 0x9f944958481BA262628957688DE6F4c3aAd9D805,
1435 0x34cE42EeB1548d521cE52D4d3Fafe7ccD8629E68,
1436 0xfc9b689b07776E3dcE406b8CDCFa4872AE3c9939,
1437 0xBB0DF31b908053Ee001053E667EEf5b79d1a7E55,
1438 0x1C0fbf1E1fD170010eca7016E6A9431Ca7c41D81,
1439 0xDAc33C13D2631a89B966E259b4Dfce38E21F05b9
1440 ];
1441     address[] private whitelistedAddressesTwo =[0xB5F442aAA72d1a56A5431C459d94cC228de3b7eD,
1442 0xA2EeC290592930350CC553Ef3a22Fa77CF9Bb058,
1443 0x75950A08c633C9cfC14dF1F3E04058bB0DDacF85,
1444 0xBa2e3b65A5E005cA8C8d3f36f4ba7Db9fE9F5948,
1445 0xA94D609db541E1E21FD1179a63Ac41A651584EDb,
1446 0xa8A5c10c39b6e0e42E09f288C1d122151550A722,
1447 0x5Bf7f1552a8e2E02ab42969a267A30F927eFAd60,
1448 0xc0c4ae2be965f660E109002d176D624B21c1CF13,
1449 0x22d0a06717E2bA3A232c371C50CD55DbB7879CC7,
1450 0x9044D452dC7A3506f363E6e8299c201ae344eA4A,
1451 0x3DF9b94f7717ADC8F331E25cC967038a1e58ad53,
1452 0xf5b529386e563cc25990E59afB5800f16d8F1189,
1453 0xC14031baa3fC1E4eC64E12A4279126Be2157D76d,
1454 0x051311C1D26443D6D87eb6A13A55ece32C97a7Ab,
1455 0x1a2dE0E9dEdb22376626d5dda00f238C56cA4835,
1456 0x3ac1C033c6ED5a4fb02014Cb984Aa3A055649E03,
1457 0xFB06C94A6Da258E787AA9260E38832278080319c,
1458 0x7a83B7EDB98956e7bC1aa107677354ea91608A38,
1459 0xF1DD9a61234Bb81e28c42A8F76CC3D2f02F8FaB7,
1460 0x61cC678Ac7AE5FD6A807480A7F229c1614fc6788,
1461 0xd64539430357Bb87066e8e0AF5EbBF962CD9588b,
1462 0xCB9DCD60980a74F27f381f93241A8b0Bf4B4A024,
1463 0x72aa1F778dA7D960f6eA60D3c6Dcb9a0F76D0408,
1464 0x8D5B11d815A6f35054b1B73e283FEA61b60737Be,
1465 0xc1d423aE49fba66AA713610811d13e0BECf213c6,
1466 0xA0a4A879B767EA2d6B23f7120F86f455c4E0A0cB,
1467 0x35d6Cd57f4B6D561ad52f8aB5E9E10E6c159aa5C,
1468 0x60f4Fbe6F706A67Bc560b4b7EecBb8f74193c658,
1469 0x38BBe79305f908DD87a4417347ffE5C4A0Ea0Ec9,
1470 0x2c120a611029B6E0d7d3827855592d3491191475,
1471 0xAeE79B5D2a67A18Ca2Fe9a4E614D633f9dD7969E,
1472 0x282C247EFC6408814A57ee1c2a0974042A54530e,
1473 0xd8C84502264E9E0505e34AFe480bC3eCa62Fdd1b,
1474 0x1851f43e431B74D1875FA966E26CB6a637790010,
1475 0xd5965bA259aFf23080eacEECEf99dd80afc51B70,
1476 0x123718c9F9B9c48048DA9A1134f9fCEa8E86a0D5,
1477 0x8dD6ACDA4459de971a385B00DF177Cf41006a027,
1478 0xe44659d918Ef53440C249bB5fA19ADbFfc057F82,
1479 0xDD1132316Ac5cD0c1f358CbC06d930b8A674270B,
1480 0xb4C006781B17a28fb68EB3B0D08c443E64A92cC1,
1481 0x7134bdcDE26EC21021579175Cb9C60a4C93e97E6,
1482 0x76F511623a40F35462Fda74847140bE5F1b23cE6,
1483 0xfCBA7891121114F6FcF9cd2549bE4Ee7208454f4,
1484 0x1fD6f1274AFBe571b66d19A8e8E1917a5e370E6e,
1485 0xCd1fe3f3361E1A49b3CC415e7B2D0BF0C83d35ad,
1486 0xFf2b935C5635A5aF779F8f040c4EEE6A1Fc772f2,
1487 0xDdEF9F37Db1012D93E027A59752a1Eb084652498,
1488 0x27dA21ab92aF4427f749F7aE282Cd3b9f29190Dd,
1489 0x88684818e4Db145B3E4D8DF61192F96A0ca12F2F,
1490 0x7C062b42720C5A16F67825476dEe09b3a2Dc13B1,
1491 0x0C85E48e616fdd33720c00baE14668e833C82DEC,
1492 0x119cE2117315b238c233c46a57Cd44d3F06B2fa9,
1493 0x5f80f73d93895B89BDA6d47ab374a33ef0F62380,
1494 0x2ae1f63142D9D81A65D882261A903ca4D06B5Bbe,
1495 0x3C407D6c0Bca77456EC7AfeEbdaad81E8b23aB31,
1496 0xC575cFaccbcC497C05936e70fCfC1a42D69F4CC0,
1497 0x3b609939B50d10Cf822274C62Daa9c6053ce0F74,
1498 0x6fC264D1AdacA3557d67d7A72a737F89dba13552,
1499 0x6327191Ea83a372eC049633665FB679a233835dA,
1500 0x6e04B6ac4bB1bd33E0490d126bCAd3c8e3C4f78D,
1501 0x6A501447C443b9aA58E91eF4505B24FF25940fE1,
1502 0x0445E3d6742F3Fd10a3781093e4f90bEFFaED31a,
1503 0x8bA7f68C6d89b7D232ffcf5f58719996799Bb8a2,
1504 0x657D736e04ccD506541f5A12044480eC93D2a308,
1505 0x9A00f5f51EF96d1e8414D620c077Ead407c28AE2,
1506 0x5ee9595c4912085B5A10CC884ee3D155920C35De,
1507 0xF19d298D79Da876F93893b9df830F94865E28662,
1508 0xa15Fab718b0cB25F82d61F58c014bD88a87EEED2,
1509 0xF72fa7Cdf36b3F58Eae1da8929B1F67972504aF8,
1510 0xB3Ec4C6C6B6aCa3DCe1ac400A9De37B8757e4B4C,
1511 0x9452297493f5c9d65BEca47f1e6d5Aac13dED2f7,
1512 0x6758608Ffc82E3c9F3520B94a0c77e8Ae2F6Bf7A,
1513 0x581d40199937e70C5f5757547f230d790B00EB85,
1514 0x02B3BF262Df4A97CE27383654C8858E73413F590,
1515 0x6C6A9F4C1B227e9507B1f7680e7B5734a0529802,
1516 0x82Ab0c87270Cc177B73b0d3e5cFD48a8f8FFD10d,
1517 0x4Dc68B875279eFb0D0c1c3292d79848AF402c0FA,
1518 0xf3F2F4c0c22F97A295091A4BE7f18a9F797E30Ae,
1519 0x764394B7cde04489f436Ac6E1F272Aae62fA65a1,
1520 0x251Fb2Fd729707dF6aF0C709681EFD25371cE8A9,
1521 0x04D2CB63c907421E5FC215d4064A31f41156f4B9,
1522 0x6c07aE8e5213115996867427B5DB8eDfc722900C,
1523 0xC641b1ff7aD7fAd7D37ff9B2854DcBCd167212E7,
1524 0x69512b193a2Fe70073b4c59cB9E27199B921DAc6,
1525 0x78C2493597D3e767279e03F0d3Fea8E126329dE0,
1526 0xcc811e52f35e758A24e0FEaA2b7439Bc21Ee4d21,
1527 0x31C9BcE1020Ac0880E285C36CE8a89693a9F13A4,
1528 0x4Ae2C32f298Db0dA192Cb225863bB797BbD9d1fb,
1529 0xFb2F62d691CA8c9dD07cd859aa0Ac2930d558F66,
1530 0xD6474B0b45834646FB3BD7e5F9c7096d97b66676,
1531 0xC5cE03F7A4de6c44198C5b84549c45F4F1af8d87,
1532 0x42D358F92Bd5d96D96c810625A5a13A483D149D7,
1533 0x17C30c09Ab306e10a2e9999e89BB1883C9835E5a,
1534 0x761225B1800af40fa73Ca615bb588cF63dD85BC7,
1535 0x47443460C613C9323b1bF54D42B2903fAFc11664,
1536 0x7179B654D852a93169db56dcDfBCea19Be1406Ca,
1537 0xccc105058D1528D3E3bC3490713da97c37377976,
1538 0x9bEDC4CE02dAdd1Eaac86362Dae44B909bFb24C4,
1539 0xe6a9b136C17745573D43569c22aBBde34f1512a9,
1540 0xe7552c4D4B655a100048689a32C41E92019217E9,
1541 0x519114e1f68Dd9aa14AE60a14519F4698cC5Ef4e,
1542 0x6F814B38fE1b1E3B6d7b323b66B500b97513CBb0,
1543 0x1c24732509eFd844B5F398C4a3c6e255744FDE0f,
1544 0x24e8cBCEce8eC14120Ae18d168Ceea059c6a4d3a,
1545 0xfaC8EE3E18a18d9AE90831B1F60d513A6839D7EB,
1546 0x271010FeEaC18Bc0C1f9082533A96EaCa2e30201,
1547 0x0A8A034C161d9Cda052f40Eff0b24D6A6a05fdC9,
1548 0xB1dc395a592856F7B5A9ae53B98aF8a64BDf6c85,
1549 0x5fFFf27BCCD898a8B88D5FA431600bb6c7b94117,
1550 0x92D3B546902f7ab1d7A595Dc3CF9F4C834C02fD4,
1551 0x28012C04EC61d20Bcf6612F9313b4cC7089716Dc,
1552 0x37a7679B309f62aE78C41092A60a0E7c994d7400,
1553 0x22443d3ec9aF561C49d8389B9CB06069b7b3d304,
1554 0x80ea006315A1c8278419BED1951c4fC047581641,
1555 0xE30363483d911f59176B83c976637b5A8FBdC9cD,
1556 0x834792b23B13035b8c38d8F37c9486099d5c2971,
1557 0x561eE7C9fCb2EFEEa5B7Bf3C55deA36B15C07Bdf,
1558 0x200404D036525Ce6F2056ce4c4cF8E25CC50B6d6,
1559 0xD3De7FD8BF1667D97Bb9aaE7bA738EfDf34641dC,
1560 0xDE7BC955c03aD2fc66955De7E4E84528260923bC,
1561 0xC622b5FB8046950A4E56E98FE2b2a0E97340B82C,
1562 0xBC5353f7a98412dC4583a8DBEFF5da3267aA264F,
1563 0x6D3b5F1191Da580f88D40B911D471991199836FE,
1564 0xA46666810794069Cc6eE3CEDb1AA62904dB24553,
1565 0x1D08f4F40cC8Ae7eA0B37115B2b48620a43Bf403,
1566 0xf18977B29C1F87F9871B8a7a5aF1e4059e39b9FE,
1567 0x86170f6B17B8bC41C0C06c8aa0C2d7754A3605C1,
1568 0x5a18a5a696c7f1b1D2c097D05d5e479D8f3eaEb6,
1569 0x1203D4615D87E159Df82401C7acC89b59b5C64F6,
1570 0xd1fEC8Da7edcfd651fBcBdE789aA27b38055F102,
1571 0x4C843a3D077C353533b81aD2435268C8611fDF16,
1572 0xDB8bc40369dACb601C21B2dc978F4988F51101cb,
1573 0xA75747f401d938593b8124e6eb08e910c16B20Da,
1574 0x37e0ec7fD9568a45dE59200aE69F01F8A69D59dF,
1575 0xB5457E56C5154536A6ABEe2654Cfa32efCAF5956,
1576 0x8661A1D4199A7b5372A488F6FaF590F179F98Dca,
1577 0x9896021a2D4E9124BE5827a2792d02189f26D798,
1578 0x0ab865AF5ab3c0854AfF619907c72A04E9c70DD7,
1579 0x16CDE6ef425fdF7997525E38C31b2FC2Ad0b44bb,
1580 0xCd33cfb6337032de97b74E1CBBFad835a9a4B9ce,
1581 0xe18Ba83765406fcAE655f57dE36c40B64C6d2c2e,
1582 0x845C9f3E5F63B739b27E92f50cAf55E695AFc902,
1583 0xc12cf671656eb6E835B31A907A33a4a00AF00165,
1584 0x93C3228B964b37947a4c7dA3E9FFf513dED3fF49,
1585 0x133B2f8476af944c434454695313082215d5c4b3,
1586 0x32474092852f1DA9f95A96fAF0FF3D254dfb1F91,
1587 0x3612397C7bED3d2E9337d46827e869A7B13eC3eb,
1588 0x760228f299677B1023b02Cbb1B9cf7147e077174,
1589 0x9b57E1B617343F29b6386c00d14e5189e38EdA71,
1590 0x0825Cf6a4115b770b4fd65373ff10ed51680E5Ee,
1591 0xa6bC0614Ae72d8189f53700e5B9b62D23bF115bC,
1592 0x8C41F8BB5b83De10AC8fbcd3CfC6ead69f84aD87,
1593 0xA21f6bC5BC20f221f16f85FfCA8eDF0Ec6637ecE,
1594 0x81A20A1c885a574a01d77b9847AA4f1D99EcDd3a,
1595 0xd17Ab43D8f8E55eaB25725A5988Cea80d172102A,
1596 0xF7789a8815FF679576943c8b57FA136C9dfF0754,
1597 0x69Dfe997A1185f22B0B0a786247afcf36b670817,
1598 0xE285834728BD7259791c6E6f63Ed0bAbA36Fa151,
1599 0xF728e65fF04a2185ac5508dC83a6f3634Af2ad4B,
1600 0xA84AefA8CF9377Fd80D9d0ccCC89A13fc308E206,
1601 0xA57394Fb12D0aB830E80dCC55B45114629F78b30,
1602 0xB00c93AB586Deed458864f262B0493194B02Ba84,
1603 0xebe8f27c2DE46c1DF567990c9720Dc169AA86300,
1604 0x981a1E7A9C337600c414889163117b1CF2De48Aa,
1605 0xbD7E7FDF65633c54f13e751b5cb0fdf561237B70,
1606 0x2fb975cd9Bd2Af43F2f7b7C03B63d29d9C83FB37,
1607 0x34509b079D54A602998A289A1FF3a27601a46A4A,
1608 0x7C043d5C962cfaf39A84367731dCd804eb03bA08,
1609 0x6678eB423E5F954A8d7ab47Fa3373F9F743C1686,
1610 0x44dA0Db572bD33d689e4D8Fab8b5D93192794016,
1611 0x5a3d6C4642E7F575030a6e9B41Bcc60719AF2A18
1612 ];
1613 
1614     constructor() ERC721("FASHIONCRYPTO_Genesis", "FCG")  
1615      WithLimitedSupply(9999)
1616     {
1617     }
1618 
1619     function mint(uint256[] memory tokenId) ensureAvailability public payable     {
1620         require(blnSale == true, "Not Sales Period.");
1621         require(tokenId.length <= batchMintMaxAmount, "Maximum of tokens to buy at once exceeded.");
1622         require(msg.value == cost * tokenId.length, "Price must be equal to listing price.");
1623         
1624         if(blnWhitelisted == true){
1625             bool isWhiteListedOne =isAddressWhitelistedOne(msg.sender);
1626             bool isWhiteListedTwo =isAddressWhitelistedTwo(msg.sender);
1627             require(isWhiteListedOne || isWhiteListedTwo, "Not on the whitelist! Cannot buy during PreSales Period.");
1628 
1629             if(isWhiteListedOne){
1630                 require(balanceOf(msg.sender) + tokenId.length <= whiteOneMax, "Max mint per address exceeded!");
1631             }else if(isWhiteListedTwo){
1632                 require(balanceOf(msg.sender) + tokenId.length <= whiteTwoMax, "Max mint per address exceeded!");
1633             }
1634 
1635             for(uint256 i=0; i <= tokenId.length-1; i++){
1636                 if (tokenId[i] >= startIndex && tokenId[i] <= endIndex){
1637                     _safeMint(msg.sender, tokenId[i]);
1638                     usedTokenId.push(tokenId[i]);
1639                     super.nextToken();
1640                 }
1641             }
1642         }else{
1643             for(uint256 i=0; i <= tokenId.length-1; i++){
1644                 if (tokenId[i] >= startIndex && tokenId[i] <= endIndex){
1645                     _safeMint(msg.sender, tokenId[i]);
1646                     usedTokenId.push(tokenId[i]);
1647                     super.nextToken();
1648                 }
1649             }
1650         }
1651     }
1652 
1653     function mintOwner(uint256[] memory tokenId) ensureAvailability public  {
1654         require(msg.sender == ownerAddress, "Only Owner can use this method.");
1655 
1656         for(uint256 i=0; i <= tokenId.length-1; i++){
1657             _safeMint(msg.sender, tokenId[i]);
1658             usedTokenId.push(tokenId[i]);
1659             super.nextToken();
1660         }
1661     }
1662 
1663     function isAddressWhitelistedOne(address _user) private view returns (bool) {
1664         uint i = 0;
1665         while (i < whitelistedAddressesOne.length) {
1666             if(whitelistedAddressesOne[i] == _user) {
1667                 return true;
1668             }
1669         i++;
1670         }
1671         return false;
1672     }
1673 
1674     function isAddressWhitelistedTwo(address _user) private view returns (bool) {
1675         uint i = 0;
1676         while (i < whitelistedAddressesTwo.length) {
1677             if(whitelistedAddressesTwo[i] == _user) {
1678                 return true;
1679             }
1680         i++;
1681         }
1682         return false;
1683     }
1684 
1685 
1686     //internal
1687     function _baseURI() internal view virtual override returns (string memory) {
1688         return baseURI;
1689     }
1690 
1691     function withdraw() public payable onlyOwner {
1692         require(payable(msg.sender).send(address(this).balance));
1693     }
1694 
1695     function updateCost(uint256 costParam) public onlyOwner {
1696         cost = costParam;
1697     }
1698 
1699     function updatebaseURI(string memory baseURIParam) public onlyOwner {
1700         baseURI = baseURIParam;
1701     }
1702 
1703     function updateSale(bool saleParam) public onlyOwner {
1704         blnSale = saleParam;
1705     }
1706 
1707     function updateWhitelisted(bool whitelistedParam) public onlyOwner {
1708         blnWhitelisted = whitelistedParam;
1709     }
1710 
1711     function updateStartindex(uint256 startIndexParam) public onlyOwner {
1712         startIndex = startIndexParam;
1713     }
1714 
1715     function updateEndindex(uint256 endIndexParam) public onlyOwner {
1716         endIndex = endIndexParam;
1717     }
1718 
1719     function updateBatchMintMaxAmount(uint8 maxParam) public onlyOwner {
1720         batchMintMaxAmount = maxParam;
1721     }
1722 
1723     function updateWhiteOneMax(uint8 whiteOneParam) public onlyOwner {
1724         whiteOneMax = whiteOneParam;
1725     }
1726 
1727     function updateWhiteTwoMax(uint8 whiteTwoParam) public onlyOwner {
1728         whiteTwoMax = whiteTwoParam;
1729     }
1730 
1731     //function updatepreSaleStartTime(uint256 preSaleStartTimeParam) public onlyOwner {
1732     //    preSaleStartTime = preSaleStartTimeParam;
1733     //}
1734 
1735     //function updatepreSaleEndTime(uint256 preSaleEndTimeParam) public onlyOwner {
1736     //    preSaleEndTime = preSaleEndTimeParam;
1737     //}
1738 	
1739     function updatewhitelistedAddressesOne(address addressParam) public onlyOwner {
1740         whitelistedAddressesOne.push(addressParam);
1741     }
1742 
1743     function updatewhitelistedAddressesTwo(address addressParam) public onlyOwner {
1744         whitelistedAddressesTwo.push(addressParam);
1745     }
1746 
1747     function updateownerAddress(address addressParam) public onlyOwner {
1748         ownerAddress = addressParam;
1749     }
1750 	
1751     function fetchwhitelistedAddressesOne() public view returns (address[] memory) {
1752         return whitelistedAddressesOne;
1753     }
1754 
1755     function fetchwhitelistedAddressesTwo() public view returns (address[] memory) {
1756         return whitelistedAddressesTwo;
1757     }
1758 
1759     function fetchUsedTokenId() public view returns (uint256[] memory) {
1760         return usedTokenId;
1761     }
1762 
1763     function tokenURI(uint256 tokenId) public view virtual override
1764         returns (string memory){
1765             require(_exists(tokenId),
1766             "ERC721Metadata: URI query for nonexistent token"
1767             );
1768         string memory currentBaseURI = _baseURI();
1769         return bytes(currentBaseURI).length >0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
1770     }
1771 }