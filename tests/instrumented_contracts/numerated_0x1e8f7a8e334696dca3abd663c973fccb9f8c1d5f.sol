1 // SPDX-License-Identifier: MIT
2 
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
1161 // File: contracts/LowGas.sol
1162 
1163 
1164 
1165 // Amended by HashLips
1166 /**
1167     !Disclaimer!
1168     These contracts have been used to create tutorials,
1169     and was created for the purpose to teach people
1170     how to create smart contracts on the blockchain.
1171     please review this code on your own before using any of
1172     the following code for production.
1173     The developer will not be responsible or liable for all loss or 
1174     damage whatsoever caused by you participating in any way in the 
1175     experimental code, whether putting money into the contract or 
1176     using the code for your own project.
1177 */
1178 
1179 pragma solidity >=0.7.0 <0.9.0;
1180 
1181 
1182 
1183 
1184 contract AlgorithmicByDepp is ERC721, Ownable {
1185   using Strings for uint256;
1186   using Counters for Counters.Counter;
1187 
1188   Counters.Counter private supply;
1189 
1190   string public uriPrefix = "";
1191   string public uriSuffix = ".json";
1192   string public hiddenMetadataUri;
1193   
1194   uint256 public cost = 0.01 ether;
1195   uint256 public maxSupply = 999;
1196   uint256 public maxMintAmountPerTx = 10;
1197 
1198   bool public paused = true;
1199   bool public revealed = false;
1200 
1201   constructor() ERC721("Algorithmic By Depp", "ABD") {
1202     setHiddenMetadataUri("ipfs://QmPndukDPiaJWLDPLUV8VzYkAQWJGCZcRbgEPJvCiRwcCS/hidden.json");
1203   }
1204 
1205   modifier mintCompliance(uint256 _mintAmount) {
1206     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1207     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1208     _;
1209   }
1210 
1211   function totalSupply() public view returns (uint256) {
1212     return supply.current();
1213   }
1214 
1215   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1216     require(!paused, "The contract is paused!");
1217     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1218 
1219     _mintLoop(msg.sender, _mintAmount);
1220   }
1221   
1222   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1223     _mintLoop(_receiver, _mintAmount);
1224   }
1225 
1226   function walletOfOwner(address _owner)
1227     public
1228     view
1229     returns (uint256[] memory)
1230   {
1231     uint256 ownerTokenCount = balanceOf(_owner);
1232     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1233     uint256 currentTokenId = 1;
1234     uint256 ownedTokenIndex = 0;
1235 
1236     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1237       address currentTokenOwner = ownerOf(currentTokenId);
1238 
1239       if (currentTokenOwner == _owner) {
1240         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1241 
1242         ownedTokenIndex++;
1243       }
1244 
1245       currentTokenId++;
1246     }
1247 
1248     return ownedTokenIds;
1249   }
1250 
1251   function tokenURI(uint256 _tokenId)
1252     public
1253     view
1254     virtual
1255     override
1256     returns (string memory)
1257   {
1258     require(
1259       _exists(_tokenId),
1260       "ERC721Metadata: URI query for nonexistent token"
1261     );
1262 
1263     if (revealed == false) {
1264       return hiddenMetadataUri;
1265     }
1266 
1267     string memory currentBaseURI = _baseURI();
1268     return bytes(currentBaseURI).length > 0
1269         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1270         : "";
1271   }
1272 
1273   function setRevealed(bool _state) public onlyOwner {
1274     revealed = _state;
1275   }
1276 
1277   function setCost(uint256 _cost) public onlyOwner {
1278     cost = _cost;
1279   }
1280 
1281   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1282     maxMintAmountPerTx = _maxMintAmountPerTx;
1283   }
1284 
1285   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1286     hiddenMetadataUri = _hiddenMetadataUri;
1287   }
1288 
1289   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1290     uriPrefix = _uriPrefix;
1291   }
1292 
1293   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1294     uriSuffix = _uriSuffix;
1295   }
1296 
1297   function setPaused(bool _state) public onlyOwner {
1298     paused = _state;
1299   }
1300 
1301   function withdraw() public onlyOwner {
1302     // This will pay HashLips 5% of the initial sale.
1303     // You can remove this if you want, or keep it in to support HashLips and his channel.
1304     // =============================================================================
1305     (bool hs, ) = payable(0x4dbBbafB1F7e2Dad58E2f4d6813e8e9509390FFe).call{value: address(this).balance * 5 / 100}("");
1306     require(hs);
1307     // =============================================================================
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