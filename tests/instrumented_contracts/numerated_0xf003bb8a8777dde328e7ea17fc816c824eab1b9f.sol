1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/utils/Counters.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @title Counters
13  * @author Matt Condon (@shrugs)
14  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
15  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
16  *
17  * Include with `using Counters for Counters.Counter;`
18  */
19 library Counters {
20     struct Counter {
21         // This variable should never be directly accessed by users of the library: interactions must be restricted to
22         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
23         // this feature: see https://github.com/ethereum/solidity/issues/4637
24         uint256 _value; // default: 0
25     }
26 
27     function current(Counter storage counter) internal view returns (uint256) {
28         return counter._value;
29     }
30 
31     function increment(Counter storage counter) internal {
32         unchecked {
33             counter._value += 1;
34         }
35     }
36 
37     function decrement(Counter storage counter) internal {
38         uint256 value = counter._value;
39         require(value > 0, "Counter: decrement overflow");
40         unchecked {
41             counter._value = value - 1;
42         }
43     }
44 
45     function reset(Counter storage counter) internal {
46         counter._value = 0;
47     }
48 }
49 
50 // File: @openzeppelin/contracts/utils/Strings.sol
51 
52 
53 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
54 
55 pragma solidity ^0.8.0;
56 
57 /**
58  * @dev String operations.
59  */
60 library Strings {
61     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
65      */
66     function toString(uint256 value) internal pure returns (string memory) {
67         // Inspired by OraclizeAPI's implementation - MIT licence
68         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
69 
70         if (value == 0) {
71             return "0";
72         }
73         uint256 temp = value;
74         uint256 digits;
75         while (temp != 0) {
76             digits++;
77             temp /= 10;
78         }
79         bytes memory buffer = new bytes(digits);
80         while (value != 0) {
81             digits -= 1;
82             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
83             value /= 10;
84         }
85         return string(buffer);
86     }
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
90      */
91     function toHexString(uint256 value) internal pure returns (string memory) {
92         if (value == 0) {
93             return "0x00";
94         }
95         uint256 temp = value;
96         uint256 length = 0;
97         while (temp != 0) {
98             length++;
99             temp >>= 8;
100         }
101         return toHexString(value, length);
102     }
103 
104     /**
105      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
106      */
107     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
108         bytes memory buffer = new bytes(2 * length + 2);
109         buffer[0] = "0";
110         buffer[1] = "x";
111         for (uint256 i = 2 * length + 1; i > 1; --i) {
112             buffer[i] = _HEX_SYMBOLS[value & 0xf];
113             value >>= 4;
114         }
115         require(value == 0, "Strings: hex length insufficient");
116         return string(buffer);
117     }
118 }
119 
120 // File: @openzeppelin/contracts/utils/Context.sol
121 
122 
123 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
124 
125 pragma solidity ^0.8.0;
126 
127 /**
128  * @dev Provides information about the current execution context, including the
129  * sender of the transaction and its data. While these are generally available
130  * via msg.sender and msg.data, they should not be accessed in such a direct
131  * manner, since when dealing with meta-transactions the account sending and
132  * paying for execution may not be the actual sender (as far as an application
133  * is concerned).
134  *
135  * This contract is only required for intermediate, library-like contracts.
136  */
137 abstract contract Context {
138     function _msgSender() internal view virtual returns (address) {
139         return msg.sender;
140     }
141 
142     function _msgData() internal view virtual returns (bytes calldata) {
143         return msg.data;
144     }
145 }
146 
147 // File: @openzeppelin/contracts/access/Ownable.sol
148 
149 
150 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
151 
152 pragma solidity ^0.8.0;
153 
154 
155 /**
156  * @dev Contract module which provides a basic access control mechanism, where
157  * there is an account (an owner) that can be granted exclusive access to
158  * specific functions.
159  *
160  * By default, the owner account will be the one that deploys the contract. This
161  * can later be changed with {transferOwnership}.
162  *
163  * This module is used through inheritance. It will make available the modifier
164  * `onlyOwner`, which can be applied to your functions to restrict their use to
165  * the owner.
166  */
167 abstract contract Ownable is Context {
168     address private _owner;
169 
170     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
171 
172     /**
173      * @dev Initializes the contract setting the deployer as the initial owner.
174      */
175     constructor() {
176         _transferOwnership(_msgSender());
177     }
178 
179     /**
180      * @dev Returns the address of the current owner.
181      */
182     function owner() public view virtual returns (address) {
183         return _owner;
184     }
185 
186     /**
187      * @dev Throws if called by any account other than the owner.
188      */
189     modifier onlyOwner() {
190         require(owner() == _msgSender(), "Ownable: caller is not the owner");
191         _;
192     }
193 
194     /**
195      * @dev Leaves the contract without owner. It will not be possible to call
196      * `onlyOwner` functions anymore. Can only be called by the current owner.
197      *
198      * NOTE: Renouncing ownership will leave the contract without an owner,
199      * thereby removing any functionality that is only available to the owner.
200      */
201     function renounceOwnership() public virtual onlyOwner {
202         _transferOwnership(address(0));
203     }
204 
205     /**
206      * @dev Transfers ownership of the contract to a new account (`newOwner`).
207      * Can only be called by the current owner.
208      */
209     function transferOwnership(address newOwner) public virtual onlyOwner {
210         require(newOwner != address(0), "Ownable: new owner is the zero address");
211         _transferOwnership(newOwner);
212     }
213 
214     /**
215      * @dev Transfers ownership of the contract to a new account (`newOwner`).
216      * Internal function without access restriction.
217      */
218     function _transferOwnership(address newOwner) internal virtual {
219         address oldOwner = _owner;
220         _owner = newOwner;
221         emit OwnershipTransferred(oldOwner, newOwner);
222     }
223 }
224 
225 // File: @openzeppelin/contracts/utils/Address.sol
226 
227 
228 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
229 
230 pragma solidity ^0.8.0;
231 
232 /**
233  * @dev Collection of functions related to the address type
234  */
235 library Address {
236     /**
237      * @dev Returns true if `account` is a contract.
238      *
239      * [IMPORTANT]
240      * ====
241      * It is unsafe to assume that an address for which this function returns
242      * false is an externally-owned account (EOA) and not a contract.
243      *
244      * Among others, `isContract` will return false for the following
245      * types of addresses:
246      *
247      *  - an externally-owned account
248      *  - a contract in construction
249      *  - an address where a contract will be created
250      *  - an address where a contract lived, but was destroyed
251      * ====
252      */
253     function isContract(address account) internal view returns (bool) {
254         // This method relies on extcodesize, which returns 0 for contracts in
255         // construction, since the code is only stored at the end of the
256         // constructor execution.
257 
258         uint256 size;
259         assembly {
260             size := extcodesize(account)
261         }
262         return size > 0;
263     }
264 
265     /**
266      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
267      * `recipient`, forwarding all available gas and reverting on errors.
268      *
269      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
270      * of certain opcodes, possibly making contracts go over the 2300 gas limit
271      * imposed by `transfer`, making them unable to receive funds via
272      * `transfer`. {sendValue} removes this limitation.
273      *
274      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
275      *
276      * IMPORTANT: because control is transferred to `recipient`, care must be
277      * taken to not create reentrancy vulnerabilities. Consider using
278      * {ReentrancyGuard} or the
279      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
280      */
281     function sendValue(address payable recipient, uint256 amount) internal {
282         require(address(this).balance >= amount, "Address: insufficient balance");
283 
284         (bool success, ) = recipient.call{value: amount}("");
285         require(success, "Address: unable to send value, recipient may have reverted");
286     }
287 
288     /**
289      * @dev Performs a Solidity function call using a low level `call`. A
290      * plain `call` is an unsafe replacement for a function call: use this
291      * function instead.
292      *
293      * If `target` reverts with a revert reason, it is bubbled up by this
294      * function (like regular Solidity function calls).
295      *
296      * Returns the raw returned data. To convert to the expected return value,
297      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
298      *
299      * Requirements:
300      *
301      * - `target` must be a contract.
302      * - calling `target` with `data` must not revert.
303      *
304      * _Available since v3.1._
305      */
306     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
307         return functionCall(target, data, "Address: low-level call failed");
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
312      * `errorMessage` as a fallback revert reason when `target` reverts.
313      *
314      * _Available since v3.1._
315      */
316     function functionCall(
317         address target,
318         bytes memory data,
319         string memory errorMessage
320     ) internal returns (bytes memory) {
321         return functionCallWithValue(target, data, 0, errorMessage);
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326      * but also transferring `value` wei to `target`.
327      *
328      * Requirements:
329      *
330      * - the calling contract must have an ETH balance of at least `value`.
331      * - the called Solidity function must be `payable`.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(
336         address target,
337         bytes memory data,
338         uint256 value
339     ) internal returns (bytes memory) {
340         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
345      * with `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(
350         address target,
351         bytes memory data,
352         uint256 value,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         require(isContract(target), "Address: call to non-contract");
357 
358         (bool success, bytes memory returndata) = target.call{value: value}(data);
359         return verifyCallResult(success, returndata, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but performing a static call.
365      *
366      * _Available since v3.3._
367      */
368     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
369         return functionStaticCall(target, data, "Address: low-level static call failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
374      * but performing a static call.
375      *
376      * _Available since v3.3._
377      */
378     function functionStaticCall(
379         address target,
380         bytes memory data,
381         string memory errorMessage
382     ) internal view returns (bytes memory) {
383         require(isContract(target), "Address: static call to non-contract");
384 
385         (bool success, bytes memory returndata) = target.staticcall(data);
386         return verifyCallResult(success, returndata, errorMessage);
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
391      * but performing a delegate call.
392      *
393      * _Available since v3.4._
394      */
395     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
396         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
401      * but performing a delegate call.
402      *
403      * _Available since v3.4._
404      */
405     function functionDelegateCall(
406         address target,
407         bytes memory data,
408         string memory errorMessage
409     ) internal returns (bytes memory) {
410         require(isContract(target), "Address: delegate call to non-contract");
411 
412         (bool success, bytes memory returndata) = target.delegatecall(data);
413         return verifyCallResult(success, returndata, errorMessage);
414     }
415 
416     /**
417      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
418      * revert reason using the provided one.
419      *
420      * _Available since v4.3._
421      */
422     function verifyCallResult(
423         bool success,
424         bytes memory returndata,
425         string memory errorMessage
426     ) internal pure returns (bytes memory) {
427         if (success) {
428             return returndata;
429         } else {
430             // Look for revert reason and bubble it up if present
431             if (returndata.length > 0) {
432                 // The easiest way to bubble the revert reason is using memory via assembly
433 
434                 assembly {
435                     let returndata_size := mload(returndata)
436                     revert(add(32, returndata), returndata_size)
437                 }
438             } else {
439                 revert(errorMessage);
440             }
441         }
442     }
443 }
444 
445 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
446 
447 
448 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
449 
450 pragma solidity ^0.8.0;
451 
452 /**
453  * @title ERC721 token receiver interface
454  * @dev Interface for any contract that wants to support safeTransfers
455  * from ERC721 asset contracts.
456  */
457 interface IERC721Receiver {
458     /**
459      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
460      * by `operator` from `from`, this function is called.
461      *
462      * It must return its Solidity selector to confirm the token transfer.
463      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
464      *
465      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
466      */
467     function onERC721Received(
468         address operator,
469         address from,
470         uint256 tokenId,
471         bytes calldata data
472     ) external returns (bytes4);
473 }
474 
475 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
476 
477 
478 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 /**
483  * @dev Interface of the ERC165 standard, as defined in the
484  * https://eips.ethereum.org/EIPS/eip-165[EIP].
485  *
486  * Implementers can declare support of contract interfaces, which can then be
487  * queried by others ({ERC165Checker}).
488  *
489  * For an implementation, see {ERC165}.
490  */
491 interface IERC165 {
492     /**
493      * @dev Returns true if this contract implements the interface defined by
494      * `interfaceId`. See the corresponding
495      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
496      * to learn more about how these ids are created.
497      *
498      * This function call must use less than 30 000 gas.
499      */
500     function supportsInterface(bytes4 interfaceId) external view returns (bool);
501 }
502 
503 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
504 
505 
506 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
507 
508 pragma solidity ^0.8.0;
509 
510 
511 /**
512  * @dev Implementation of the {IERC165} interface.
513  *
514  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
515  * for the additional interface id that will be supported. For example:
516  *
517  * ```solidity
518  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
519  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
520  * }
521  * ```
522  *
523  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
524  */
525 abstract contract ERC165 is IERC165 {
526     /**
527      * @dev See {IERC165-supportsInterface}.
528      */
529     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
530         return interfaceId == type(IERC165).interfaceId;
531     }
532 }
533 
534 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
535 
536 
537 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 
542 /**
543  * @dev Required interface of an ERC721 compliant contract.
544  */
545 interface IERC721 is IERC165 {
546     /**
547      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
548      */
549     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
550 
551     /**
552      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
553      */
554     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
555 
556     /**
557      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
558      */
559     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
560 
561     /**
562      * @dev Returns the number of tokens in ``owner``'s account.
563      */
564     function balanceOf(address owner) external view returns (uint256 balance);
565 
566     /**
567      * @dev Returns the owner of the `tokenId` token.
568      *
569      * Requirements:
570      *
571      * - `tokenId` must exist.
572      */
573     function ownerOf(uint256 tokenId) external view returns (address owner);
574 
575     /**
576      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
577      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
578      *
579      * Requirements:
580      *
581      * - `from` cannot be the zero address.
582      * - `to` cannot be the zero address.
583      * - `tokenId` token must exist and be owned by `from`.
584      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
585      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
586      *
587      * Emits a {Transfer} event.
588      */
589     function safeTransferFrom(
590         address from,
591         address to,
592         uint256 tokenId
593     ) external;
594 
595     /**
596      * @dev Transfers `tokenId` token from `from` to `to`.
597      *
598      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
599      *
600      * Requirements:
601      *
602      * - `from` cannot be the zero address.
603      * - `to` cannot be the zero address.
604      * - `tokenId` token must be owned by `from`.
605      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
606      *
607      * Emits a {Transfer} event.
608      */
609     function transferFrom(
610         address from,
611         address to,
612         uint256 tokenId
613     ) external;
614 
615     /**
616      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
617      * The approval is cleared when the token is transferred.
618      *
619      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
620      *
621      * Requirements:
622      *
623      * - The caller must own the token or be an approved operator.
624      * - `tokenId` must exist.
625      *
626      * Emits an {Approval} event.
627      */
628     function approve(address to, uint256 tokenId) external;
629 
630     /**
631      * @dev Returns the account approved for `tokenId` token.
632      *
633      * Requirements:
634      *
635      * - `tokenId` must exist.
636      */
637     function getApproved(uint256 tokenId) external view returns (address operator);
638 
639     /**
640      * @dev Approve or remove `operator` as an operator for the caller.
641      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
642      *
643      * Requirements:
644      *
645      * - The `operator` cannot be the caller.
646      *
647      * Emits an {ApprovalForAll} event.
648      */
649     function setApprovalForAll(address operator, bool _approved) external;
650 
651     /**
652      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
653      *
654      * See {setApprovalForAll}
655      */
656     function isApprovedForAll(address owner, address operator) external view returns (bool);
657 
658     /**
659      * @dev Safely transfers `tokenId` token from `from` to `to`.
660      *
661      * Requirements:
662      *
663      * - `from` cannot be the zero address.
664      * - `to` cannot be the zero address.
665      * - `tokenId` token must exist and be owned by `from`.
666      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
667      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
668      *
669      * Emits a {Transfer} event.
670      */
671     function safeTransferFrom(
672         address from,
673         address to,
674         uint256 tokenId,
675         bytes calldata data
676     ) external;
677 }
678 
679 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
680 
681 
682 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
683 
684 pragma solidity ^0.8.0;
685 
686 
687 /**
688  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
689  * @dev See https://eips.ethereum.org/EIPS/eip-721
690  */
691 interface IERC721Metadata is IERC721 {
692     /**
693      * @dev Returns the token collection name.
694      */
695     function name() external view returns (string memory);
696 
697     /**
698      * @dev Returns the token collection symbol.
699      */
700     function symbol() external view returns (string memory);
701 
702     /**
703      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
704      */
705     function tokenURI(uint256 tokenId) external view returns (string memory);
706 }
707 
708 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
709 
710 
711 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 
716 
717 
718 
719 
720 
721 
722 /**
723  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
724  * the Metadata extension, but not including the Enumerable extension, which is available separately as
725  * {ERC721Enumerable}.
726  */
727 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
728     using Address for address;
729     using Strings for uint256;
730 
731     // Token name
732     string private _name;
733 
734     // Token symbol
735     string private _symbol;
736 
737     // Mapping from token ID to owner address
738     mapping(uint256 => address) private _owners;
739 
740     // Mapping owner address to token count
741     mapping(address => uint256) private _balances;
742 
743     // Mapping from token ID to approved address
744     mapping(uint256 => address) private _tokenApprovals;
745 
746     // Mapping from owner to operator approvals
747     mapping(address => mapping(address => bool)) private _operatorApprovals;
748 
749     /**
750      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
751      */
752     constructor(string memory name_, string memory symbol_) {
753         _name = name_;
754         _symbol = symbol_;
755     }
756 
757     /**
758      * @dev See {IERC165-supportsInterface}.
759      */
760     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
761         return
762             interfaceId == type(IERC721).interfaceId ||
763             interfaceId == type(IERC721Metadata).interfaceId ||
764             super.supportsInterface(interfaceId);
765     }
766 
767     /**
768      * @dev See {IERC721-balanceOf}.
769      */
770     function balanceOf(address owner) public view virtual override returns (uint256) {
771         require(owner != address(0), "ERC721: balance query for the zero address");
772         return _balances[owner];
773     }
774 
775     /**
776      * @dev See {IERC721-ownerOf}.
777      */
778     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
779         address owner = _owners[tokenId];
780         require(owner != address(0), "ERC721: owner query for nonexistent token");
781         return owner;
782     }
783 
784     /**
785      * @dev See {IERC721Metadata-name}.
786      */
787     function name() public view virtual override returns (string memory) {
788         return _name;
789     }
790 
791     /**
792      * @dev See {IERC721Metadata-symbol}.
793      */
794     function symbol() public view virtual override returns (string memory) {
795         return _symbol;
796     }
797 
798     /**
799      * @dev See {IERC721Metadata-tokenURI}.
800      */
801     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
802         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
803 
804         string memory baseURI = _baseURI();
805         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
806     }
807 
808     /**
809      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
810      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
811      * by default, can be overriden in child contracts.
812      */
813     function _baseURI() internal view virtual returns (string memory) {
814         return "";
815     }
816 
817     /**
818      * @dev See {IERC721-approve}.
819      */
820     function approve(address to, uint256 tokenId) public virtual override {
821         address owner = ERC721.ownerOf(tokenId);
822         require(to != owner, "ERC721: approval to current owner");
823 
824         require(
825             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
826             "ERC721: approve caller is not owner nor approved for all"
827         );
828 
829         _approve(to, tokenId);
830     }
831 
832     /**
833      * @dev See {IERC721-getApproved}.
834      */
835     function getApproved(uint256 tokenId) public view virtual override returns (address) {
836         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
837 
838         return _tokenApprovals[tokenId];
839     }
840 
841     /**
842      * @dev See {IERC721-setApprovalForAll}.
843      */
844     function setApprovalForAll(address operator, bool approved) public virtual override {
845         _setApprovalForAll(_msgSender(), operator, approved);
846     }
847 
848     /**
849      * @dev See {IERC721-isApprovedForAll}.
850      */
851     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
852         return _operatorApprovals[owner][operator];
853     }
854 
855     /**
856      * @dev See {IERC721-transferFrom}.
857      */
858     function transferFrom(
859         address from,
860         address to,
861         uint256 tokenId
862     ) public virtual override {
863         //solhint-disable-next-line max-line-length
864         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
865 
866         _transfer(from, to, tokenId);
867     }
868 
869     /**
870      * @dev See {IERC721-safeTransferFrom}.
871      */
872     function safeTransferFrom(
873         address from,
874         address to,
875         uint256 tokenId
876     ) public virtual override {
877         safeTransferFrom(from, to, tokenId, "");
878     }
879 
880     /**
881      * @dev See {IERC721-safeTransferFrom}.
882      */
883     function safeTransferFrom(
884         address from,
885         address to,
886         uint256 tokenId,
887         bytes memory _data
888     ) public virtual override {
889         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
890         _safeTransfer(from, to, tokenId, _data);
891     }
892 
893     /**
894      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
895      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
896      *
897      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
898      *
899      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
900      * implement alternative mechanisms to perform token transfer, such as signature-based.
901      *
902      * Requirements:
903      *
904      * - `from` cannot be the zero address.
905      * - `to` cannot be the zero address.
906      * - `tokenId` token must exist and be owned by `from`.
907      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
908      *
909      * Emits a {Transfer} event.
910      */
911     function _safeTransfer(
912         address from,
913         address to,
914         uint256 tokenId,
915         bytes memory _data
916     ) internal virtual {
917         _transfer(from, to, tokenId);
918         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
919     }
920 
921     /**
922      * @dev Returns whether `tokenId` exists.
923      *
924      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
925      *
926      * Tokens start existing when they are minted (`_mint`),
927      * and stop existing when they are burned (`_burn`).
928      */
929     function _exists(uint256 tokenId) internal view virtual returns (bool) {
930         return _owners[tokenId] != address(0);
931     }
932 
933     /**
934      * @dev Returns whether `spender` is allowed to manage `tokenId`.
935      *
936      * Requirements:
937      *
938      * - `tokenId` must exist.
939      */
940     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
941         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
942         address owner = ERC721.ownerOf(tokenId);
943         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
944     }
945 
946     /**
947      * @dev Safely mints `tokenId` and transfers it to `to`.
948      *
949      * Requirements:
950      *
951      * - `tokenId` must not exist.
952      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
953      *
954      * Emits a {Transfer} event.
955      */
956     function _safeMint(address to, uint256 tokenId) internal virtual {
957         _safeMint(to, tokenId, "");
958     }
959 
960     /**
961      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
962      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
963      */
964     function _safeMint(
965         address to,
966         uint256 tokenId,
967         bytes memory _data
968     ) internal virtual {
969         _mint(to, tokenId);
970         require(
971             _checkOnERC721Received(address(0), to, tokenId, _data),
972             "ERC721: transfer to non ERC721Receiver implementer"
973         );
974     }
975 
976     /**
977      * @dev Mints `tokenId` and transfers it to `to`.
978      *
979      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
980      *
981      * Requirements:
982      *
983      * - `tokenId` must not exist.
984      * - `to` cannot be the zero address.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _mint(address to, uint256 tokenId) internal virtual {
989         require(to != address(0), "ERC721: mint to the zero address");
990         require(!_exists(tokenId), "ERC721: token already minted");
991 
992         _beforeTokenTransfer(address(0), to, tokenId);
993 
994         _balances[to] += 1;
995         _owners[tokenId] = to;
996 
997         emit Transfer(address(0), to, tokenId);
998     }
999 
1000     /**
1001      * @dev Destroys `tokenId`.
1002      * The approval is cleared when the token is burned.
1003      *
1004      * Requirements:
1005      *
1006      * - `tokenId` must exist.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function _burn(uint256 tokenId) internal virtual {
1011         address owner = ERC721.ownerOf(tokenId);
1012 
1013         _beforeTokenTransfer(owner, address(0), tokenId);
1014 
1015         // Clear approvals
1016         _approve(address(0), tokenId);
1017 
1018         _balances[owner] -= 1;
1019         delete _owners[tokenId];
1020 
1021         emit Transfer(owner, address(0), tokenId);
1022     }
1023 
1024     /**
1025      * @dev Transfers `tokenId` from `from` to `to`.
1026      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1027      *
1028      * Requirements:
1029      *
1030      * - `to` cannot be the zero address.
1031      * - `tokenId` token must be owned by `from`.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function _transfer(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) internal virtual {
1040         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1041         require(to != address(0), "ERC721: transfer to the zero address");
1042 
1043         _beforeTokenTransfer(from, to, tokenId);
1044 
1045         // Clear approvals from the previous owner
1046         _approve(address(0), tokenId);
1047 
1048         _balances[from] -= 1;
1049         _balances[to] += 1;
1050         _owners[tokenId] = to;
1051 
1052         emit Transfer(from, to, tokenId);
1053     }
1054 
1055     /**
1056      * @dev Approve `to` to operate on `tokenId`
1057      *
1058      * Emits a {Approval} event.
1059      */
1060     function _approve(address to, uint256 tokenId) internal virtual {
1061         _tokenApprovals[tokenId] = to;
1062         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1063     }
1064 
1065     /**
1066      * @dev Approve `operator` to operate on all of `owner` tokens
1067      *
1068      * Emits a {ApprovalForAll} event.
1069      */
1070     function _setApprovalForAll(
1071         address owner,
1072         address operator,
1073         bool approved
1074     ) internal virtual {
1075         require(owner != operator, "ERC721: approve to caller");
1076         _operatorApprovals[owner][operator] = approved;
1077         emit ApprovalForAll(owner, operator, approved);
1078     }
1079 
1080     /**
1081      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1082      * The call is not executed if the target address is not a contract.
1083      *
1084      * @param from address representing the previous owner of the given token ID
1085      * @param to target address that will receive the tokens
1086      * @param tokenId uint256 ID of the token to be transferred
1087      * @param _data bytes optional data to send along with the call
1088      * @return bool whether the call correctly returned the expected magic value
1089      */
1090     function _checkOnERC721Received(
1091         address from,
1092         address to,
1093         uint256 tokenId,
1094         bytes memory _data
1095     ) private returns (bool) {
1096         if (to.isContract()) {
1097             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1098                 return retval == IERC721Receiver.onERC721Received.selector;
1099             } catch (bytes memory reason) {
1100                 if (reason.length == 0) {
1101                     revert("ERC721: transfer to non ERC721Receiver implementer");
1102                 } else {
1103                     assembly {
1104                         revert(add(32, reason), mload(reason))
1105                     }
1106                 }
1107             }
1108         } else {
1109             return true;
1110         }
1111     }
1112 
1113     /**
1114      * @dev Hook that is called before any token transfer. This includes minting
1115      * and burning.
1116      *
1117      * Calling conditions:
1118      *
1119      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1120      * transferred to `to`.
1121      * - When `from` is zero, `tokenId` will be minted for `to`.
1122      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1123      * - `from` and `to` are never both zero.
1124      *
1125      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1126      */
1127     function _beforeTokenTransfer(
1128         address from,
1129         address to,
1130         uint256 tokenId
1131     ) internal virtual {}
1132 }
1133 
1134 // File: BoredLarvaInsectClub.sol
1135 
1136 
1137 
1138 /*
1139     ____   __     ____ ______
1140    / __ ) / /    /  _// ____/
1141   / __  |/ /     / / / /     
1142  / /_/ // /___ _/ / / /___   
1143 /_____//_____//___/ \____/   
1144                              
1145 */
1146 
1147 pragma solidity >=0.7.0 <0.9.0;
1148 
1149 
1150 
1151 
1152 contract BoredLarvaInsectClub is ERC721, Ownable {
1153   using Strings for uint256;
1154   using Counters for Counters.Counter;
1155 
1156   Counters.Counter private supply;
1157 
1158   string public uriPrefix = "";
1159   string public uriSuffix = ".json";
1160   
1161   uint256 public cost = 0.02 ether;
1162   uint256 public maxSupply = 5000;
1163   uint256 public maxMintAmountPerTx = 10;
1164   uint256 public FreeMintReserve = 1000;
1165 
1166   bool public paused = false;
1167 
1168 
1169   constructor() ERC721("Bored Larva Insect Club", "BLIC") {
1170     setUriPrefix("ipfs://QmdFRgHgExa5ueWGUyPjjfrSwFpekvVQfGHekqi5nGjT8c/");
1171   }
1172 
1173   modifier mintCompliance(uint256 _mintAmount) {
1174     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1175     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1176     _;
1177   }
1178 
1179   function totalSupply() public view returns (uint256) {
1180     return supply.current();
1181   }
1182 
1183   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1184     require(!paused, "The contract is paused!");
1185     if (supply.current() < FreeMintReserve ) {
1186             require(supply.current() + _mintAmount <= FreeMintReserve, "Exceeds Free mint");
1187             
1188         }
1189     else{
1190         
1191         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1192     }
1193 
1194          _mintLoop(msg.sender, _mintAmount);
1195 
1196     }
1197   
1198   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1199     _mintLoop(_receiver, _mintAmount);
1200   }
1201 
1202   function walletOfOwner(address _owner)
1203     public
1204     view
1205     returns (uint256[] memory)
1206   {
1207     uint256 ownerTokenCount = balanceOf(_owner);
1208     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1209     uint256 currentTokenId = 1;
1210     uint256 ownedTokenIndex = 0;
1211 
1212     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1213       address currentTokenOwner = ownerOf(currentTokenId);
1214 
1215       if (currentTokenOwner == _owner) {
1216         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1217 
1218         ownedTokenIndex++;
1219       }
1220 
1221       currentTokenId++;
1222     }
1223 
1224     return ownedTokenIds;
1225   }
1226 
1227   function tokenURI(uint256 _tokenId)
1228     public
1229     view
1230     virtual
1231     override
1232     returns (string memory)
1233   {
1234     require(
1235       _exists(_tokenId),
1236       "ERC721Metadata: URI query for nonexistent token"
1237     );
1238 
1239 
1240     string memory currentBaseURI = _baseURI();
1241     return bytes(currentBaseURI).length > 0
1242         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1243         : "";
1244   }
1245 
1246   function setCost(uint256 _cost) public onlyOwner {
1247     cost = _cost;
1248   }
1249 
1250   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1251     maxMintAmountPerTx = _maxMintAmountPerTx;
1252   }
1253 
1254   function setFreeMintReserve(uint256 _FreeMintReserve) public onlyOwner {
1255     FreeMintReserve = _FreeMintReserve;
1256   }
1257 
1258   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1259     uriPrefix = _uriPrefix;
1260   }
1261 
1262   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1263     uriSuffix = _uriSuffix;
1264   }
1265 
1266   function setPaused(bool _state) public onlyOwner {
1267     paused = _state;
1268   }
1269 
1270   function withdraw() public onlyOwner {
1271 
1272     (bool hs, ) = payable(0xD9a6699B10735E4624efeC414D235e6862d14cA6).call{value: address(this).balance * 50 / 100}("");
1273     require(hs);
1274 
1275     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1276     require(os);
1277    
1278   }
1279 
1280   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1281     for (uint256 i = 0; i < _mintAmount; i++) {
1282       supply.increment();
1283       _safeMint(_receiver, supply.current());
1284     }
1285   }
1286 
1287   function _baseURI() internal view virtual override returns (string memory) {
1288     return uriPrefix;
1289  }
1290 }