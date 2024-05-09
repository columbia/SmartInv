1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @title Counters
11  * @author Matt Condon (@shrugs)
12  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
13  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
14  *
15  * Include with `using Counters for Counters.Counter;`
16  */
17 library Counters {
18     struct Counter {
19         // This variable should never be directly accessed by users of the library: interactions must be restricted to
20         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
21         // this feature: see https://github.com/ethereum/solidity/issues/4637
22         uint256 _value; // default: 0
23     }
24 
25     function current(Counter storage counter) internal view returns (uint256) {
26         return counter._value;
27     }
28 
29     function increment(Counter storage counter) internal {
30         unchecked {
31             counter._value += 1;
32         }
33     }
34 
35     function decrement(Counter storage counter) internal {
36         uint256 value = counter._value;
37         require(value > 0, "Counter: decrement overflow");
38         unchecked {
39             counter._value = value - 1;
40         }
41     }
42 
43     function reset(Counter storage counter) internal {
44         counter._value = 0;
45     }
46 }
47 
48 // File: @openzeppelin/contracts/utils/Strings.sol
49 
50 
51 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev String operations.
57  */
58 library Strings {
59     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
63      */
64     function toString(uint256 value) internal pure returns (string memory) {
65         // Inspired by OraclizeAPI's implementation - MIT licence
66         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
67 
68         if (value == 0) {
69             return "0";
70         }
71         uint256 temp = value;
72         uint256 digits;
73         while (temp != 0) {
74             digits++;
75             temp /= 10;
76         }
77         bytes memory buffer = new bytes(digits);
78         while (value != 0) {
79             digits -= 1;
80             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
81             value /= 10;
82         }
83         return string(buffer);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
88      */
89     function toHexString(uint256 value) internal pure returns (string memory) {
90         if (value == 0) {
91             return "0x00";
92         }
93         uint256 temp = value;
94         uint256 length = 0;
95         while (temp != 0) {
96             length++;
97             temp >>= 8;
98         }
99         return toHexString(value, length);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
104      */
105     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
106         bytes memory buffer = new bytes(2 * length + 2);
107         buffer[0] = "0";
108         buffer[1] = "x";
109         for (uint256 i = 2 * length + 1; i > 1; --i) {
110             buffer[i] = _HEX_SYMBOLS[value & 0xf];
111             value >>= 4;
112         }
113         require(value == 0, "Strings: hex length insufficient");
114         return string(buffer);
115     }
116 }
117 
118 // File: @openzeppelin/contracts/utils/Context.sol
119 
120 
121 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 /**
126  * @dev Provides information about the current execution context, including the
127  * sender of the transaction and its data. While these are generally available
128  * via msg.sender and msg.data, they should not be accessed in such a direct
129  * manner, since when dealing with meta-transactions the account sending and
130  * paying for execution may not be the actual sender (as far as an application
131  * is concerned).
132  *
133  * This contract is only required for intermediate, library-like contracts.
134  */
135 abstract contract Context {
136     function _msgSender() internal view virtual returns (address) {
137         return msg.sender;
138     }
139 
140     function _msgData() internal view virtual returns (bytes calldata) {
141         return msg.data;
142     }
143 }
144 
145 // File: @openzeppelin/contracts/access/Ownable.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 
153 /**
154  * @dev Contract module which provides a basic access control mechanism, where
155  * there is an account (an owner) that can be granted exclusive access to
156  * specific functions.
157  *
158  * By default, the owner account will be the one that deploys the contract. This
159  * can later be changed with {transferOwnership}.
160  *
161  * This module is used through inheritance. It will make available the modifier
162  * `onlyOwner`, which can be applied to your functions to restrict their use to
163  * the owner.
164  */
165 abstract contract Ownable is Context {
166     address private _owner;
167 
168     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
169 
170     /**
171      * @dev Initializes the contract setting the deployer as the initial owner.
172      */
173     constructor() {
174         _transferOwnership(_msgSender());
175     }
176 
177     /**
178      * @dev Returns the address of the current owner.
179      */
180     function owner() public view virtual returns (address) {
181         return _owner;
182     }
183 
184     /**
185      * @dev Throws if called by any account other than the owner.
186      */
187     modifier onlyOwner() {
188         require(owner() == _msgSender(), "Ownable: caller is not the owner");
189         _;
190     }
191 
192     /**
193      * @dev Leaves the contract without owner. It will not be possible to call
194      * `onlyOwner` functions anymore. Can only be called by the current owner.
195      *
196      * NOTE: Renouncing ownership will leave the contract without an owner,
197      * thereby removing any functionality that is only available to the owner.
198      */
199     function renounceOwnership() public virtual onlyOwner {
200         _transferOwnership(address(0));
201     }
202 
203     /**
204      * @dev Transfers ownership of the contract to a new account (`newOwner`).
205      * Can only be called by the current owner.
206      */
207     function transferOwnership(address newOwner) public virtual onlyOwner {
208         require(newOwner != address(0), "Ownable: new owner is the zero address");
209         _transferOwnership(newOwner);
210     }
211 
212     /**
213      * @dev Transfers ownership of the contract to a new account (`newOwner`).
214      * Internal function without access restriction.
215      */
216     function _transferOwnership(address newOwner) internal virtual {
217         address oldOwner = _owner;
218         _owner = newOwner;
219         emit OwnershipTransferred(oldOwner, newOwner);
220     }
221 }
222 
223 // File: @openzeppelin/contracts/utils/Address.sol
224 
225 
226 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
227 
228 pragma solidity ^0.8.1;
229 
230 /**
231  * @dev Collection of functions related to the address type
232  */
233 library Address {
234     /**
235      * @dev Returns true if `account` is a contract.
236      *
237      * [IMPORTANT]
238      * ====
239      * It is unsafe to assume that an address for which this function returns
240      * false is an externally-owned account (EOA) and not a contract.
241      *
242      * Among others, `isContract` will return false for the following
243      * types of addresses:
244      *
245      *  - an externally-owned account
246      *  - a contract in construction
247      *  - an address where a contract will be created
248      *  - an address where a contract lived, but was destroyed
249      * ====
250      *
251      * [IMPORTANT]
252      * ====
253      * You shouldn't rely on `isContract` to protect against flash loan attacks!
254      *
255      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
256      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
257      * constructor.
258      * ====
259      */
260     function isContract(address account) internal view returns (bool) {
261         // This method relies on extcodesize/address.code.length, which returns 0
262         // for contracts in construction, since the code is only stored at the end
263         // of the constructor execution.
264 
265         return account.code.length > 0;
266     }
267 
268     /**
269      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
270      * `recipient`, forwarding all available gas and reverting on errors.
271      *
272      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
273      * of certain opcodes, possibly making contracts go over the 2300 gas limit
274      * imposed by `transfer`, making them unable to receive funds via
275      * `transfer`. {sendValue} removes this limitation.
276      *
277      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
278      *
279      * IMPORTANT: because control is transferred to `recipient`, care must be
280      * taken to not create reentrancy vulnerabilities. Consider using
281      * {ReentrancyGuard} or the
282      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
283      */
284     function sendValue(address payable recipient, uint256 amount) internal {
285         require(address(this).balance >= amount, "Address: insufficient balance");
286 
287         (bool success, ) = recipient.call{value: amount}("");
288         require(success, "Address: unable to send value, recipient may have reverted");
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain `call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         return functionCallWithValue(target, data, 0, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but also transferring `value` wei to `target`.
330      *
331      * Requirements:
332      *
333      * - the calling contract must have an ETH balance of at least `value`.
334      * - the called Solidity function must be `payable`.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(
339         address target,
340         bytes memory data,
341         uint256 value
342     ) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
348      * with `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(
353         address target,
354         bytes memory data,
355         uint256 value,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         require(isContract(target), "Address: call to non-contract");
360 
361         (bool success, bytes memory returndata) = target.call{value: value}(data);
362         return verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a static call.
368      *
369      * _Available since v3.3._
370      */
371     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
372         return functionStaticCall(target, data, "Address: low-level static call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(
382         address target,
383         bytes memory data,
384         string memory errorMessage
385     ) internal view returns (bytes memory) {
386         require(isContract(target), "Address: static call to non-contract");
387 
388         (bool success, bytes memory returndata) = target.staticcall(data);
389         return verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but performing a delegate call.
395      *
396      * _Available since v3.4._
397      */
398     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
399         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
404      * but performing a delegate call.
405      *
406      * _Available since v3.4._
407      */
408     function functionDelegateCall(
409         address target,
410         bytes memory data,
411         string memory errorMessage
412     ) internal returns (bytes memory) {
413         require(isContract(target), "Address: delegate call to non-contract");
414 
415         (bool success, bytes memory returndata) = target.delegatecall(data);
416         return verifyCallResult(success, returndata, errorMessage);
417     }
418 
419     /**
420      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
421      * revert reason using the provided one.
422      *
423      * _Available since v4.3._
424      */
425     function verifyCallResult(
426         bool success,
427         bytes memory returndata,
428         string memory errorMessage
429     ) internal pure returns (bytes memory) {
430         if (success) {
431             return returndata;
432         } else {
433             // Look for revert reason and bubble it up if present
434             if (returndata.length > 0) {
435                 // The easiest way to bubble the revert reason is using memory via assembly
436 
437                 assembly {
438                     let returndata_size := mload(returndata)
439                     revert(add(32, returndata), returndata_size)
440                 }
441             } else {
442                 revert(errorMessage);
443             }
444         }
445     }
446 }
447 
448 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
449 
450 
451 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
452 
453 pragma solidity ^0.8.0;
454 
455 /**
456  * @title ERC721 token receiver interface
457  * @dev Interface for any contract that wants to support safeTransfers
458  * from ERC721 asset contracts.
459  */
460 interface IERC721Receiver {
461     /**
462      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
463      * by `operator` from `from`, this function is called.
464      *
465      * It must return its Solidity selector to confirm the token transfer.
466      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
467      *
468      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
469      */
470     function onERC721Received(
471         address operator,
472         address from,
473         uint256 tokenId,
474         bytes calldata data
475     ) external returns (bytes4);
476 }
477 
478 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
479 
480 
481 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
482 
483 pragma solidity ^0.8.0;
484 
485 /**
486  * @dev Interface of the ERC165 standard, as defined in the
487  * https://eips.ethereum.org/EIPS/eip-165[EIP].
488  *
489  * Implementers can declare support of contract interfaces, which can then be
490  * queried by others ({ERC165Checker}).
491  *
492  * For an implementation, see {ERC165}.
493  */
494 interface IERC165 {
495     /**
496      * @dev Returns true if this contract implements the interface defined by
497      * `interfaceId`. See the corresponding
498      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
499      * to learn more about how these ids are created.
500      *
501      * This function call must use less than 30 000 gas.
502      */
503     function supportsInterface(bytes4 interfaceId) external view returns (bool);
504 }
505 
506 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
507 
508 
509 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
510 
511 pragma solidity ^0.8.0;
512 
513 
514 /**
515  * @dev Implementation of the {IERC165} interface.
516  *
517  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
518  * for the additional interface id that will be supported. For example:
519  *
520  * ```solidity
521  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
522  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
523  * }
524  * ```
525  *
526  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
527  */
528 abstract contract ERC165 is IERC165 {
529     /**
530      * @dev See {IERC165-supportsInterface}.
531      */
532     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
533         return interfaceId == type(IERC165).interfaceId;
534     }
535 }
536 
537 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
538 
539 
540 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 
545 /**
546  * @dev Required interface of an ERC721 compliant contract.
547  */
548 interface IERC721 is IERC165 {
549     /**
550      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
551      */
552     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
553 
554     /**
555      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
556      */
557     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
558 
559     /**
560      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
561      */
562     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
563 
564     /**
565      * @dev Returns the number of tokens in ``owner``'s account.
566      */
567     function balanceOf(address owner) external view returns (uint256 balance);
568 
569     /**
570      * @dev Returns the owner of the `tokenId` token.
571      *
572      * Requirements:
573      *
574      * - `tokenId` must exist.
575      */
576     function ownerOf(uint256 tokenId) external view returns (address owner);
577 
578     /**
579      * @dev Safely transfers `tokenId` token from `from` to `to`.
580      *
581      * Requirements:
582      *
583      * - `from` cannot be the zero address.
584      * - `to` cannot be the zero address.
585      * - `tokenId` token must exist and be owned by `from`.
586      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
587      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
588      *
589      * Emits a {Transfer} event.
590      */
591     function safeTransferFrom(
592         address from,
593         address to,
594         uint256 tokenId,
595         bytes calldata data
596     ) external;
597 
598     /**
599      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
600      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
601      *
602      * Requirements:
603      *
604      * - `from` cannot be the zero address.
605      * - `to` cannot be the zero address.
606      * - `tokenId` token must exist and be owned by `from`.
607      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
608      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
609      *
610      * Emits a {Transfer} event.
611      */
612     function safeTransferFrom(
613         address from,
614         address to,
615         uint256 tokenId
616     ) external;
617 
618     /**
619      * @dev Transfers `tokenId` token from `from` to `to`.
620      *
621      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
622      *
623      * Requirements:
624      *
625      * - `from` cannot be the zero address.
626      * - `to` cannot be the zero address.
627      * - `tokenId` token must be owned by `from`.
628      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
629      *
630      * Emits a {Transfer} event.
631      */
632     function transferFrom(
633         address from,
634         address to,
635         uint256 tokenId
636     ) external;
637 
638     /**
639      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
640      * The approval is cleared when the token is transferred.
641      *
642      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
643      *
644      * Requirements:
645      *
646      * - The caller must own the token or be an approved operator.
647      * - `tokenId` must exist.
648      *
649      * Emits an {Approval} event.
650      */
651     function approve(address to, uint256 tokenId) external;
652 
653     /**
654      * @dev Approve or remove `operator` as an operator for the caller.
655      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
656      *
657      * Requirements:
658      *
659      * - The `operator` cannot be the caller.
660      *
661      * Emits an {ApprovalForAll} event.
662      */
663     function setApprovalForAll(address operator, bool _approved) external;
664 
665     /**
666      * @dev Returns the account approved for `tokenId` token.
667      *
668      * Requirements:
669      *
670      * - `tokenId` must exist.
671      */
672     function getApproved(uint256 tokenId) external view returns (address operator);
673 
674     /**
675      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
676      *
677      * See {setApprovalForAll}
678      */
679     function isApprovedForAll(address owner, address operator) external view returns (bool);
680 }
681 
682 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
683 
684 
685 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
686 
687 pragma solidity ^0.8.0;
688 
689 
690 /**
691  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
692  * @dev See https://eips.ethereum.org/EIPS/eip-721
693  */
694 interface IERC721Metadata is IERC721 {
695     /**
696      * @dev Returns the token collection name.
697      */
698     function name() external view returns (string memory);
699 
700     /**
701      * @dev Returns the token collection symbol.
702      */
703     function symbol() external view returns (string memory);
704 
705     /**
706      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
707      */
708     function tokenURI(uint256 tokenId) external view returns (string memory);
709 }
710 
711 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
712 
713 
714 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
715 
716 pragma solidity ^0.8.0;
717 
718 
719 
720 
721 
722 
723 
724 
725 /**
726  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
727  * the Metadata extension, but not including the Enumerable extension, which is available separately as
728  * {ERC721Enumerable}.
729  */
730 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
731     using Address for address;
732     using Strings for uint256;
733 
734     // Token name
735     string private _name;
736 
737     // Token symbol
738     string private _symbol;
739 
740     // Mapping from token ID to owner address
741     mapping(uint256 => address) private _owners;
742 
743     // Mapping owner address to token count
744     mapping(address => uint256) private _balances;
745 
746     // Mapping from token ID to approved address
747     mapping(uint256 => address) private _tokenApprovals;
748 
749     // Mapping from owner to operator approvals
750     mapping(address => mapping(address => bool)) private _operatorApprovals;
751 
752     /**
753      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
754      */
755     constructor(string memory name_, string memory symbol_) {
756         _name = name_;
757         _symbol = symbol_;
758     }
759 
760     /**
761      * @dev See {IERC165-supportsInterface}.
762      */
763     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
764         return
765             interfaceId == type(IERC721).interfaceId ||
766             interfaceId == type(IERC721Metadata).interfaceId ||
767             super.supportsInterface(interfaceId);
768     }
769 
770     /**
771      * @dev See {IERC721-balanceOf}.
772      */
773     function balanceOf(address owner) public view virtual override returns (uint256) {
774         require(owner != address(0), "ERC721: balance query for the zero address");
775         return _balances[owner];
776     }
777 
778     /**
779      * @dev See {IERC721-ownerOf}.
780      */
781     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
782         address owner = _owners[tokenId];
783         require(owner != address(0), "ERC721: owner query for nonexistent token");
784         return owner;
785     }
786 
787     /**
788      * @dev See {IERC721Metadata-name}.
789      */
790     function name() public view virtual override returns (string memory) {
791         return _name;
792     }
793 
794     /**
795      * @dev See {IERC721Metadata-symbol}.
796      */
797     function symbol() public view virtual override returns (string memory) {
798         return _symbol;
799     }
800 
801     /**
802      * @dev See {IERC721Metadata-tokenURI}.
803      */
804     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
805         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
806 
807         string memory baseURI = _baseURI();
808         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
809     }
810 
811     /**
812      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
813      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
814      * by default, can be overridden in child contracts.
815      */
816     function _baseURI() internal view virtual returns (string memory) {
817         return "";
818     }
819 
820     /**
821      * @dev See {IERC721-approve}.
822      */
823     function approve(address to, uint256 tokenId) public virtual override {
824         address owner = ERC721.ownerOf(tokenId);
825         require(to != owner, "ERC721: approval to current owner");
826 
827         require(
828             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
829             "ERC721: approve caller is not owner nor approved for all"
830         );
831 
832         _approve(to, tokenId);
833     }
834 
835     /**
836      * @dev See {IERC721-getApproved}.
837      */
838     function getApproved(uint256 tokenId) public view virtual override returns (address) {
839         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
840 
841         return _tokenApprovals[tokenId];
842     }
843 
844     /**
845      * @dev See {IERC721-setApprovalForAll}.
846      */
847     function setApprovalForAll(address operator, bool approved) public virtual override {
848         _setApprovalForAll(_msgSender(), operator, approved);
849     }
850 
851     /**
852      * @dev See {IERC721-isApprovedForAll}.
853      */
854     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
855         return _operatorApprovals[owner][operator];
856     }
857 
858     /**
859      * @dev See {IERC721-transferFrom}.
860      */
861     function transferFrom(
862         address from,
863         address to,
864         uint256 tokenId
865     ) public virtual override {
866         //solhint-disable-next-line max-line-length
867         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
868 
869         _transfer(from, to, tokenId);
870     }
871 
872     /**
873      * @dev See {IERC721-safeTransferFrom}.
874      */
875     function safeTransferFrom(
876         address from,
877         address to,
878         uint256 tokenId
879     ) public virtual override {
880         safeTransferFrom(from, to, tokenId, "");
881     }
882 
883     /**
884      * @dev See {IERC721-safeTransferFrom}.
885      */
886     function safeTransferFrom(
887         address from,
888         address to,
889         uint256 tokenId,
890         bytes memory _data
891     ) public virtual override {
892         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
893         _safeTransfer(from, to, tokenId, _data);
894     }
895 
896     /**
897      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
898      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
899      *
900      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
901      *
902      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
903      * implement alternative mechanisms to perform token transfer, such as signature-based.
904      *
905      * Requirements:
906      *
907      * - `from` cannot be the zero address.
908      * - `to` cannot be the zero address.
909      * - `tokenId` token must exist and be owned by `from`.
910      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
911      *
912      * Emits a {Transfer} event.
913      */
914     function _safeTransfer(
915         address from,
916         address to,
917         uint256 tokenId,
918         bytes memory _data
919     ) internal virtual {
920         _transfer(from, to, tokenId);
921         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
922     }
923 
924     /**
925      * @dev Returns whether `tokenId` exists.
926      *
927      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
928      *
929      * Tokens start existing when they are minted (`_mint`),
930      * and stop existing when they are burned (`_burn`).
931      */
932     function _exists(uint256 tokenId) internal view virtual returns (bool) {
933         return _owners[tokenId] != address(0);
934     }
935 
936     /**
937      * @dev Returns whether `spender` is allowed to manage `tokenId`.
938      *
939      * Requirements:
940      *
941      * - `tokenId` must exist.
942      */
943     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
944         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
945         address owner = ERC721.ownerOf(tokenId);
946         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
947     }
948 
949     /**
950      * @dev Safely mints `tokenId` and transfers it to `to`.
951      *
952      * Requirements:
953      *
954      * - `tokenId` must not exist.
955      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
956      *
957      * Emits a {Transfer} event.
958      */
959     function _safeMint(address to, uint256 tokenId) internal virtual {
960         _safeMint(to, tokenId, "");
961     }
962 
963     /**
964      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
965      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
966      */
967     function _safeMint(
968         address to,
969         uint256 tokenId,
970         bytes memory _data
971     ) internal virtual {
972         _mint(to, tokenId);
973         require(
974             _checkOnERC721Received(address(0), to, tokenId, _data),
975             "ERC721: transfer to non ERC721Receiver implementer"
976         );
977     }
978 
979     /**
980      * @dev Mints `tokenId` and transfers it to `to`.
981      *
982      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
983      *
984      * Requirements:
985      *
986      * - `tokenId` must not exist.
987      * - `to` cannot be the zero address.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _mint(address to, uint256 tokenId) internal virtual {
992         require(to != address(0), "ERC721: mint to the zero address");
993         require(!_exists(tokenId), "ERC721: token already minted");
994 
995         _beforeTokenTransfer(address(0), to, tokenId);
996 
997         _balances[to] += 1;
998         _owners[tokenId] = to;
999 
1000         emit Transfer(address(0), to, tokenId);
1001 
1002         _afterTokenTransfer(address(0), to, tokenId);
1003     }
1004 
1005     /**
1006      * @dev Destroys `tokenId`.
1007      * The approval is cleared when the token is burned.
1008      *
1009      * Requirements:
1010      *
1011      * - `tokenId` must exist.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function _burn(uint256 tokenId) internal virtual {
1016         address owner = ERC721.ownerOf(tokenId);
1017 
1018         _beforeTokenTransfer(owner, address(0), tokenId);
1019 
1020         // Clear approvals
1021         _approve(address(0), tokenId);
1022 
1023         _balances[owner] -= 1;
1024         delete _owners[tokenId];
1025 
1026         emit Transfer(owner, address(0), tokenId);
1027 
1028         _afterTokenTransfer(owner, address(0), tokenId);
1029     }
1030 
1031     /**
1032      * @dev Transfers `tokenId` from `from` to `to`.
1033      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1034      *
1035      * Requirements:
1036      *
1037      * - `to` cannot be the zero address.
1038      * - `tokenId` token must be owned by `from`.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function _transfer(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) internal virtual {
1047         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1048         require(to != address(0), "ERC721: transfer to the zero address");
1049 
1050         _beforeTokenTransfer(from, to, tokenId);
1051 
1052         // Clear approvals from the previous owner
1053         _approve(address(0), tokenId);
1054 
1055         _balances[from] -= 1;
1056         _balances[to] += 1;
1057         _owners[tokenId] = to;
1058 
1059         emit Transfer(from, to, tokenId);
1060 
1061         _afterTokenTransfer(from, to, tokenId);
1062     }
1063 
1064     /**
1065      * @dev Approve `to` to operate on `tokenId`
1066      *
1067      * Emits a {Approval} event.
1068      */
1069     function _approve(address to, uint256 tokenId) internal virtual {
1070         _tokenApprovals[tokenId] = to;
1071         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1072     }
1073 
1074     /**
1075      * @dev Approve `operator` to operate on all of `owner` tokens
1076      *
1077      * Emits a {ApprovalForAll} event.
1078      */
1079     function _setApprovalForAll(
1080         address owner,
1081         address operator,
1082         bool approved
1083     ) internal virtual {
1084         require(owner != operator, "ERC721: approve to caller");
1085         _operatorApprovals[owner][operator] = approved;
1086         emit ApprovalForAll(owner, operator, approved);
1087     }
1088 
1089     /**
1090      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1091      * The call is not executed if the target address is not a contract.
1092      *
1093      * @param from address representing the previous owner of the given token ID
1094      * @param to target address that will receive the tokens
1095      * @param tokenId uint256 ID of the token to be transferred
1096      * @param _data bytes optional data to send along with the call
1097      * @return bool whether the call correctly returned the expected magic value
1098      */
1099     function _checkOnERC721Received(
1100         address from,
1101         address to,
1102         uint256 tokenId,
1103         bytes memory _data
1104     ) private returns (bool) {
1105         if (to.isContract()) {
1106             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1107                 return retval == IERC721Receiver.onERC721Received.selector;
1108             } catch (bytes memory reason) {
1109                 if (reason.length == 0) {
1110                     revert("ERC721: transfer to non ERC721Receiver implementer");
1111                 } else {
1112                     assembly {
1113                         revert(add(32, reason), mload(reason))
1114                     }
1115                 }
1116             }
1117         } else {
1118             return true;
1119         }
1120     }
1121 
1122     /**
1123      * @dev Hook that is called before any token transfer. This includes minting
1124      * and burning.
1125      *
1126      * Calling conditions:
1127      *
1128      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1129      * transferred to `to`.
1130      * - When `from` is zero, `tokenId` will be minted for `to`.
1131      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1132      * - `from` and `to` are never both zero.
1133      *
1134      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1135      */
1136     function _beforeTokenTransfer(
1137         address from,
1138         address to,
1139         uint256 tokenId
1140     ) internal virtual {}
1141 
1142     /**
1143      * @dev Hook that is called after any transfer of tokens. This includes
1144      * minting and burning.
1145      *
1146      * Calling conditions:
1147      *
1148      * - when `from` and `to` are both non-zero.
1149      * - `from` and `to` are never both zero.
1150      *
1151      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1152      */
1153     function _afterTokenTransfer(
1154         address from,
1155         address to,
1156         uint256 tokenId
1157     ) internal virtual {}
1158 }
1159 
1160 // File: contracts/alienuniverseSMH.sol
1161 
1162 
1163 pragma solidity >=0.7.0 <0.9.0;
1164 
1165 
1166 
1167 contract alienuniverseSMH is ERC721, Ownable {
1168   using Strings for uint256;
1169   using Counters for Counters.Counter;
1170   Counters.Counter private supply;
1171   string public uriPrefix = "";
1172   string public uriSuffix = ".json";
1173   string public hiddenMetadataUri;
1174   
1175   uint256 public cost = 0 ether;
1176   uint256 public maxSupply = 5000;
1177   uint256 public maxMintAmountPerTx = 2;
1178   uint256 public maxFreeMintPerWallet = 10;
1179   bool public paused = false;
1180   bool public revealed = true;
1181   mapping(address => uint256) public addressToFreeMinted;
1182   constructor() ERC721("alienuniverseSMH", "alienuniverseSMH") {
1183     setHiddenMetadataUri("ipfs://__CID__/hidden.json");
1184   }
1185   modifier mintCompliance(uint256 _mintAmount) {
1186     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1187     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1188     _;
1189   }
1190   function totalSupply() public view returns (uint256) {
1191     return supply.current();
1192   }
1193   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1194     require(!paused, "The contract is paused!");
1195     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1196     require(addressToFreeMinted[msg.sender] + _mintAmount <= maxFreeMintPerWallet, "caller already minted for free");
1197     _mintLoop(msg.sender, _mintAmount);
1198     addressToFreeMinted[msg.sender] += _mintAmount;
1199   }
1200   
1201   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1202     _mintLoop(_receiver, _mintAmount);
1203   }
1204   function walletOfOwner(address _owner)
1205     public
1206     view
1207     returns (uint256[] memory)
1208   {
1209     uint256 ownerTokenCount = balanceOf(_owner);
1210     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1211     uint256 currentTokenId = 1;
1212     uint256 ownedTokenIndex = 0;
1213     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1214       address currentTokenOwner = ownerOf(currentTokenId);
1215       if (currentTokenOwner == _owner) {
1216         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1217         ownedTokenIndex++;
1218       }
1219       currentTokenId++;
1220     }
1221     return ownedTokenIds;
1222   }
1223   function tokenURI(uint256 _tokenId)
1224     public
1225     view
1226     virtual
1227     override
1228     returns (string memory)
1229   {
1230     require(
1231       _exists(_tokenId),
1232       "ERC721Metadata: URI query for nonexistent token"
1233     );
1234     if (revealed == false) {
1235       return hiddenMetadataUri;
1236     }
1237     string memory currentBaseURI = _baseURI();
1238     return bytes(currentBaseURI).length > 0
1239         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1240         : "";
1241   }
1242   function setRevealed(bool _state) public onlyOwner {
1243     revealed = _state;
1244   }
1245   function setCost(uint256 _cost) public onlyOwner {
1246     cost = _cost;
1247   }
1248   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1249     maxMintAmountPerTx = _maxMintAmountPerTx;
1250   }
1251   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1252     hiddenMetadataUri = _hiddenMetadataUri;
1253   }
1254   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1255     uriPrefix = _uriPrefix;
1256   }
1257   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1258     uriSuffix = _uriSuffix;
1259   }
1260   function setPaused(bool _state) public onlyOwner {
1261     paused = _state;
1262   }
1263   function withdraw() public onlyOwner {
1264     // This will transfer the remaining contract balance to the owner.
1265     // Do not remove this otherwise you will not be able to withdraw the funds.
1266     // =============================================================================
1267     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1268     require(os);
1269     // =============================================================================
1270   }
1271   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1272     for (uint256 i = 0; i < _mintAmount; i++) {
1273       supply.increment();
1274       _safeMint(_receiver, supply.current());
1275     }
1276   }
1277   function _baseURI() internal view virtual override returns (string memory) {
1278     return uriPrefix;
1279   }
1280 }