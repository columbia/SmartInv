1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
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
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev String operations.
56  */
57 library Strings {
58     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
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
115 }
116 
117 // File: @openzeppelin/contracts/utils/Context.sol
118 
119 
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Provides information about the current execution context, including the
125  * sender of the transaction and its data. While these are generally available
126  * via msg.sender and msg.data, they should not be accessed in such a direct
127  * manner, since when dealing with meta-transactions the account sending and
128  * paying for execution may not be the actual sender (as far as an application
129  * is concerned).
130  *
131  * This contract is only required for intermediate, library-like contracts.
132  */
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes calldata) {
139         return msg.data;
140     }
141 }
142 
143 // File: @openzeppelin/contracts/access/Ownable.sol
144 
145 
146 
147 pragma solidity ^0.8.0;
148 
149 
150 /**
151  * @dev Contract module which provides a basic access control mechanism, where
152  * there is an account (an owner) that can be granted exclusive access to
153  * specific functions.
154  *
155  * By default, the owner account will be the one that deploys the contract. This
156  * can later be changed with {transferOwnership}.
157  *
158  * This module is used through inheritance. It will make available the modifier
159  * `onlyOwner`, which can be applied to your functions to restrict their use to
160  * the owner.
161  */
162 abstract contract Ownable is Context {
163     address private _owner;
164 
165     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
166 
167     /**
168      * @dev Initializes the contract setting the deployer as the initial owner.
169      */
170     constructor() {
171         _setOwner(_msgSender());
172     }
173 
174     /**
175      * @dev Returns the address of the current owner.
176      */
177     function owner() public view virtual returns (address) {
178         return _owner;
179     }
180 
181     /**
182      * @dev Throws if called by any account other than the owner.
183      */
184     modifier onlyOwner() {
185         require(owner() == _msgSender(), "Ownable: caller is not the owner");
186         _;
187     }
188 
189     /**
190      * @dev Leaves the contract without owner. It will not be possible to call
191      * `onlyOwner` functions anymore. Can only be called by the current owner.
192      *
193      * NOTE: Renouncing ownership will leave the contract without an owner,
194      * thereby removing any functionality that is only available to the owner.
195      */
196     function renounceOwnership() public virtual onlyOwner {
197         _setOwner(address(0));
198     }
199 
200     /**
201      * @dev Transfers ownership of the contract to a new account (`newOwner`).
202      * Can only be called by the current owner.
203      */
204     function transferOwnership(address newOwner) public virtual onlyOwner {
205         require(newOwner != address(0), "Ownable: new owner is the zero address");
206         _setOwner(newOwner);
207     }
208 
209     function _setOwner(address newOwner) private {
210         address oldOwner = _owner;
211         _owner = newOwner;
212         emit OwnershipTransferred(oldOwner, newOwner);
213     }
214 }
215 
216 // File: @openzeppelin/contracts/utils/Address.sol
217 
218 
219 
220 pragma solidity ^0.8.0;
221 
222 /**
223  * @dev Collection of functions related to the address type
224  */
225 library Address {
226     /**
227      * @dev Returns true if `account` is a contract.
228      *
229      * [IMPORTANT]
230      * ====
231      * It is unsafe to assume that an address for which this function returns
232      * false is an externally-owned account (EOA) and not a contract.
233      *
234      * Among others, `isContract` will return false for the following
235      * types of addresses:
236      *
237      *  - an externally-owned account
238      *  - a contract in construction
239      *  - an address where a contract will be created
240      *  - an address where a contract lived, but was destroyed
241      * ====
242      */
243     function isContract(address account) internal view returns (bool) {
244         // This method relies on extcodesize, which returns 0 for contracts in
245         // construction, since the code is only stored at the end of the
246         // constructor execution.
247 
248         uint256 size;
249         assembly {
250             size := extcodesize(account)
251         }
252         return size > 0;
253     }
254 
255     /**
256      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
257      * `recipient`, forwarding all available gas and reverting on errors.
258      *
259      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
260      * of certain opcodes, possibly making contracts go over the 2300 gas limit
261      * imposed by `transfer`, making them unable to receive funds via
262      * `transfer`. {sendValue} removes this limitation.
263      *
264      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
265      *
266      * IMPORTANT: because control is transferred to `recipient`, care must be
267      * taken to not create reentrancy vulnerabilities. Consider using
268      * {ReentrancyGuard} or the
269      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
270      */
271     function sendValue(address payable recipient, uint256 amount) internal {
272         require(address(this).balance >= amount, "Address: insufficient balance");
273 
274         (bool success, ) = recipient.call{value: amount}("");
275         require(success, "Address: unable to send value, recipient may have reverted");
276     }
277 
278     /**
279      * @dev Performs a Solidity function call using a low level `call`. A
280      * plain `call` is an unsafe replacement for a function call: use this
281      * function instead.
282      *
283      * If `target` reverts with a revert reason, it is bubbled up by this
284      * function (like regular Solidity function calls).
285      *
286      * Returns the raw returned data. To convert to the expected return value,
287      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
288      *
289      * Requirements:
290      *
291      * - `target` must be a contract.
292      * - calling `target` with `data` must not revert.
293      *
294      * _Available since v3.1._
295      */
296     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
297         return functionCall(target, data, "Address: low-level call failed");
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
302      * `errorMessage` as a fallback revert reason when `target` reverts.
303      *
304      * _Available since v3.1._
305      */
306     function functionCall(
307         address target,
308         bytes memory data,
309         string memory errorMessage
310     ) internal returns (bytes memory) {
311         return functionCallWithValue(target, data, 0, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but also transferring `value` wei to `target`.
317      *
318      * Requirements:
319      *
320      * - the calling contract must have an ETH balance of at least `value`.
321      * - the called Solidity function must be `payable`.
322      *
323      * _Available since v3.1._
324      */
325     function functionCallWithValue(
326         address target,
327         bytes memory data,
328         uint256 value
329     ) internal returns (bytes memory) {
330         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
335      * with `errorMessage` as a fallback revert reason when `target` reverts.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(
340         address target,
341         bytes memory data,
342         uint256 value,
343         string memory errorMessage
344     ) internal returns (bytes memory) {
345         require(address(this).balance >= value, "Address: insufficient balance for call");
346         require(isContract(target), "Address: call to non-contract");
347 
348         (bool success, bytes memory returndata) = target.call{value: value}(data);
349         return verifyCallResult(success, returndata, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but performing a static call.
355      *
356      * _Available since v3.3._
357      */
358     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
359         return functionStaticCall(target, data, "Address: low-level static call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
364      * but performing a static call.
365      *
366      * _Available since v3.3._
367      */
368     function functionStaticCall(
369         address target,
370         bytes memory data,
371         string memory errorMessage
372     ) internal view returns (bytes memory) {
373         require(isContract(target), "Address: static call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.staticcall(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but performing a delegate call.
382      *
383      * _Available since v3.4._
384      */
385     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
386         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
391      * but performing a delegate call.
392      *
393      * _Available since v3.4._
394      */
395     function functionDelegateCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         require(isContract(target), "Address: delegate call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.delegatecall(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
408      * revert reason using the provided one.
409      *
410      * _Available since v4.3._
411      */
412     function verifyCallResult(
413         bool success,
414         bytes memory returndata,
415         string memory errorMessage
416     ) internal pure returns (bytes memory) {
417         if (success) {
418             return returndata;
419         } else {
420             // Look for revert reason and bubble it up if present
421             if (returndata.length > 0) {
422                 // The easiest way to bubble the revert reason is using memory via assembly
423 
424                 assembly {
425                     let returndata_size := mload(returndata)
426                     revert(add(32, returndata), returndata_size)
427                 }
428             } else {
429                 revert(errorMessage);
430             }
431         }
432     }
433 }
434 
435 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
436 
437 
438 
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @title ERC721 token receiver interface
443  * @dev Interface for any contract that wants to support safeTransfers
444  * from ERC721 asset contracts.
445  */
446 interface IERC721Receiver {
447     /**
448      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
449      * by `operator` from `from`, this function is called.
450      *
451      * It must return its Solidity selector to confirm the token transfer.
452      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
453      *
454      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
455      */
456     function onERC721Received(
457         address operator,
458         address from,
459         uint256 tokenId,
460         bytes calldata data
461     ) external returns (bytes4);
462 }
463 
464 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
465 
466 
467 
468 pragma solidity ^0.8.0;
469 
470 /**
471  * @dev Interface of the ERC165 standard, as defined in the
472  * https://eips.ethereum.org/EIPS/eip-165[EIP].
473  *
474  * Implementers can declare support of contract interfaces, which can then be
475  * queried by others ({ERC165Checker}).
476  *
477  * For an implementation, see {ERC165}.
478  */
479 interface IERC165 {
480     /**
481      * @dev Returns true if this contract implements the interface defined by
482      * `interfaceId`. See the corresponding
483      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
484      * to learn more about how these ids are created.
485      *
486      * This function call must use less than 30 000 gas.
487      */
488     function supportsInterface(bytes4 interfaceId) external view returns (bool);
489 }
490 
491 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
492 
493 
494 
495 pragma solidity ^0.8.0;
496 
497 
498 /**
499  * @dev Implementation of the {IERC165} interface.
500  *
501  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
502  * for the additional interface id that will be supported. For example:
503  *
504  * ```solidity
505  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
506  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
507  * }
508  * ```
509  *
510  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
511  */
512 abstract contract ERC165 is IERC165 {
513     /**
514      * @dev See {IERC165-supportsInterface}.
515      */
516     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
517         return interfaceId == type(IERC165).interfaceId;
518     }
519 }
520 
521 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
522 
523 
524 
525 pragma solidity ^0.8.0;
526 
527 
528 /**
529  * @dev Required interface of an ERC721 compliant contract.
530  */
531 interface IERC721 is IERC165 {
532     /**
533      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
534      */
535     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
536 
537     /**
538      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
539      */
540     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
541 
542     /**
543      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
544      */
545     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
546 
547     /**
548      * @dev Returns the number of tokens in ``owner``'s account.
549      */
550     function balanceOf(address owner) external view returns (uint256 balance);
551 
552     /**
553      * @dev Returns the owner of the `tokenId` token.
554      *
555      * Requirements:
556      *
557      * - `tokenId` must exist.
558      */
559     function ownerOf(uint256 tokenId) external view returns (address owner);
560 
561     /**
562      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
563      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
564      *
565      * Requirements:
566      *
567      * - `from` cannot be the zero address.
568      * - `to` cannot be the zero address.
569      * - `tokenId` token must exist and be owned by `from`.
570      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
571      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
572      *
573      * Emits a {Transfer} event.
574      */
575     function safeTransferFrom(
576         address from,
577         address to,
578         uint256 tokenId
579     ) external;
580 
581     /**
582      * @dev Transfers `tokenId` token from `from` to `to`.
583      *
584      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
585      *
586      * Requirements:
587      *
588      * - `from` cannot be the zero address.
589      * - `to` cannot be the zero address.
590      * - `tokenId` token must be owned by `from`.
591      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
592      *
593      * Emits a {Transfer} event.
594      */
595     function transferFrom(
596         address from,
597         address to,
598         uint256 tokenId
599     ) external;
600 
601     /**
602      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
603      * The approval is cleared when the token is transferred.
604      *
605      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
606      *
607      * Requirements:
608      *
609      * - The caller must own the token or be an approved operator.
610      * - `tokenId` must exist.
611      *
612      * Emits an {Approval} event.
613      */
614     function approve(address to, uint256 tokenId) external;
615 
616     /**
617      * @dev Returns the account approved for `tokenId` token.
618      *
619      * Requirements:
620      *
621      * - `tokenId` must exist.
622      */
623     function getApproved(uint256 tokenId) external view returns (address operator);
624 
625     /**
626      * @dev Approve or remove `operator` as an operator for the caller.
627      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
628      *
629      * Requirements:
630      *
631      * - The `operator` cannot be the caller.
632      *
633      * Emits an {ApprovalForAll} event.
634      */
635     function setApprovalForAll(address operator, bool _approved) external;
636 
637     /**
638      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
639      *
640      * See {setApprovalForAll}
641      */
642     function isApprovedForAll(address owner, address operator) external view returns (bool);
643 
644     /**
645      * @dev Safely transfers `tokenId` token from `from` to `to`.
646      *
647      * Requirements:
648      *
649      * - `from` cannot be the zero address.
650      * - `to` cannot be the zero address.
651      * - `tokenId` token must exist and be owned by `from`.
652      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
653      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
654      *
655      * Emits a {Transfer} event.
656      */
657     function safeTransferFrom(
658         address from,
659         address to,
660         uint256 tokenId,
661         bytes calldata data
662     ) external;
663 }
664 
665 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
666 
667 
668 
669 pragma solidity ^0.8.0;
670 
671 
672 /**
673  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
674  * @dev See https://eips.ethereum.org/EIPS/eip-721
675  */
676 interface IERC721Metadata is IERC721 {
677     /**
678      * @dev Returns the token collection name.
679      */
680     function name() external view returns (string memory);
681 
682     /**
683      * @dev Returns the token collection symbol.
684      */
685     function symbol() external view returns (string memory);
686 
687     /**
688      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
689      */
690     function tokenURI(uint256 tokenId) external view returns (string memory);
691 }
692 
693 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
694 
695 
696 
697 pragma solidity ^0.8.0;
698 
699 
700 
701 
702 
703 
704 
705 
706 /**
707  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
708  * the Metadata extension, but not including the Enumerable extension, which is available separately as
709  * {ERC721Enumerable}.
710  */
711 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
712     using Address for address;
713     using Strings for uint256;
714 
715     // Token name
716     string private _name;
717 
718     // Token symbol
719     string private _symbol;
720 
721     // Mapping from token ID to owner address
722     mapping(uint256 => address) private _owners;
723 
724     // Mapping owner address to token count
725     mapping(address => uint256) private _balances;
726 
727     // Mapping from token ID to approved address
728     mapping(uint256 => address) private _tokenApprovals;
729 
730     // Mapping from owner to operator approvals
731     mapping(address => mapping(address => bool)) private _operatorApprovals;
732 
733     /**
734      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
735      */
736     constructor(string memory name_, string memory symbol_) {
737         _name = name_;
738         _symbol = symbol_;
739     }
740 
741     /**
742      * @dev See {IERC165-supportsInterface}.
743      */
744     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
745         return
746             interfaceId == type(IERC721).interfaceId ||
747             interfaceId == type(IERC721Metadata).interfaceId ||
748             super.supportsInterface(interfaceId);
749     }
750 
751     /**
752      * @dev See {IERC721-balanceOf}.
753      */
754     function balanceOf(address owner) public view virtual override returns (uint256) {
755         require(owner != address(0), "ERC721: balance query for the zero address");
756         return _balances[owner];
757     }
758 
759     /**
760      * @dev See {IERC721-ownerOf}.
761      */
762     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
763         address owner = _owners[tokenId];
764         require(owner != address(0), "ERC721: owner query for nonexistent token");
765         return owner;
766     }
767 
768     /**
769      * @dev See {IERC721Metadata-name}.
770      */
771     function name() public view virtual override returns (string memory) {
772         return _name;
773     }
774 
775     /**
776      * @dev See {IERC721Metadata-symbol}.
777      */
778     function symbol() public view virtual override returns (string memory) {
779         return _symbol;
780     }
781 
782     /**
783      * @dev See {IERC721Metadata-tokenURI}.
784      */
785     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
786         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
787 
788         string memory baseURI = _baseURI();
789         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
790     }
791 
792     /**
793      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
794      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
795      * by default, can be overriden in child contracts.
796      */
797     function _baseURI() internal view virtual returns (string memory) {
798         return "";
799     }
800 
801     /**
802      * @dev See {IERC721-approve}.
803      */
804     function approve(address to, uint256 tokenId) public virtual override {
805         address owner = ERC721.ownerOf(tokenId);
806         require(to != owner, "ERC721: approval to current owner");
807 
808         require(
809             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
810             "ERC721: approve caller is not owner nor approved for all"
811         );
812 
813         _approve(to, tokenId);
814     }
815 
816     /**
817      * @dev See {IERC721-getApproved}.
818      */
819     function getApproved(uint256 tokenId) public view virtual override returns (address) {
820         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
821 
822         return _tokenApprovals[tokenId];
823     }
824 
825     /**
826      * @dev See {IERC721-setApprovalForAll}.
827      */
828     function setApprovalForAll(address operator, bool approved) public virtual override {
829         require(operator != _msgSender(), "ERC721: approve to caller");
830 
831         _operatorApprovals[_msgSender()][operator] = approved;
832         emit ApprovalForAll(_msgSender(), operator, approved);
833     }
834 
835     /**
836      * @dev See {IERC721-isApprovedForAll}.
837      */
838     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
839         return _operatorApprovals[owner][operator];
840     }
841 
842     /**
843      * @dev See {IERC721-transferFrom}.
844      */
845     function transferFrom(
846         address from,
847         address to,
848         uint256 tokenId
849     ) public virtual override {
850         //solhint-disable-next-line max-line-length
851         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
852 
853         _transfer(from, to, tokenId);
854     }
855 
856     /**
857      * @dev See {IERC721-safeTransferFrom}.
858      */
859     function safeTransferFrom(
860         address from,
861         address to,
862         uint256 tokenId
863     ) public virtual override {
864         safeTransferFrom(from, to, tokenId, "");
865     }
866 
867     /**
868      * @dev See {IERC721-safeTransferFrom}.
869      */
870     function safeTransferFrom(
871         address from,
872         address to,
873         uint256 tokenId,
874         bytes memory _data
875     ) public virtual override {
876         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
877         _safeTransfer(from, to, tokenId, _data);
878     }
879 
880     /**
881      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
882      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
883      *
884      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
885      *
886      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
887      * implement alternative mechanisms to perform token transfer, such as signature-based.
888      *
889      * Requirements:
890      *
891      * - `from` cannot be the zero address.
892      * - `to` cannot be the zero address.
893      * - `tokenId` token must exist and be owned by `from`.
894      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
895      *
896      * Emits a {Transfer} event.
897      */
898     function _safeTransfer(
899         address from,
900         address to,
901         uint256 tokenId,
902         bytes memory _data
903     ) internal virtual {
904         _transfer(from, to, tokenId);
905         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
906     }
907 
908     /**
909      * @dev Returns whether `tokenId` exists.
910      *
911      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
912      *
913      * Tokens start existing when they are minted (`_mint`),
914      * and stop existing when they are burned (`_burn`).
915      */
916     function _exists(uint256 tokenId) internal view virtual returns (bool) {
917         return _owners[tokenId] != address(0);
918     }
919 
920     /**
921      * @dev Returns whether `spender` is allowed to manage `tokenId`.
922      *
923      * Requirements:
924      *
925      * - `tokenId` must exist.
926      */
927     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
928         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
929         address owner = ERC721.ownerOf(tokenId);
930         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
931     }
932 
933     /**
934      * @dev Safely mints `tokenId` and transfers it to `to`.
935      *
936      * Requirements:
937      *
938      * - `tokenId` must not exist.
939      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
940      *
941      * Emits a {Transfer} event.
942      */
943     function _safeMint(address to, uint256 tokenId) internal virtual {
944         _safeMint(to, tokenId, "");
945     }
946 
947     /**
948      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
949      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
950      */
951     function _safeMint(
952         address to,
953         uint256 tokenId,
954         bytes memory _data
955     ) internal virtual {
956         _mint(to, tokenId);
957         require(
958             _checkOnERC721Received(address(0), to, tokenId, _data),
959             "ERC721: transfer to non ERC721Receiver implementer"
960         );
961     }
962 
963     /**
964      * @dev Mints `tokenId` and transfers it to `to`.
965      *
966      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
967      *
968      * Requirements:
969      *
970      * - `tokenId` must not exist.
971      * - `to` cannot be the zero address.
972      *
973      * Emits a {Transfer} event.
974      */
975     function _mint(address to, uint256 tokenId) internal virtual {
976         require(to != address(0), "ERC721: mint to the zero address");
977         require(!_exists(tokenId), "ERC721: token already minted");
978 
979         _beforeTokenTransfer(address(0), to, tokenId);
980 
981         _balances[to] += 1;
982         _owners[tokenId] = to;
983 
984         emit Transfer(address(0), to, tokenId);
985     }
986 
987     /**
988      * @dev Destroys `tokenId`.
989      * The approval is cleared when the token is burned.
990      *
991      * Requirements:
992      *
993      * - `tokenId` must exist.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _burn(uint256 tokenId) internal virtual {
998         address owner = ERC721.ownerOf(tokenId);
999 
1000         _beforeTokenTransfer(owner, address(0), tokenId);
1001 
1002         // Clear approvals
1003         _approve(address(0), tokenId);
1004 
1005         _balances[owner] -= 1;
1006         delete _owners[tokenId];
1007 
1008         emit Transfer(owner, address(0), tokenId);
1009     }
1010 
1011     /**
1012      * @dev Transfers `tokenId` from `from` to `to`.
1013      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1014      *
1015      * Requirements:
1016      *
1017      * - `to` cannot be the zero address.
1018      * - `tokenId` token must be owned by `from`.
1019      *
1020      * Emits a {Transfer} event.
1021      */
1022     function _transfer(
1023         address from,
1024         address to,
1025         uint256 tokenId
1026     ) internal virtual {
1027         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1028         require(to != address(0), "ERC721: transfer to the zero address");
1029 
1030         _beforeTokenTransfer(from, to, tokenId);
1031 
1032         // Clear approvals from the previous owner
1033         _approve(address(0), tokenId);
1034 
1035         _balances[from] -= 1;
1036         _balances[to] += 1;
1037         _owners[tokenId] = to;
1038 
1039         emit Transfer(from, to, tokenId);
1040     }
1041 
1042     /**
1043      * @dev Approve `to` to operate on `tokenId`
1044      *
1045      * Emits a {Approval} event.
1046      */
1047     function _approve(address to, uint256 tokenId) internal virtual {
1048         _tokenApprovals[tokenId] = to;
1049         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1050     }
1051 
1052     /**
1053      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1054      * The call is not executed if the target address is not a contract.
1055      *
1056      * @param from address representing the previous owner of the given token ID
1057      * @param to target address that will receive the tokens
1058      * @param tokenId uint256 ID of the token to be transferred
1059      * @param _data bytes optional data to send along with the call
1060      * @return bool whether the call correctly returned the expected magic value
1061      */
1062     function _checkOnERC721Received(
1063         address from,
1064         address to,
1065         uint256 tokenId,
1066         bytes memory _data
1067     ) private returns (bool) {
1068         if (to.isContract()) {
1069             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1070                 return retval == IERC721Receiver.onERC721Received.selector;
1071             } catch (bytes memory reason) {
1072                 if (reason.length == 0) {
1073                     revert("ERC721: transfer to non ERC721Receiver implementer");
1074                 } else {
1075                     assembly {
1076                         revert(add(32, reason), mload(reason))
1077                     }
1078                 }
1079             }
1080         } else {
1081             return true;
1082         }
1083     }
1084 
1085     /**
1086      * @dev Hook that is called before any token transfer. This includes minting
1087      * and burning.
1088      *
1089      * Calling conditions:
1090      *
1091      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1092      * transferred to `to`.
1093      * - When `from` is zero, `tokenId` will be minted for `to`.
1094      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1095      * - `from` and `to` are never both zero.
1096      *
1097      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1098      */
1099     function _beforeTokenTransfer(
1100         address from,
1101         address to,
1102         uint256 tokenId
1103     ) internal virtual {}
1104 }
1105 
1106 // File: contracts/Womens.sol
1107 
1108 
1109 
1110 pragma solidity ^0.8.9;
1111 
1112 //------------------------------------------------------------------------------
1113 /*
1114 ░██████╗░██╗░░░██╗░█████╗░██╗░░░░░██╗███████╗██╗███████╗██████╗░  ██████╗░███████╗██╗░░░██╗░██████╗
1115 ██╔═══██╗██║░░░██║██╔══██╗██║░░░░░██║██╔════╝██║██╔════╝██╔══██╗  ██╔══██╗██╔════╝██║░░░██║██╔════╝
1116 ██║██╗██║██║░░░██║███████║██║░░░░░██║█████╗░░██║█████╗░░██║░░██║  ██║░░██║█████╗░░╚██╗░██╔╝╚█████╗░
1117 ╚██████╔╝██║░░░██║██╔══██║██║░░░░░██║██╔══╝░░██║██╔══╝░░██║░░██║  ██║░░██║██╔══╝░░░╚████╔╝░░╚═══██╗
1118 ░╚═██╔═╝░╚██████╔╝██║░░██║███████╗██║██║░░░░░██║███████╗██████╔╝  ██████╔╝███████╗░░╚██╔╝░░██████╔╝
1119 ░░░╚═╝░░░░╚═════╝░╚═╝░░╚═╝╚══════╝╚═╝╚═╝░░░░░╚═╝╚══════╝╚═════╝░  ╚═════╝░╚══════╝░░░╚═╝░░░╚═════╝░
1120 */
1121 //------------------------------------------------------------------------------
1122 // Author: orion (@OrionDevStar)
1123 //------------------------------------------------------------------------------
1124 
1125 
1126 
1127 
1128 contract WACNFT is ERC721, Ownable {
1129   using Counters for Counters.Counter;
1130   using Strings for uint256;
1131 
1132   string  private baseURI;
1133   string  private notRevealedUri;
1134   uint256 public PRESALE_COST = 0.08 ether;
1135   uint256 public PUBLIC_COST = 0.1 ether;
1136   uint256 public PRESALE_MINT_AMOUNT = 3;
1137   uint256 public PUBLICT_MINT_AMOUNT = 5;  
1138   uint256 public MAX_SUPPLY = 10000;
1139   uint256 public MAX_PRESALE = 1500;
1140   uint256 public RESERVE_SUPPLY = 200;
1141   uint256 public UNIC_SUPPLY = 7; 
1142   uint256 public PRESALE_MINT_DATE = 1639778400;
1143   uint256 public PUBLICSALE_MINT_DATE = 1640037600;
1144   mapping(address => bool) public WLIST;
1145   mapping(address => uint256) public addressMintedBalance;
1146   address[] public addressRaffle; 
1147   Counters.Counter public tokenIdCounter;
1148   Counters.Counter public reserveTokenIdCounter;
1149   Counters.Counter public unicTokenIdCounter;
1150 
1151   constructor(
1152     string memory _name,
1153     string memory _symbol,
1154     string memory _initBaseURI,
1155     string memory _initNotRevealedUri,
1156     address[] memory _whitelisted
1157    ) 
1158     ERC721(_name, _symbol)
1159    {
1160     setBaseURI(_initBaseURI);
1161     setNotRevealedURI(_initNotRevealedUri);
1162     tokenIdCounter._value = 7;
1163     for (uint256 i = 0; i < _whitelisted.length; i++) {
1164       if (!WLIST[_whitelisted[i]]) {
1165         WLIST[_whitelisted[i]] = true;
1166       }
1167     }
1168   }
1169 
1170   // internal
1171   function _baseURI() internal view virtual override returns (string memory) {
1172     return baseURI;
1173   }
1174 
1175   function random() internal view returns (uint) {
1176       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, addressRaffle)));
1177   }  
1178 
1179   // public
1180   function mint(uint256 _mintAmount) public payable {
1181     require(tokenIdCounter.current() + _mintAmount <= MAX_SUPPLY - RESERVE_SUPPLY + reserveTokenIdCounter.current(), "Max NFT limit exceeded");
1182     uint256 mintCost = PUBLIC_COST;
1183     uint256 maxMintAmount = PUBLICT_MINT_AMOUNT;
1184     if(block.timestamp >= PRESALE_MINT_DATE &&  block.timestamp < PUBLICSALE_MINT_DATE) {
1185           require(WLIST[msg.sender] == true, "User is not whitelisted");
1186           require(tokenIdCounter.current() + _mintAmount <= MAX_PRESALE - RESERVE_SUPPLY + reserveTokenIdCounter.current(), "Max pre-sale NFT limit exceeded");
1187           maxMintAmount = PRESALE_MINT_AMOUNT;
1188           mintCost = PRESALE_COST;
1189     } 
1190 
1191     if(addressMintedBalance[msg.sender]+_mintAmount >= maxMintAmount && !(addressMintedBalance[msg.sender] >= maxMintAmount)) {
1192       addressRaffle.push(msg.sender);
1193     }
1194     require(msg.value >= mintCost * _mintAmount, "Insufficient funds");
1195     for (uint256 i = 1; i <= _mintAmount; i++) {
1196       tokenIdCounter.increment();
1197       _safeMint(msg.sender, tokenIdCounter.current());
1198     }
1199     addressMintedBalance[msg.sender] += _mintAmount;
1200   }
1201 
1202   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1203     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1204     
1205     if(block.timestamp < PRESALE_MINT_DATE) {
1206         return notRevealedUri;
1207     }
1208 
1209     string memory currentBaseURI = _baseURI();
1210     return bytes(currentBaseURI).length > 0
1211         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
1212         : "";
1213   } 
1214 
1215   //only owner
1216   function reserveMint(uint256 _mintAmount) public onlyOwner {
1217     require(reserveTokenIdCounter.current() + _mintAmount <= RESERVE_SUPPLY, "reserve NFT limit exceeded");
1218     for (uint256 i = 1; i <= _mintAmount; i++) {
1219       reserveTokenIdCounter.increment();
1220       tokenIdCounter.increment();
1221       _safeMint(msg.sender, tokenIdCounter.current());
1222     }
1223   }
1224 
1225   function raffle() public onlyOwner {
1226     address winner = addressRaffle[random()%addressRaffle.length];
1227     unicTokenIdCounter.increment();
1228     require(unicTokenIdCounter.current() <= UNIC_SUPPLY, "Unic NFT limit exceeded");
1229     _safeMint(winner, unicTokenIdCounter.current());
1230   }
1231 
1232   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1233     baseURI = _newBaseURI;
1234   }
1235   
1236   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1237     notRevealedUri = _notRevealedURI;
1238   }
1239 
1240   function addToWhiteList(address[] calldata addresses) external onlyOwner {
1241     for (uint256 i = 0; i < addresses.length; i++) {
1242       if (!WLIST[addresses[i]]) {
1243         WLIST[addresses[i]] = true;
1244       }
1245     }
1246   }
1247     
1248   function withdraw() public payable onlyOwner {
1249     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1250     require(os);
1251   }
1252 }