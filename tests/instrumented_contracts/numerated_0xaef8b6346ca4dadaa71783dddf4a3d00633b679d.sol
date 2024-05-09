1 // File: @openzeppelin/contracts/utils/Counters.sol
2 // SPDX-License-Identifier: MIT
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @title Counters
9  * @author Matt Condon (@shrugs)
10  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
11  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
12  *
13  * Include with `using Counters for Counters.Counter;`
14  */
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
49 
50 pragma solidity ^0.8.0;
51 
52 /**
53  * @dev String operations.
54  */
55 library Strings {
56     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
60      */
61     function toString(uint256 value) internal pure returns (string memory) {
62         // Inspired by OraclizeAPI's implementation - MIT licence
63         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
64 
65         if (value == 0) {
66             return "0";
67         }
68         uint256 temp = value;
69         uint256 digits;
70         while (temp != 0) {
71             digits++;
72             temp /= 10;
73         }
74         bytes memory buffer = new bytes(digits);
75         while (value != 0) {
76             digits -= 1;
77             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
78             value /= 10;
79         }
80         return string(buffer);
81     }
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
85      */
86     function toHexString(uint256 value) internal pure returns (string memory) {
87         if (value == 0) {
88             return "0x00";
89         }
90         uint256 temp = value;
91         uint256 length = 0;
92         while (temp != 0) {
93             length++;
94             temp >>= 8;
95         }
96         return toHexString(value, length);
97     }
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
101      */
102     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
103         bytes memory buffer = new bytes(2 * length + 2);
104         buffer[0] = "0";
105         buffer[1] = "x";
106         for (uint256 i = 2 * length + 1; i > 1; --i) {
107             buffer[i] = _HEX_SYMBOLS[value & 0xf];
108             value >>= 4;
109         }
110         require(value == 0, "Strings: hex length insufficient");
111         return string(buffer);
112     }
113 }
114 
115 // File: @openzeppelin/contracts/utils/Context.sol
116 
117 
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Provides information about the current execution context, including the
123  * sender of the transaction and its data. While these are generally available
124  * via msg.sender and msg.data, they should not be accessed in such a direct
125  * manner, since when dealing with meta-transactions the account sending and
126  * paying for execution may not be the actual sender (as far as an application
127  * is concerned).
128  *
129  * This contract is only required for intermediate, library-like contracts.
130  */
131 abstract contract Context {
132     function _msgSender() internal view virtual returns (address) {
133         return msg.sender;
134     }
135 
136     function _msgData() internal view virtual returns (bytes calldata) {
137         return msg.data;
138     }
139 }
140 
141 // File: @openzeppelin/contracts/access/Ownable.sol
142 
143 
144 
145 pragma solidity ^0.8.0;
146 
147 
148 /**
149  * @dev Contract module which provides a basic access control mechanism, where
150  * there is an account (an owner) that can be granted exclusive access to
151  * specific functions.
152  *
153  * By default, the owner account will be the one that deploys the contract. This
154  * can later be changed with {transferOwnership}.
155  *
156  * This module is used through inheritance. It will make available the modifier
157  * `onlyOwner`, which can be applied to your functions to restrict their use to
158  * the owner.
159  */
160 abstract contract Ownable is Context {
161     address private _owner;
162 
163     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
164 
165     /**
166      * @dev Initializes the contract setting the deployer as the initial owner.
167      */
168     constructor() {
169         _setOwner(_msgSender());
170     }
171 
172     /**
173      * @dev Returns the address of the current owner.
174      */
175     function owner() public view virtual returns (address) {
176         return _owner;
177     }
178 
179     /**
180      * @dev Throws if called by any account other than the owner.
181      */
182     modifier onlyOwner() {
183         require(owner() == _msgSender(), "Ownable: caller is not the owner");
184         _;
185     }
186 
187     /**
188      * @dev Leaves the contract without owner. It will not be possible to call
189      * `onlyOwner` functions anymore. Can only be called by the current owner.
190      *
191      * NOTE: Renouncing ownership will leave the contract without an owner,
192      * thereby removing any functionality that is only available to the owner.
193      */
194     function renounceOwnership() public virtual onlyOwner {
195         _setOwner(address(0));
196     }
197 
198     /**
199      * @dev Transfers ownership of the contract to a new account (`newOwner`).
200      * Can only be called by the current owner.
201      */
202     function transferOwnership(address newOwner) public virtual onlyOwner {
203         require(newOwner != address(0), "Ownable: new owner is the zero address");
204         _setOwner(newOwner);
205     }
206 
207     function _setOwner(address newOwner) private {
208         address oldOwner = _owner;
209         _owner = newOwner;
210         emit OwnershipTransferred(oldOwner, newOwner);
211     }
212 }
213 
214 // File: @openzeppelin/contracts/utils/Address.sol
215 
216 
217 
218 pragma solidity ^0.8.0;
219 
220 /**
221  * @dev Collection of functions related to the address type
222  */
223 library Address {
224     /**
225      * @dev Returns true if `account` is a contract.
226      *
227      * [IMPORTANT]
228      * ====
229      * It is unsafe to assume that an address for which this function returns
230      * false is an externally-owned account (EOA) and not a contract.
231      *
232      * Among others, `isContract` will return false for the following
233      * types of addresses:
234      *
235      *  - an externally-owned account
236      *  - a contract in construction
237      *  - an address where a contract will be created
238      *  - an address where a contract lived, but was destroyed
239      * ====
240      */
241     function isContract(address account) internal view returns (bool) {
242         // This method relies on extcodesize, which returns 0 for contracts in
243         // construction, since the code is only stored at the end of the
244         // constructor execution.
245 
246         uint256 size;
247         assembly {
248             size := extcodesize(account)
249         }
250         return size > 0;
251     }
252 
253     /**
254      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
255      * `recipient`, forwarding all available gas and reverting on errors.
256      *
257      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
258      * of certain opcodes, possibly making contracts go over the 2300 gas limit
259      * imposed by `transfer`, making them unable to receive funds via
260      * `transfer`. {sendValue} removes this limitation.
261      *
262      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
263      *
264      * IMPORTANT: because control is transferred to `recipient`, care must be
265      * taken to not create reentrancy vulnerabilities. Consider using
266      * {ReentrancyGuard} or the
267      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
268      */
269     function sendValue(address payable recipient, uint256 amount) internal {
270         require(address(this).balance >= amount, "Address: insufficient balance");
271 
272         (bool success, ) = recipient.call{value: amount}("");
273         require(success, "Address: unable to send value, recipient may have reverted");
274     }
275 
276     /**
277      * @dev Performs a Solidity function call using a low level `call`. A
278      * plain `call` is an unsafe replacement for a function call: use this
279      * function instead.
280      *
281      * If `target` reverts with a revert reason, it is bubbled up by this
282      * function (like regular Solidity function calls).
283      *
284      * Returns the raw returned data. To convert to the expected return value,
285      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
286      *
287      * Requirements:
288      *
289      * - `target` must be a contract.
290      * - calling `target` with `data` must not revert.
291      *
292      * _Available since v3.1._
293      */
294     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
295         return functionCall(target, data, "Address: low-level call failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
300      * `errorMessage` as a fallback revert reason when `target` reverts.
301      *
302      * _Available since v3.1._
303      */
304     function functionCall(
305         address target,
306         bytes memory data,
307         string memory errorMessage
308     ) internal returns (bytes memory) {
309         return functionCallWithValue(target, data, 0, errorMessage);
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
314      * but also transferring `value` wei to `target`.
315      *
316      * Requirements:
317      *
318      * - the calling contract must have an ETH balance of at least `value`.
319      * - the called Solidity function must be `payable`.
320      *
321      * _Available since v3.1._
322      */
323     function functionCallWithValue(
324         address target,
325         bytes memory data,
326         uint256 value
327     ) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
333      * with `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(
338         address target,
339         bytes memory data,
340         uint256 value,
341         string memory errorMessage
342     ) internal returns (bytes memory) {
343         require(address(this).balance >= value, "Address: insufficient balance for call");
344         require(isContract(target), "Address: call to non-contract");
345 
346         (bool success, bytes memory returndata) = target.call{value: value}(data);
347         return verifyCallResult(success, returndata, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but performing a static call.
353      *
354      * _Available since v3.3._
355      */
356     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
357         return functionStaticCall(target, data, "Address: low-level static call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(
367         address target,
368         bytes memory data,
369         string memory errorMessage
370     ) internal view returns (bytes memory) {
371         require(isContract(target), "Address: static call to non-contract");
372 
373         (bool success, bytes memory returndata) = target.staticcall(data);
374         return verifyCallResult(success, returndata, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but performing a delegate call.
380      *
381      * _Available since v3.4._
382      */
383     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
384         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
389      * but performing a delegate call.
390      *
391      * _Available since v3.4._
392      */
393     function functionDelegateCall(
394         address target,
395         bytes memory data,
396         string memory errorMessage
397     ) internal returns (bytes memory) {
398         require(isContract(target), "Address: delegate call to non-contract");
399 
400         (bool success, bytes memory returndata) = target.delegatecall(data);
401         return verifyCallResult(success, returndata, errorMessage);
402     }
403 
404     /**
405      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
406      * revert reason using the provided one.
407      *
408      * _Available since v4.3._
409      */
410     function verifyCallResult(
411         bool success,
412         bytes memory returndata,
413         string memory errorMessage
414     ) internal pure returns (bytes memory) {
415         if (success) {
416             return returndata;
417         } else {
418             // Look for revert reason and bubble it up if present
419             if (returndata.length > 0) {
420                 // The easiest way to bubble the revert reason is using memory via assembly
421 
422                 assembly {
423                     let returndata_size := mload(returndata)
424                     revert(add(32, returndata), returndata_size)
425                 }
426             } else {
427                 revert(errorMessage);
428             }
429         }
430     }
431 }
432 
433 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
434 
435 
436 
437 pragma solidity ^0.8.0;
438 
439 /**
440  * @title ERC721 token receiver interface
441  * @dev Interface for any contract that wants to support safeTransfers
442  * from ERC721 asset contracts.
443  */
444 interface IERC721Receiver {
445     /**
446      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
447      * by `operator` from `from`, this function is called.
448      *
449      * It must return its Solidity selector to confirm the token transfer.
450      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
451      *
452      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
453      */
454     function onERC721Received(
455         address operator,
456         address from,
457         uint256 tokenId,
458         bytes calldata data
459     ) external returns (bytes4);
460 }
461 
462 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
463 
464 
465 
466 pragma solidity ^0.8.0;
467 
468 /**
469  * @dev Interface of the ERC165 standard, as defined in the
470  * https://eips.ethereum.org/EIPS/eip-165[EIP].
471  *
472  * Implementers can declare support of contract interfaces, which can then be
473  * queried by others ({ERC165Checker}).
474  *
475  * For an implementation, see {ERC165}.
476  */
477 interface IERC165 {
478     /**
479      * @dev Returns true if this contract implements the interface defined by
480      * `interfaceId`. See the corresponding
481      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
482      * to learn more about how these ids are created.
483      *
484      * This function call must use less than 30 000 gas.
485      */
486     function supportsInterface(bytes4 interfaceId) external view returns (bool);
487 }
488 
489 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
490 
491 
492 
493 pragma solidity ^0.8.0;
494 
495 
496 /**
497  * @dev Implementation of the {IERC165} interface.
498  *
499  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
500  * for the additional interface id that will be supported. For example:
501  *
502  * ```solidity
503  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
504  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
505  * }
506  * ```
507  *
508  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
509  */
510 abstract contract ERC165 is IERC165 {
511     /**
512      * @dev See {IERC165-supportsInterface}.
513      */
514     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
515         return interfaceId == type(IERC165).interfaceId;
516     }
517 }
518 
519 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
520 
521 
522 
523 pragma solidity ^0.8.0;
524 
525 
526 /**
527  * @dev Required interface of an ERC721 compliant contract.
528  */
529 interface IERC721 is IERC165 {
530     /**
531      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
532      */
533     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
534 
535     /**
536      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
537      */
538     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
539 
540     /**
541      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
542      */
543     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
544 
545     /**
546      * @dev Returns the number of tokens in ``owner``'s account.
547      */
548     function balanceOf(address owner) external view returns (uint256 balance);
549 
550     /**
551      * @dev Returns the owner of the `tokenId` token.
552      *
553      * Requirements:
554      *
555      * - `tokenId` must exist.
556      */
557     function ownerOf(uint256 tokenId) external view returns (address owner);
558 
559     /**
560      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
561      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
562      *
563      * Requirements:
564      *
565      * - `from` cannot be the zero address.
566      * - `to` cannot be the zero address.
567      * - `tokenId` token must exist and be owned by `from`.
568      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
569      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
570      *
571      * Emits a {Transfer} event.
572      */
573     function safeTransferFrom(
574         address from,
575         address to,
576         uint256 tokenId
577     ) external;
578 
579     /**
580      * @dev Transfers `tokenId` token from `from` to `to`.
581      *
582      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
583      *
584      * Requirements:
585      *
586      * - `from` cannot be the zero address.
587      * - `to` cannot be the zero address.
588      * - `tokenId` token must be owned by `from`.
589      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
590      *
591      * Emits a {Transfer} event.
592      */
593     function transferFrom(
594         address from,
595         address to,
596         uint256 tokenId
597     ) external;
598 
599     /**
600      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
601      * The approval is cleared when the token is transferred.
602      *
603      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
604      *
605      * Requirements:
606      *
607      * - The caller must own the token or be an approved operator.
608      * - `tokenId` must exist.
609      *
610      * Emits an {Approval} event.
611      */
612     function approve(address to, uint256 tokenId) external;
613 
614     /**
615      * @dev Returns the account approved for `tokenId` token.
616      *
617      * Requirements:
618      *
619      * - `tokenId` must exist.
620      */
621     function getApproved(uint256 tokenId) external view returns (address operator);
622 
623     /**
624      * @dev Approve or remove `operator` as an operator for the caller.
625      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
626      *
627      * Requirements:
628      *
629      * - The `operator` cannot be the caller.
630      *
631      * Emits an {ApprovalForAll} event.
632      */
633     function setApprovalForAll(address operator, bool _approved) external;
634 
635     /**
636      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
637      *
638      * See {setApprovalForAll}
639      */
640     function isApprovedForAll(address owner, address operator) external view returns (bool);
641 
642     /**
643      * @dev Safely transfers `tokenId` token from `from` to `to`.
644      *
645      * Requirements:
646      *
647      * - `from` cannot be the zero address.
648      * - `to` cannot be the zero address.
649      * - `tokenId` token must exist and be owned by `from`.
650      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
651      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
652      *
653      * Emits a {Transfer} event.
654      */
655     function safeTransferFrom(
656         address from,
657         address to,
658         uint256 tokenId,
659         bytes calldata data
660     ) external;
661 }
662 
663 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
664 
665 
666 
667 pragma solidity ^0.8.0;
668 
669 
670 /**
671  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
672  * @dev See https://eips.ethereum.org/EIPS/eip-721
673  */
674 interface IERC721Enumerable is IERC721 {
675     /**
676      * @dev Returns the total amount of tokens stored by the contract.
677      */
678     function totalSupply() external view returns (uint256);
679 
680     /**
681      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
682      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
683      */
684     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
685 
686     /**
687      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
688      * Use along with {totalSupply} to enumerate all tokens.
689      */
690     function tokenByIndex(uint256 index) external view returns (uint256);
691 }
692 
693 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
694 
695 
696 
697 pragma solidity ^0.8.0;
698 
699 
700 /**
701  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
702  * @dev See https://eips.ethereum.org/EIPS/eip-721
703  */
704 interface IERC721Metadata is IERC721 {
705     /**
706      * @dev Returns the token collection name.
707      */
708     function name() external view returns (string memory);
709 
710     /**
711      * @dev Returns the token collection symbol.
712      */
713     function symbol() external view returns (string memory);
714 
715     /**
716      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
717      */
718     function tokenURI(uint256 tokenId) external view returns (string memory);
719 }
720 
721 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
722 
723 
724 
725 pragma solidity ^0.8.0;
726 
727 
728 
729 
730 
731 
732 
733 
734 /**
735  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
736  * the Metadata extension, but not including the Enumerable extension, which is available separately as
737  * {ERC721Enumerable}.
738  */
739 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
740     using Address for address;
741     using Strings for uint256;
742 
743     // Token name
744     string private _name;
745 
746     // Token symbol
747     string private _symbol;
748 
749     // Mapping from token ID to owner address
750     mapping(uint256 => address) private _owners;
751 
752     // Mapping owner address to token count
753     mapping(address => uint256) private _balances;
754 
755     // Mapping from token ID to approved address
756     mapping(uint256 => address) private _tokenApprovals;
757 
758     // Mapping from owner to operator approvals
759     mapping(address => mapping(address => bool)) private _operatorApprovals;
760 
761     /**
762      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
763      */
764     constructor(string memory name_, string memory symbol_) {
765         _name = name_;
766         _symbol = symbol_;
767     }
768 
769     /**
770      * @dev See {IERC165-supportsInterface}.
771      */
772     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
773         return
774             interfaceId == type(IERC721).interfaceId ||
775             interfaceId == type(IERC721Metadata).interfaceId ||
776             super.supportsInterface(interfaceId);
777     }
778 
779     /**
780      * @dev See {IERC721-balanceOf}.
781      */
782     function balanceOf(address owner) public view virtual override returns (uint256) {
783         require(owner != address(0), "ERC721: balance query for the zero address");
784         return _balances[owner];
785     }
786 
787     /**
788      * @dev See {IERC721-ownerOf}.
789      */
790     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
791         address owner = _owners[tokenId];
792         require(owner != address(0), "ERC721: owner query for nonexistent token");
793         return owner;
794     }
795 
796     /**
797      * @dev See {IERC721Metadata-name}.
798      */
799     function name() public view virtual override returns (string memory) {
800         return _name;
801     }
802 
803     /**
804      * @dev See {IERC721Metadata-symbol}.
805      */
806     function symbol() public view virtual override returns (string memory) {
807         return _symbol;
808     }
809 
810     /**
811      * @dev See {IERC721Metadata-tokenURI}.
812      */
813     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
814         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
815 
816         string memory baseURI = _baseURI();
817         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
818     }
819 
820     /**
821      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
822      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
823      * by default, can be overriden in child contracts.
824      */
825     function _baseURI() internal view virtual returns (string memory) {
826         return "";
827     }
828 
829     /**
830      * @dev See {IERC721-approve}.
831      */
832     function approve(address to, uint256 tokenId) public virtual override {
833         address owner = ERC721.ownerOf(tokenId);
834         require(to != owner, "ERC721: approval to current owner");
835 
836         require(
837             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
838             "ERC721: approve caller is not owner nor approved for all"
839         );
840 
841         _approve(to, tokenId);
842     }
843 
844     /**
845      * @dev See {IERC721-getApproved}.
846      */
847     function getApproved(uint256 tokenId) public view virtual override returns (address) {
848         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
849 
850         return _tokenApprovals[tokenId];
851     }
852 
853     /**
854      * @dev See {IERC721-setApprovalForAll}.
855      */
856     function setApprovalForAll(address operator, bool approved) public virtual override {
857         require(operator != _msgSender(), "ERC721: approve to caller");
858 
859         _operatorApprovals[_msgSender()][operator] = approved;
860         emit ApprovalForAll(_msgSender(), operator, approved);
861     }
862 
863     /**
864      * @dev See {IERC721-isApprovedForAll}.
865      */
866     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
867         return _operatorApprovals[owner][operator];
868     }
869 
870     /**
871      * @dev See {IERC721-transferFrom}.
872      */
873     function transferFrom(
874         address from,
875         address to,
876         uint256 tokenId
877     ) public virtual override {
878         //solhint-disable-next-line max-line-length
879         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
880 
881         _transfer(from, to, tokenId);
882     }
883 
884     /**
885      * @dev See {IERC721-safeTransferFrom}.
886      */
887     function safeTransferFrom(
888         address from,
889         address to,
890         uint256 tokenId
891     ) public virtual override {
892         safeTransferFrom(from, to, tokenId, "");
893     }
894 
895     /**
896      * @dev See {IERC721-safeTransferFrom}.
897      */
898     function safeTransferFrom(
899         address from,
900         address to,
901         uint256 tokenId,
902         bytes memory _data
903     ) public virtual override {
904         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
905         _safeTransfer(from, to, tokenId, _data);
906     }
907 
908     /**
909      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
910      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
911      *
912      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
913      *
914      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
915      * implement alternative mechanisms to perform token transfer, such as signature-based.
916      *
917      * Requirements:
918      *
919      * - `from` cannot be the zero address.
920      * - `to` cannot be the zero address.
921      * - `tokenId` token must exist and be owned by `from`.
922      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
923      *
924      * Emits a {Transfer} event.
925      */
926     function _safeTransfer(
927         address from,
928         address to,
929         uint256 tokenId,
930         bytes memory _data
931     ) internal virtual {
932         _transfer(from, to, tokenId);
933         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
934     }
935 
936     /**
937      * @dev Returns whether `tokenId` exists.
938      *
939      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
940      *
941      * Tokens start existing when they are minted (`_mint`),
942      * and stop existing when they are burned (`_burn`).
943      */
944     function _exists(uint256 tokenId) internal view virtual returns (bool) {
945         return _owners[tokenId] != address(0);
946     }
947 
948     /**
949      * @dev Returns whether `spender` is allowed to manage `tokenId`.
950      *
951      * Requirements:
952      *
953      * - `tokenId` must exist.
954      */
955     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
956         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
957         address owner = ERC721.ownerOf(tokenId);
958         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
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
982         bytes memory _data
983     ) internal virtual {
984         _mint(to, tokenId);
985         require(
986             _checkOnERC721Received(address(0), to, tokenId, _data),
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
1013     }
1014 
1015     /**
1016      * @dev Destroys `tokenId`.
1017      * The approval is cleared when the token is burned.
1018      *
1019      * Requirements:
1020      *
1021      * - `tokenId` must exist.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _burn(uint256 tokenId) internal virtual {
1026         address owner = ERC721.ownerOf(tokenId);
1027 
1028         _beforeTokenTransfer(owner, address(0), tokenId);
1029 
1030         // Clear approvals
1031         _approve(address(0), tokenId);
1032 
1033         _balances[owner] -= 1;
1034         delete _owners[tokenId];
1035 
1036         emit Transfer(owner, address(0), tokenId);
1037     }
1038 
1039     /**
1040      * @dev Transfers `tokenId` from `from` to `to`.
1041      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1042      *
1043      * Requirements:
1044      *
1045      * - `to` cannot be the zero address.
1046      * - `tokenId` token must be owned by `from`.
1047      *
1048      * Emits a {Transfer} event.
1049      */
1050     function _transfer(
1051         address from,
1052         address to,
1053         uint256 tokenId
1054     ) internal virtual {
1055         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1056         require(to != address(0), "ERC721: transfer to the zero address");
1057 
1058         _beforeTokenTransfer(from, to, tokenId);
1059 
1060         // Clear approvals from the previous owner
1061         _approve(address(0), tokenId);
1062 
1063         _balances[from] -= 1;
1064         _balances[to] += 1;
1065         _owners[tokenId] = to;
1066 
1067         emit Transfer(from, to, tokenId);
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
1134 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1135 
1136 
1137 
1138 pragma solidity ^0.8.0;
1139 
1140 
1141 
1142 /**
1143  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1144  * enumerability of all the token ids in the contract as well as all token ids owned by each
1145  * account.
1146  */
1147 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1148     // Mapping from owner to list of owned token IDs
1149     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1150 
1151     // Mapping from token ID to index of the owner tokens list
1152     mapping(uint256 => uint256) private _ownedTokensIndex;
1153 
1154     // Array with all token ids, used for enumeration
1155     uint256[] private _allTokens;
1156 
1157     // Mapping from token id to position in the allTokens array
1158     mapping(uint256 => uint256) private _allTokensIndex;
1159 
1160     /**
1161      * @dev See {IERC165-supportsInterface}.
1162      */
1163     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1164         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1165     }
1166 
1167     /**
1168      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1169      */
1170     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1171         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1172         return _ownedTokens[owner][index];
1173     }
1174 
1175     /**
1176      * @dev See {IERC721Enumerable-totalSupply}.
1177      */
1178     function totalSupply() public view virtual override returns (uint256) {
1179         return _allTokens.length;
1180     }
1181 
1182     /**
1183      * @dev See {IERC721Enumerable-tokenByIndex}.
1184      */
1185     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1186         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1187         return _allTokens[index];
1188     }
1189 
1190     /**
1191      * @dev Hook that is called before any token transfer. This includes minting
1192      * and burning.
1193      *
1194      * Calling conditions:
1195      *
1196      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1197      * transferred to `to`.
1198      * - When `from` is zero, `tokenId` will be minted for `to`.
1199      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1200      * - `from` cannot be the zero address.
1201      * - `to` cannot be the zero address.
1202      *
1203      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1204      */
1205     function _beforeTokenTransfer(
1206         address from,
1207         address to,
1208         uint256 tokenId
1209     ) internal virtual override {
1210         super._beforeTokenTransfer(from, to, tokenId);
1211 
1212         if (from == address(0)) {
1213             _addTokenToAllTokensEnumeration(tokenId);
1214         } else if (from != to) {
1215             _removeTokenFromOwnerEnumeration(from, tokenId);
1216         }
1217         if (to == address(0)) {
1218             _removeTokenFromAllTokensEnumeration(tokenId);
1219         } else if (to != from) {
1220             _addTokenToOwnerEnumeration(to, tokenId);
1221         }
1222     }
1223 
1224     /**
1225      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1226      * @param to address representing the new owner of the given token ID
1227      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1228      */
1229     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1230         uint256 length = ERC721.balanceOf(to);
1231         _ownedTokens[to][length] = tokenId;
1232         _ownedTokensIndex[tokenId] = length;
1233     }
1234 
1235     /**
1236      * @dev Private function to add a token to this extension's token tracking data structures.
1237      * @param tokenId uint256 ID of the token to be added to the tokens list
1238      */
1239     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1240         _allTokensIndex[tokenId] = _allTokens.length;
1241         _allTokens.push(tokenId);
1242     }
1243 
1244     /**
1245      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1246      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1247      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1248      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1249      * @param from address representing the previous owner of the given token ID
1250      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1251      */
1252     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1253         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1254         // then delete the last slot (swap and pop).
1255 
1256         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1257         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1258 
1259         // When the token to delete is the last token, the swap operation is unnecessary
1260         if (tokenIndex != lastTokenIndex) {
1261             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1262 
1263             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1264             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1265         }
1266 
1267         // This also deletes the contents at the last position of the array
1268         delete _ownedTokensIndex[tokenId];
1269         delete _ownedTokens[from][lastTokenIndex];
1270     }
1271 
1272     /**
1273      * @dev Private function to remove a token from this extension's token tracking data structures.
1274      * This has O(1) time complexity, but alters the order of the _allTokens array.
1275      * @param tokenId uint256 ID of the token to be removed from the tokens list
1276      */
1277     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1278         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1279         // then delete the last slot (swap and pop).
1280 
1281         uint256 lastTokenIndex = _allTokens.length - 1;
1282         uint256 tokenIndex = _allTokensIndex[tokenId];
1283 
1284         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1285         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1286         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1287         uint256 lastTokenId = _allTokens[lastTokenIndex];
1288 
1289         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1290         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1291 
1292         // This also deletes the contents at the last position of the array
1293         delete _allTokensIndex[tokenId];
1294         _allTokens.pop();
1295     }
1296 }
1297 
1298 // File: NiftyApeNation.sol
1299 
1300 
1301 //  __    __  __   ______    __                       ______                      
1302 // /  \  /  |/  | /      \  /  |                     /      \                     
1303 // $$  \ $$ |$$/ /$$$$$$  |_$$ |_    __    __       /$$$$$$  |  ______    ______  
1304 // $$$  \$$ |/  |$$ |_ $$// $$   |  /  |  /  |      $$ |__$$ | /      \  /      \ 
1305 // $$$$  $$ |$$ |$$   |   $$$$$$/   $$ |  $$ |      $$    $$ |/$$$$$$  |/$$$$$$  |
1306 // $$ $$ $$ |$$ |$$$$/      $$ | __ $$ |  $$ |      $$$$$$$$ |$$ |  $$ |$$    $$ |
1307 // $$ |$$$$ |$$ |$$ |       $$ |/  |$$ \__$$ |      $$ |  $$ |$$ |__$$ |$$$$$$$$/ 
1308 // $$ | $$$ |$$ |$$ |       $$  $$/ $$    $$ |      $$ |  $$ |$$    $$/ $$       |
1309 // $$/   $$/ $$/ $$/         $$$$/   $$$$$$$ |      $$/   $$/ $$$$$$$/   $$$$$$$/ 
1310 //                                  /  \__$$ |                $$ |                
1311 //                                  $$    $$/                 $$ |                
1312 //                                   $$$$$$/                  $$/                 
1313 //  __    __              __      __                                              
1314 // /  \  /  |            /  |    /  |                                             
1315 // $$  \ $$ |  ______   _$$ |_   $$/   ______   _______                           
1316 // $$$  \$$ | /      \ / $$   |  /  | /      \ /       \                          
1317 // $$$$  $$ | $$$$$$  |$$$$$$/   $$ |/$$$$$$  |$$$$$$$  |                         
1318 // $$ $$ $$ | /    $$ |  $$ | __ $$ |$$ |  $$ |$$ |  $$ |                         
1319 // $$ |$$$$ |/$$$$$$$ |  $$ |/  |$$ |$$ \__$$ |$$ |  $$ |                         
1320 // $$ | $$$ |$$    $$ |  $$  $$/ $$ |$$    $$/ $$ |  $$ |                         
1321 // $$/   $$/  $$$$$$$/    $$$$/  $$/  $$$$$$/  $$/   $$/                          
1322 //
1323 
1324 pragma solidity 0.8.9;
1325 
1326 
1327 
1328 
1329 
1330 contract NiftyApeNation is ERC721Enumerable, Ownable {
1331     using Strings for uint256;
1332     using Counters for Counters.Counter;    
1333 
1334     Counters.Counter private _publicMintCounter;
1335     Counters.Counter private _privateMintCounter;
1336     
1337     uint8 public constant PUBLIC_MINT = 1;
1338     uint8 public constant PRIVATE_MINT = 2;
1339     
1340     string public baseURI;
1341     string public _contractURI;
1342     string public baseExtension = '.json';
1343     uint256 public maxSupply = 8888;
1344     uint256 public maxPublicSupply = 7904;//maximum allowed for public mint
1345     uint256 public privateMintCounterStart = 7904;//token Ids 7905-8888 is reserved for auctions
1346     uint256 public publicSaleDropSize = 888;//public sale drop batch size
1347     uint256 public publicSaleDropPhase = 1;//there will be 9 drops. 
1348     uint256 public maxMintAmount = 3;
1349     uint256 public pricePerPublicToken = 0.0888 ether;    
1350 
1351     bool public paused = true;
1352     bool public whitelistAllowed = false; 
1353     
1354     mapping(address => uint8) private _whitelist;
1355     
1356     //withdraw addresses 
1357     address actWallet = 0x4043806F2d2bd98DcdfAB0a4477528EbE1c4c0c8;
1358     address aiWallet  = 0x54BfF4ED1b1D677c3A3b738516DFbe7A8EaC1e8A;
1359     address devWallet  = 0xdD2f3cfC6310F0365E83Dd964D38a06e10Cca69E;
1360     address afWallet = 0x33FB4D418943C6AAF85f808EdC901fEcF1Cb51F8;
1361 
1362     constructor(string memory _initBaseURI, string memory _initContractURI) ERC721("Nifty Ape Nation", "NAN") {
1363         setBaseURI(_initBaseURI);
1364         setContractURI(_initContractURI);
1365     }
1366 
1367     //modifiers
1368     modifier publicMintCheck(uint8 numberOfTokens) {
1369         require(!paused, "Sales is not active");
1370         require(getCurrentCounterValue(PUBLIC_MINT) + numberOfTokens <= maxPublicSupply, "Purchase would exceed max public tokens!");
1371         require(getCurrentCounterValue(PUBLIC_MINT) + numberOfTokens <= publicSaleDropPhase * publicSaleDropSize, "Purchase would exceed this Drop's max amount!");
1372         require(numberOfTokens > 0 && numberOfTokens <= maxMintAmount, "Invalid amount or maximum token mint amount reached!");        
1373         
1374         require(pricePerPublicToken * numberOfTokens <= msg.value, "Ether value sent is not correct!");
1375         _;
1376     }
1377     
1378     modifier whitelistCheck(uint8 numberOfTokens){
1379         if(whitelistAllowed){
1380             require(_whitelist[msg.sender] > 0, "Address is not whitelisted or not enough quota!");
1381             require(numberOfTokens <= _whitelist[msg.sender], "Exceeded max available to purchase");
1382         }
1383         _;
1384     }
1385 
1386     modifier privateMintCheck(uint8 numberOfTokens) {
1387         require(!paused, "Contract is not active!");
1388         require(numberOfTokens > 0, "Invalid token amount!");
1389         require(totalSupply() <= maxSupply, "Max supply reached!");
1390         require(getCurrentCounterValue(PRIVATE_MINT) + numberOfTokens <= maxSupply, "Purchase would exceed max tokens!");     
1391         _;
1392     }
1393     
1394     
1395     //we override the _baseURI() method of ERC721 to return our own baseURI
1396     function _baseURI() internal view virtual override returns (string memory) {
1397         return baseURI;
1398     }
1399     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1400         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1401         string memory currentBaseURI = _baseURI();
1402         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
1403     }
1404     function setContractURI(string memory newuri) public onlyOwner {		
1405 		_contractURI = newuri;
1406 	}
1407 
1408 	function contractURI() public view returns (string memory) {
1409 		return _contractURI;
1410 	}
1411 
1412     //public
1413     //Public minting
1414     function mintPublic(uint8 numberOfTokens) public payable whitelistCheck(numberOfTokens) publicMintCheck(numberOfTokens) {
1415         //whitelist checks
1416         if(whitelistAllowed){
1417             _whitelist[msg.sender] -= numberOfTokens;       
1418         }
1419 
1420         for (uint256 i = 0; i < numberOfTokens; i++) {
1421             incrementCurrentCounterValue(PUBLIC_MINT);
1422             _safeMint(msg.sender, getCurrentCounterValue(PUBLIC_MINT));
1423         }
1424     }
1425 
1426     //Token Ids from 7905-8888 is reserved for auctions)
1427     function mintPrivate(uint8 numberOfTokens) public onlyOwner privateMintCheck(numberOfTokens)  {
1428         for (uint256 i = 0; i < numberOfTokens; i++) {
1429             incrementCurrentCounterValue(PRIVATE_MINT);
1430             _safeMint(msg.sender, getCurrentCounterValue(PRIVATE_MINT));
1431         }
1432     }
1433    
1434     //change states
1435     //set BaseURI
1436     function setBaseURI(string memory uri) public onlyOwner {
1437         baseURI = uri;
1438     }
1439 
1440     //set public sale drop size (888)
1441     function setPublicSaleDropSize(uint256 newDropSize) public onlyOwner {
1442         publicSaleDropSize = newDropSize;
1443     }
1444     
1445     //set public sale drop phase (1-9)
1446     function setPublicSaleDropPhase(uint256 newDropPhase) public onlyOwner {
1447         require(newDropPhase >= 1 && newDropPhase <= 9, "Drop phase cannot exceed 9.");
1448         publicSaleDropPhase = newDropPhase;
1449     }
1450 
1451     //set max mint amount
1452     function setMaxMintAmount(uint256 newMintAmount) public onlyOwner {
1453         maxMintAmount = newMintAmount;
1454     }
1455 
1456     //set public token price
1457     function setPricePerPublicToken(uint256 newPrice) public onlyOwner {
1458         pricePerPublicToken = newPrice;
1459     }
1460 
1461     //set pause
1462     function setPaused(bool newState) public onlyOwner {
1463         paused = newState;
1464     }
1465 
1466      //set whitelist allowed
1467     function setWhitelistAllowed(bool newState) public onlyOwner {
1468         whitelistAllowed = newState;
1469     }
1470 
1471     //Set whitelist addresses
1472     function setWhitelist(address[] calldata addresses, uint8 allowedMintAmount) public onlyOwner {
1473         for (uint256 i = 0; i < addresses.length; i++) {
1474             _whitelist[addresses[i]] = allowedMintAmount;
1475         }
1476     }
1477     
1478     //get curernt token counter value (mintType: PUBLIC_MINT/PRIVATE_MINT)
1479     function getCurrentCounterValue(uint8 mintType) public view returns (uint256){
1480         if(mintType == PUBLIC_MINT){
1481             return _publicMintCounter.current();
1482         }else if(mintType == PRIVATE_MINT){
1483             return _privateMintCounter.current() + privateMintCounterStart;//private mint counter starts from 7905 (reserved items)
1484         }else{
1485             return 0;
1486         }
1487     }
1488     //increment token counter value (mintType: PUBLIC_MINT/PRIVATE_MINT)
1489     function incrementCurrentCounterValue(uint8 mintType) private {
1490         if(mintType == PUBLIC_MINT){
1491             require(getCurrentCounterValue(PUBLIC_MINT) < maxPublicSupply, "counter can not exceed the max public supply");
1492             return _publicMintCounter.increment();
1493         }else if(mintType == PRIVATE_MINT){
1494             require(getCurrentCounterValue(PRIVATE_MINT) < maxSupply, "counter can not exceed the max supply");
1495             return _privateMintCounter.increment();
1496         }else{
1497             return;
1498         }
1499     }
1500 
1501     //withdraw all money to specidic wallets
1502     function withdrawAll() public onlyOwner {
1503         uint256 balance = address(this).balance;
1504         require(balance > 0, "insufficient funds!");
1505         _widthdraw(actWallet, balance * 35 / 100);        
1506         _widthdraw(aiWallet, balance * 20 / 100);
1507         _widthdraw(devWallet, balance * 30 / 100);
1508         _widthdraw(afWallet, address(this).balance);
1509     }
1510     function _widthdraw(address _address, uint256 _amount) private {
1511         (bool success, ) = _address.call{value: _amount}("");
1512         require(success, "Transfer failed.");
1513     }
1514 }