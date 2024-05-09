1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
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
663 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
664 
665 
666 
667 pragma solidity ^0.8.0;
668 
669 
670 /**
671  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
672  * @dev See https://eips.ethereum.org/EIPS/eip-721
673  */
674 interface IERC721Metadata is IERC721 {
675     /**
676      * @dev Returns the token collection name.
677      */
678     function name() external view returns (string memory);
679 
680     /**
681      * @dev Returns the token collection symbol.
682      */
683     function symbol() external view returns (string memory);
684 
685     /**
686      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
687      */
688     function tokenURI(uint256 tokenId) external view returns (string memory);
689 }
690 
691 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
692 
693 
694 
695 pragma solidity ^0.8.0;
696 
697 
698 
699 
700 
701 
702 
703 
704 /**
705  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
706  * the Metadata extension, but not including the Enumerable extension, which is available separately as
707  * {ERC721Enumerable}.
708  */
709 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
710     using Address for address;
711     using Strings for uint256;
712 
713     // Token name
714     string private _name;
715 
716     // Token symbol
717     string private _symbol;
718 
719     // Mapping from token ID to owner address
720     mapping(uint256 => address) private _owners;
721 
722     // Mapping owner address to token count
723     mapping(address => uint256) private _balances;
724 
725     // Mapping from token ID to approved address
726     mapping(uint256 => address) private _tokenApprovals;
727 
728     // Mapping from owner to operator approvals
729     mapping(address => mapping(address => bool)) private _operatorApprovals;
730 
731     /**
732      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
733      */
734     constructor(string memory name_, string memory symbol_) {
735         _name = name_;
736         _symbol = symbol_;
737     }
738 
739     /**
740      * @dev See {IERC165-supportsInterface}.
741      */
742     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
743         return
744             interfaceId == type(IERC721).interfaceId ||
745             interfaceId == type(IERC721Metadata).interfaceId ||
746             super.supportsInterface(interfaceId);
747     }
748 
749     /**
750      * @dev See {IERC721-balanceOf}.
751      */
752     function balanceOf(address owner) public view virtual override returns (uint256) {
753         require(owner != address(0), "ERC721: balance query for the zero address");
754         return _balances[owner];
755     }
756 
757     /**
758      * @dev See {IERC721-ownerOf}.
759      */
760     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
761         address owner = _owners[tokenId];
762         require(owner != address(0), "ERC721: owner query for nonexistent token");
763         return owner;
764     }
765 
766     /**
767      * @dev See {IERC721Metadata-name}.
768      */
769     function name() public view virtual override returns (string memory) {
770         return _name;
771     }
772 
773     /**
774      * @dev See {IERC721Metadata-symbol}.
775      */
776     function symbol() public view virtual override returns (string memory) {
777         return _symbol;
778     }
779 
780     /**
781      * @dev See {IERC721Metadata-tokenURI}.
782      */
783     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
784         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
785 
786         string memory baseURI = _baseURI();
787         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
788     }
789 
790     /**
791      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
792      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
793      * by default, can be overriden in child contracts.
794      */
795     function _baseURI() internal view virtual returns (string memory) {
796         return "";
797     }
798 
799     /**
800      * @dev See {IERC721-approve}.
801      */
802     function approve(address to, uint256 tokenId) public virtual override {
803         address owner = ERC721.ownerOf(tokenId);
804         require(to != owner, "ERC721: approval to current owner");
805 
806         require(
807             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
808             "ERC721: approve caller is not owner nor approved for all"
809         );
810 
811         _approve(to, tokenId);
812     }
813 
814     /**
815      * @dev See {IERC721-getApproved}.
816      */
817     function getApproved(uint256 tokenId) public view virtual override returns (address) {
818         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
819 
820         return _tokenApprovals[tokenId];
821     }
822 
823     /**
824      * @dev See {IERC721-setApprovalForAll}.
825      */
826     function setApprovalForAll(address operator, bool approved) public virtual override {
827         require(operator != _msgSender(), "ERC721: approve to caller");
828 
829         _operatorApprovals[_msgSender()][operator] = approved;
830         emit ApprovalForAll(_msgSender(), operator, approved);
831     }
832 
833     /**
834      * @dev See {IERC721-isApprovedForAll}.
835      */
836     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
837         return _operatorApprovals[owner][operator];
838     }
839 
840     /**
841      * @dev See {IERC721-transferFrom}.
842      */
843     function transferFrom(
844         address from,
845         address to,
846         uint256 tokenId
847     ) public virtual override {
848         //solhint-disable-next-line max-line-length
849         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
850 
851         _transfer(from, to, tokenId);
852     }
853 
854     /**
855      * @dev See {IERC721-safeTransferFrom}.
856      */
857     function safeTransferFrom(
858         address from,
859         address to,
860         uint256 tokenId
861     ) public virtual override {
862         safeTransferFrom(from, to, tokenId, "");
863     }
864 
865     /**
866      * @dev See {IERC721-safeTransferFrom}.
867      */
868     function safeTransferFrom(
869         address from,
870         address to,
871         uint256 tokenId,
872         bytes memory _data
873     ) public virtual override {
874         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
875         _safeTransfer(from, to, tokenId, _data);
876     }
877 
878     /**
879      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
880      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
881      *
882      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
883      *
884      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
885      * implement alternative mechanisms to perform token transfer, such as signature-based.
886      *
887      * Requirements:
888      *
889      * - `from` cannot be the zero address.
890      * - `to` cannot be the zero address.
891      * - `tokenId` token must exist and be owned by `from`.
892      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
893      *
894      * Emits a {Transfer} event.
895      */
896     function _safeTransfer(
897         address from,
898         address to,
899         uint256 tokenId,
900         bytes memory _data
901     ) internal virtual {
902         _transfer(from, to, tokenId);
903         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
904     }
905 
906     /**
907      * @dev Returns whether `tokenId` exists.
908      *
909      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
910      *
911      * Tokens start existing when they are minted (`_mint`),
912      * and stop existing when they are burned (`_burn`).
913      */
914     function _exists(uint256 tokenId) internal view virtual returns (bool) {
915         return _owners[tokenId] != address(0);
916     }
917 
918     /**
919      * @dev Returns whether `spender` is allowed to manage `tokenId`.
920      *
921      * Requirements:
922      *
923      * - `tokenId` must exist.
924      */
925     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
926         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
927         address owner = ERC721.ownerOf(tokenId);
928         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
929     }
930 
931     /**
932      * @dev Safely mints `tokenId` and transfers it to `to`.
933      *
934      * Requirements:
935      *
936      * - `tokenId` must not exist.
937      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
938      *
939      * Emits a {Transfer} event.
940      */
941     function _safeMint(address to, uint256 tokenId) internal virtual {
942         _safeMint(to, tokenId, "");
943     }
944 
945     /**
946      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
947      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
948      */
949     function _safeMint(
950         address to,
951         uint256 tokenId,
952         bytes memory _data
953     ) internal virtual {
954         _mint(to, tokenId);
955         require(
956             _checkOnERC721Received(address(0), to, tokenId, _data),
957             "ERC721: transfer to non ERC721Receiver implementer"
958         );
959     }
960 
961     /**
962      * @dev Mints `tokenId` and transfers it to `to`.
963      *
964      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
965      *
966      * Requirements:
967      *
968      * - `tokenId` must not exist.
969      * - `to` cannot be the zero address.
970      *
971      * Emits a {Transfer} event.
972      */
973     function _mint(address to, uint256 tokenId) internal virtual {
974         require(to != address(0), "ERC721: mint to the zero address");
975         require(!_exists(tokenId), "ERC721: token already minted");
976 
977         _beforeTokenTransfer(address(0), to, tokenId);
978 
979         _balances[to] += 1;
980         _owners[tokenId] = to;
981 
982         emit Transfer(address(0), to, tokenId);
983     }
984 
985     /**
986      * @dev Destroys `tokenId`.
987      * The approval is cleared when the token is burned.
988      *
989      * Requirements:
990      *
991      * - `tokenId` must exist.
992      *
993      * Emits a {Transfer} event.
994      */
995     function _burn(uint256 tokenId) internal virtual {
996         address owner = ERC721.ownerOf(tokenId);
997 
998         _beforeTokenTransfer(owner, address(0), tokenId);
999 
1000         // Clear approvals
1001         _approve(address(0), tokenId);
1002 
1003         _balances[owner] -= 1;
1004         delete _owners[tokenId];
1005 
1006         emit Transfer(owner, address(0), tokenId);
1007     }
1008 
1009     /**
1010      * @dev Transfers `tokenId` from `from` to `to`.
1011      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1012      *
1013      * Requirements:
1014      *
1015      * - `to` cannot be the zero address.
1016      * - `tokenId` token must be owned by `from`.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function _transfer(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) internal virtual {
1025         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1026         require(to != address(0), "ERC721: transfer to the zero address");
1027 
1028         _beforeTokenTransfer(from, to, tokenId);
1029 
1030         // Clear approvals from the previous owner
1031         _approve(address(0), tokenId);
1032 
1033         _balances[from] -= 1;
1034         _balances[to] += 1;
1035         _owners[tokenId] = to;
1036 
1037         emit Transfer(from, to, tokenId);
1038     }
1039 
1040     /**
1041      * @dev Approve `to` to operate on `tokenId`
1042      *
1043      * Emits a {Approval} event.
1044      */
1045     function _approve(address to, uint256 tokenId) internal virtual {
1046         _tokenApprovals[tokenId] = to;
1047         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1052      * The call is not executed if the target address is not a contract.
1053      *
1054      * @param from address representing the previous owner of the given token ID
1055      * @param to target address that will receive the tokens
1056      * @param tokenId uint256 ID of the token to be transferred
1057      * @param _data bytes optional data to send along with the call
1058      * @return bool whether the call correctly returned the expected magic value
1059      */
1060     function _checkOnERC721Received(
1061         address from,
1062         address to,
1063         uint256 tokenId,
1064         bytes memory _data
1065     ) private returns (bool) {
1066         if (to.isContract()) {
1067             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1068                 return retval == IERC721Receiver.onERC721Received.selector;
1069             } catch (bytes memory reason) {
1070                 if (reason.length == 0) {
1071                     revert("ERC721: transfer to non ERC721Receiver implementer");
1072                 } else {
1073                     assembly {
1074                         revert(add(32, reason), mload(reason))
1075                     }
1076                 }
1077             }
1078         } else {
1079             return true;
1080         }
1081     }
1082 
1083     /**
1084      * @dev Hook that is called before any token transfer. This includes minting
1085      * and burning.
1086      *
1087      * Calling conditions:
1088      *
1089      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1090      * transferred to `to`.
1091      * - When `from` is zero, `tokenId` will be minted for `to`.
1092      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1093      * - `from` and `to` are never both zero.
1094      *
1095      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1096      */
1097     function _beforeTokenTransfer(
1098         address from,
1099         address to,
1100         uint256 tokenId
1101     ) internal virtual {}
1102 }
1103 
1104 // File: contracts/CryptoCraftNFT.sol
1105 
1106 
1107 pragma solidity ^0.8.2;
1108 
1109 
1110 
1111 
1112 contract CryptoCraftNFT is ERC721, Ownable {
1113     // Private 
1114     string private baseURI;
1115     using Counters for Counters.Counter;
1116     Counters.Counter private _tokenIdCounter;
1117     
1118     // Sale status
1119     bool public whitelistMintIsActive = false;
1120     bool public publicMintIsActive = false;
1121     
1122     // Constants 
1123     // To maximize gas savings, max_supply is offset by 1. 
1124     uint256 public constant MAX_SUPPLY = 4001;
1125     uint256 public constant MAX_PER_TXN = 5;
1126     uint256 public constant TOKEN_PRICE = 0.05 ether;
1127     
1128     // Maps address to number of remaining whitelist mints
1129     mapping(address => uint8) private whitelist;
1130     
1131     // Reserved for team, giveaways, and promotions
1132     uint256 public reserveSupply = 25; 
1133 
1134     constructor() ERC721("CryptoCraft", "CRAFT") {
1135         _tokenIdCounter.increment();
1136     }
1137     
1138     function publicMint(uint256 _amount) external payable {        
1139         require(publicMintIsActive, "CC: Public Mint is not active");
1140         require(_tokenIdCounter.current() + _amount + reserveSupply <= MAX_SUPPLY, "CC: Max token supply exceeded");
1141         require(TOKEN_PRICE * _amount <= msg.value, "CC: Ether value sent is not correct");
1142         require(_amount <= MAX_PER_TXN, "CC: Exceeded max mint per txn");
1143         
1144         for (uint256 i = 0; i < _amount; i++) {
1145             _tokenIdCounter.increment();
1146             _safeMint(msg.sender, _tokenIdCounter.current());
1147         }
1148     }
1149     
1150     function whitelistMint(uint8 _amount) external payable {
1151         require(whitelistMintIsActive,  "CC: Whitelist Mint is not active");
1152         require(_amount <= whitelist[msg.sender], "CC: You don't have enough whitelist mints remaining");
1153         require(_tokenIdCounter.current() + _amount + reserveSupply <= MAX_SUPPLY, "CC: Max token supply exceeded");
1154         require(TOKEN_PRICE * _amount <= msg.value, "CC: Ether value sent is not correct");
1155         
1156         whitelist[msg.sender] -= _amount; 
1157         for (uint256 i = 0; i < _amount; i++) {
1158             _tokenIdCounter.increment();
1159             _safeMint(msg.sender, _tokenIdCounter.current());
1160         }
1161     }
1162     
1163     function numAvailableToMint(address addr) external view returns (uint8) {
1164         return whitelist[addr];
1165     }
1166     
1167     function _baseURI() internal view override returns (string memory) {
1168         return baseURI;
1169     }
1170     
1171     
1172     // onlyOwner 
1173     function setWhitelist(address[] calldata addresses, uint8 numAllowedToMint) external onlyOwner {
1174         for (uint256 i = 0; i < addresses.length; i++) {
1175             whitelist[addresses[i]] = numAllowedToMint;
1176         }
1177     }
1178     
1179     function reserve(uint256 n, address mintReceiver) public onlyOwner {
1180       require(_tokenIdCounter.current() + n + reserveSupply <= MAX_SUPPLY, "CC: Max token supply exceeded");
1181       require(n <= reserveSupply, "CC: Reserve supply exceeded");
1182       
1183       reserveSupply -= n; 
1184       for (uint256 i = 0; i < n; i++) {
1185             uint256 tokenId = _tokenIdCounter.current();
1186             _tokenIdCounter.increment();
1187             _safeMint(mintReceiver, tokenId);
1188       }
1189     }
1190     
1191     function setBaseURI(string calldata _tokenBaseURI) external onlyOwner {
1192         baseURI = _tokenBaseURI;
1193     }
1194     
1195     function setWhitelistMintIsActive(bool _whitelistMintIsActive) external onlyOwner {
1196         whitelistMintIsActive = _whitelistMintIsActive;
1197     }
1198     
1199     function setPublicMintIsActive(bool _publicMintIsActive) external onlyOwner {
1200         publicMintIsActive = _publicMintIsActive;
1201     }
1202     
1203     function withdraw() public onlyOwner {
1204         uint balance = address(this).balance;
1205         payable(msg.sender).transfer(balance);
1206     }
1207 }