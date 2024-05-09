1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 pragma solidity ^0.8.0;
5 /**
6  * @title Counters
7  * @author Matt Condon (@shrugs)
8  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
9  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
10  *
11  * Include with `using Counters for Counters.Counter;`
12  */
13 library Counters {
14     struct Counter {
15         // This variable should never be directly accessed by users of the library: interactions must be restricted to
16         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
17         // this feature: see https://github.com/ethereum/solidity/issues/4637
18         uint256 _value; // default: 0
19     }
20 
21     function current(Counter storage counter) internal view returns (uint256) {
22         return counter._value;
23     }
24 
25     function increment(Counter storage counter) internal {
26         unchecked {
27             counter._value += 1;
28         }
29     }
30 
31     function decrement(Counter storage counter) internal {
32         uint256 value = counter._value;
33         require(value > 0, "Counter: decrement overflow");
34         unchecked {
35             counter._value = value - 1;
36         }
37     }
38 
39     function reset(Counter storage counter) internal {
40         counter._value = 0;
41     }
42 }
43 
44 
45 // File: @openzeppelin/contracts/utils/Strings.sol
46 pragma solidity ^0.8.0;
47 /**
48  * @dev String operations.
49  */
50 library Strings {
51     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
55      */
56     function toString(uint256 value) internal pure returns (string memory) {
57         // Inspired by OraclizeAPI's implementation - MIT licence
58         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
59 
60         if (value == 0) {
61             return "0";
62         }
63         uint256 temp = value;
64         uint256 digits;
65         while (temp != 0) {
66             digits++;
67             temp /= 10;
68         }
69         bytes memory buffer = new bytes(digits);
70         while (value != 0) {
71             digits -= 1;
72             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
73             value /= 10;
74         }
75         return string(buffer);
76     }
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
80      */
81     function toHexString(uint256 value) internal pure returns (string memory) {
82         if (value == 0) {
83             return "0x00";
84         }
85         uint256 temp = value;
86         uint256 length = 0;
87         while (temp != 0) {
88             length++;
89             temp >>= 8;
90         }
91         return toHexString(value, length);
92     }
93 
94     /**
95      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
96      */
97     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
98         bytes memory buffer = new bytes(2 * length + 2);
99         buffer[0] = "0";
100         buffer[1] = "x";
101         for (uint256 i = 2 * length + 1; i > 1; --i) {
102             buffer[i] = _HEX_SYMBOLS[value & 0xf];
103             value >>= 4;
104         }
105         require(value == 0, "Strings: hex length insufficient");
106         return string(buffer);
107     }
108 }
109 
110 
111 // File: @openzeppelin/contracts/utils/Context.sol
112 pragma solidity ^0.8.0;
113 /**
114  * @dev Provides information about the current execution context, including the
115  * sender of the transaction and its data. While these are generally available
116  * via msg.sender and msg.data, they should not be accessed in such a direct
117  * manner, since when dealing with meta-transactions the account sending and
118  * paying for execution may not be the actual sender (as far as an application
119  * is concerned).
120  *
121  * This contract is only required for intermediate, library-like contracts.
122  */
123 abstract contract Context {
124     function _msgSender() internal view virtual returns (address) {
125         return msg.sender;
126     }
127 
128     function _msgData() internal view virtual returns (bytes calldata) {
129         return msg.data;
130     }
131 }
132 
133 
134 // File: @openzeppelin/contracts/access/Ownable.sol
135 pragma solidity ^0.8.0;
136 /**
137  * @dev Contract module which provides a basic access control mechanism, where
138  * there is an account (an owner) that can be granted exclusive access to
139  * specific functions.
140  *
141  * By default, the owner account will be the one that deploys the contract. This
142  * can later be changed with {transferOwnership}.
143  *
144  * This module is used through inheritance. It will make available the modifier
145  * `onlyOwner`, which can be applied to your functions to restrict their use to
146  * the owner.
147  */
148 abstract contract Ownable is Context {
149     address private _owner;
150 
151     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
152 
153     /**
154      * @dev Initializes the contract setting the deployer as the initial owner.
155      */
156     constructor() {
157         _transferOwnership(_msgSender());
158     }
159 
160     /**
161      * @dev Returns the address of the current owner.
162      */
163     function owner() public view virtual returns (address) {
164         return _owner;
165     }
166 
167     /**
168      * @dev Throws if called by any account other than the owner.
169      */
170     modifier onlyOwner() {
171         require(owner() == _msgSender(), "Ownable: caller is not the owner");
172         _;
173     }
174 
175     /**
176      * @dev Leaves the contract without owner. It will not be possible to call
177      * `onlyOwner` functions anymore. Can only be called by the current owner.
178      *
179      * NOTE: Renouncing ownership will leave the contract without an owner,
180      * thereby removing any functionality that is only available to the owner.
181      */
182     function renounceOwnership() public virtual onlyOwner {
183         _transferOwnership(address(0));
184     }
185 
186     /**
187      * @dev Transfers ownership of the contract to a new account (`newOwner`).
188      * Can only be called by the current owner.
189      */
190     function transferOwnership(address newOwner) public virtual onlyOwner {
191         require(newOwner != address(0), "Ownable: new owner is the zero address");
192         _transferOwnership(newOwner);
193     }
194 
195     /**
196      * @dev Transfers ownership of the contract to a new account (`newOwner`).
197      * Internal function without access restriction.
198      */
199     function _transferOwnership(address newOwner) internal virtual {
200         address oldOwner = _owner;
201         _owner = newOwner;
202         emit OwnershipTransferred(oldOwner, newOwner);
203     }
204 }
205 
206 
207 // File: @openzeppelin/contracts/utils/Address.sol
208 pragma solidity ^0.8.0;
209 /**
210  * @dev Collection of functions related to the address type
211  */
212 library Address {
213     /**
214      * @dev Returns true if `account` is a contract.
215      *
216      * [IMPORTANT]
217      * ====
218      * It is unsafe to assume that an address for which this function returns
219      * false is an externally-owned account (EOA) and not a contract.
220      *
221      * Among others, `isContract` will return false for the following
222      * types of addresses:
223      *
224      *  - an externally-owned account
225      *  - a contract in construction
226      *  - an address where a contract will be created
227      *  - an address where a contract lived, but was destroyed
228      * ====
229      */
230     function isContract(address account) internal view returns (bool) {
231         // This method relies on extcodesize, which returns 0 for contracts in
232         // construction, since the code is only stored at the end of the
233         // constructor execution.
234 
235         uint256 size;
236         assembly {
237             size := extcodesize(account)
238         }
239         return size > 0;
240     }
241 
242     /**
243      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
244      * `recipient`, forwarding all available gas and reverting on errors.
245      *
246      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
247      * of certain opcodes, possibly making contracts go over the 2300 gas limit
248      * imposed by `transfer`, making them unable to receive funds via
249      * `transfer`. {sendValue} removes this limitation.
250      *
251      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
252      *
253      * IMPORTANT: because control is transferred to `recipient`, care must be
254      * taken to not create reentrancy vulnerabilities. Consider using
255      * {ReentrancyGuard} or the
256      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
257      */
258     function sendValue(address payable recipient, uint256 amount) internal {
259         require(address(this).balance >= amount, "Address: insufficient balance");
260 
261         (bool success, ) = recipient.call{value: amount}("");
262         require(success, "Address: unable to send value, recipient may have reverted");
263     }
264 
265     /**
266      * @dev Performs a Solidity function call using a low level `call`. A
267      * plain `call` is an unsafe replacement for a function call: use this
268      * function instead.
269      *
270      * If `target` reverts with a revert reason, it is bubbled up by this
271      * function (like regular Solidity function calls).
272      *
273      * Returns the raw returned data. To convert to the expected return value,
274      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
275      *
276      * Requirements:
277      *
278      * - `target` must be a contract.
279      * - calling `target` with `data` must not revert.
280      *
281      * _Available since v3.1._
282      */
283     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
284         return functionCall(target, data, "Address: low-level call failed");
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
289      * `errorMessage` as a fallback revert reason when `target` reverts.
290      *
291      * _Available since v3.1._
292      */
293     function functionCall(
294         address target,
295         bytes memory data,
296         string memory errorMessage
297     ) internal returns (bytes memory) {
298         return functionCallWithValue(target, data, 0, errorMessage);
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
303      * but also transferring `value` wei to `target`.
304      *
305      * Requirements:
306      *
307      * - the calling contract must have an ETH balance of at least `value`.
308      * - the called Solidity function must be `payable`.
309      *
310      * _Available since v3.1._
311      */
312     function functionCallWithValue(
313         address target,
314         bytes memory data,
315         uint256 value
316     ) internal returns (bytes memory) {
317         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
322      * with `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(
327         address target,
328         bytes memory data,
329         uint256 value,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         require(address(this).balance >= value, "Address: insufficient balance for call");
333         require(isContract(target), "Address: call to non-contract");
334 
335         (bool success, bytes memory returndata) = target.call{value: value}(data);
336         return verifyCallResult(success, returndata, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but performing a static call.
342      *
343      * _Available since v3.3._
344      */
345     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
346         return functionStaticCall(target, data, "Address: low-level static call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
351      * but performing a static call.
352      *
353      * _Available since v3.3._
354      */
355     function functionStaticCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal view returns (bytes memory) {
360         require(isContract(target), "Address: static call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.staticcall(data);
363         return verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but performing a delegate call.
369      *
370      * _Available since v3.4._
371      */
372     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
373         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
378      * but performing a delegate call.
379      *
380      * _Available since v3.4._
381      */
382     function functionDelegateCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal returns (bytes memory) {
387         require(isContract(target), "Address: delegate call to non-contract");
388 
389         (bool success, bytes memory returndata) = target.delegatecall(data);
390         return verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
395      * revert reason using the provided one.
396      *
397      * _Available since v4.3._
398      */
399     function verifyCallResult(
400         bool success,
401         bytes memory returndata,
402         string memory errorMessage
403     ) internal pure returns (bytes memory) {
404         if (success) {
405             return returndata;
406         } else {
407             // Look for revert reason and bubble it up if present
408             if (returndata.length > 0) {
409                 // The easiest way to bubble the revert reason is using memory via assembly
410 
411                 assembly {
412                     let returndata_size := mload(returndata)
413                     revert(add(32, returndata), returndata_size)
414                 }
415             } else {
416                 revert(errorMessage);
417             }
418         }
419     }
420 }
421 
422 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
423 pragma solidity ^0.8.0;
424 /**
425  * @title ERC721 token receiver interface
426  * @dev Interface for any contract that wants to support safeTransfers
427  * from ERC721 asset contracts.
428  */
429 interface IERC721Receiver {
430     /**
431      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
432      * by `operator` from `from`, this function is called.
433      *
434      * It must return its Solidity selector to confirm the token transfer.
435      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
436      *
437      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
438      */
439     function onERC721Received(
440         address operator,
441         address from,
442         uint256 tokenId,
443         bytes calldata data
444     ) external returns (bytes4);
445 }
446 
447 
448 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
449 pragma solidity ^0.8.0;
450 /**
451  * @dev Interface of the ERC165 standard, as defined in the
452  * https://eips.ethereum.org/EIPS/eip-165[EIP].
453  *
454  * Implementers can declare support of contract interfaces, which can then be
455  * queried by others ({ERC165Checker}).
456  *
457  * For an implementation, see {ERC165}.
458  */
459 interface IERC165 {
460     /**
461      * @dev Returns true if this contract implements the interface defined by
462      * `interfaceId`. See the corresponding
463      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
464      * to learn more about how these ids are created.
465      *
466      * This function call must use less than 30 000 gas.
467      */
468     function supportsInterface(bytes4 interfaceId) external view returns (bool);
469 }
470 
471 
472 // File: @openzeppelin/contracts/interfaces/IERC165.sol
473 pragma solidity ^0.8.0;
474 
475 
476 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
477 pragma solidity ^0.8.0;
478 /**
479  * @dev Interface for the NFT Royalty Standard
480  */
481 interface IERC2981 is IERC165 {
482     /**
483      * @dev Called with the sale price to determine how much royalty is owed and to whom.
484      * @param tokenId - the NFT asset queried for royalty information
485      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
486      * @return receiver - address of who should be sent the royalty payment
487      * @return royaltyAmount - the royalty payment amount for `salePrice`
488      */
489     function royaltyInfo(uint256 tokenId, uint256 salePrice)
490         external
491         view
492         returns (address receiver, uint256 royaltyAmount);
493 }
494 
495 
496 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
497 pragma solidity ^0.8.0;
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
521 
522 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
523 pragma solidity ^0.8.0;
524 /**
525  * @dev Required interface of an ERC721 compliant contract.
526  */
527 interface IERC721 is IERC165 {
528     /**
529      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
530      */
531     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
532 
533     /**
534      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
535      */
536     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
537 
538     /**
539      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
540      */
541     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
542 
543     /**
544      * @dev Returns the number of tokens in ``owner``'s account.
545      */
546     function balanceOf(address owner) external view returns (uint256 balance);
547 
548     /**
549      * @dev Returns the owner of the `tokenId` token.
550      *
551      * Requirements:
552      *
553      * - `tokenId` must exist.
554      */
555     function ownerOf(uint256 tokenId) external view returns (address owner);
556 
557     /**
558      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
559      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
560      *
561      * Requirements:
562      *
563      * - `from` cannot be the zero address.
564      * - `to` cannot be the zero address.
565      * - `tokenId` token must exist and be owned by `from`.
566      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
567      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
568      *
569      * Emits a {Transfer} event.
570      */
571     function safeTransferFrom(
572         address from,
573         address to,
574         uint256 tokenId
575     ) external;
576 
577     /**
578      * @dev Transfers `tokenId` token from `from` to `to`.
579      *
580      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
581      *
582      * Requirements:
583      *
584      * - `from` cannot be the zero address.
585      * - `to` cannot be the zero address.
586      * - `tokenId` token must be owned by `from`.
587      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
588      *
589      * Emits a {Transfer} event.
590      */
591     function transferFrom(
592         address from,
593         address to,
594         uint256 tokenId
595     ) external;
596 
597     /**
598      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
599      * The approval is cleared when the token is transferred.
600      *
601      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
602      *
603      * Requirements:
604      *
605      * - The caller must own the token or be an approved operator.
606      * - `tokenId` must exist.
607      *
608      * Emits an {Approval} event.
609      */
610     function approve(address to, uint256 tokenId) external;
611 
612     /**
613      * @dev Returns the account approved for `tokenId` token.
614      *
615      * Requirements:
616      *
617      * - `tokenId` must exist.
618      */
619     function getApproved(uint256 tokenId) external view returns (address operator);
620 
621     /**
622      * @dev Approve or remove `operator` as an operator for the caller.
623      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
624      *
625      * Requirements:
626      *
627      * - The `operator` cannot be the caller.
628      *
629      * Emits an {ApprovalForAll} event.
630      */
631     function setApprovalForAll(address operator, bool _approved) external;
632 
633     /**
634      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
635      *
636      * See {setApprovalForAll}
637      */
638     function isApprovedForAll(address owner, address operator) external view returns (bool);
639 
640     /**
641      * @dev Safely transfers `tokenId` token from `from` to `to`.
642      *
643      * Requirements:
644      *
645      * - `from` cannot be the zero address.
646      * - `to` cannot be the zero address.
647      * - `tokenId` token must exist and be owned by `from`.
648      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
649      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
650      *
651      * Emits a {Transfer} event.
652      */
653     function safeTransferFrom(
654         address from,
655         address to,
656         uint256 tokenId,
657         bytes calldata data
658     ) external;
659 }
660 
661 
662 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
663 pragma solidity ^0.8.0;
664 /**
665  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
666  * @dev See https://eips.ethereum.org/EIPS/eip-721
667  */
668 interface IERC721Metadata is IERC721 {
669     /**
670      * @dev Returns the token collection name.
671      */
672     function name() external view returns (string memory);
673 
674     /**
675      * @dev Returns the token collection symbol.
676      */
677     function symbol() external view returns (string memory);
678 
679     /**
680      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
681      */
682     function tokenURI(uint256 tokenId) external view returns (string memory);
683 }
684 
685 
686 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
687 pragma solidity ^0.8.0;
688 /**
689  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
690  * the Metadata extension, but not including the Enumerable extension, which is available separately as
691  * {ERC721Enumerable}.
692  */
693 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
694     using Address for address;
695     using Strings for uint256;
696 
697     // Token name
698     string private _name;
699 
700     // Token symbol
701     string private _symbol;
702 
703     // Mapping from token ID to owner address
704     mapping(uint256 => address) private _owners;
705 
706     // Mapping owner address to token count
707     mapping(address => uint256) private _balances;
708 
709     // Mapping from token ID to approved address
710     mapping(uint256 => address) private _tokenApprovals;
711 
712     // Mapping from owner to operator approvals
713     mapping(address => mapping(address => bool)) private _operatorApprovals;
714 
715     /**
716      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
717      */
718     constructor(string memory name_, string memory symbol_) {
719         _name = name_;
720         _symbol = symbol_;
721     }
722 
723     /**
724      * @dev See {IERC165-supportsInterface}.
725      */
726     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
727         return
728             interfaceId == type(IERC721).interfaceId ||
729             interfaceId == type(IERC721Metadata).interfaceId ||
730             super.supportsInterface(interfaceId);
731     }
732 
733     /**
734      * @dev See {IERC721-balanceOf}.
735      */
736     function balanceOf(address owner) public view virtual override returns (uint256) {
737         require(owner != address(0), "ERC721: balance query for the zero address");
738         return _balances[owner];
739     }
740 
741     /**
742      * @dev See {IERC721-ownerOf}.
743      */
744     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
745         address owner = _owners[tokenId];
746         require(owner != address(0), "ERC721: owner query for nonexistent token");
747         return owner;
748     }
749 
750     /**
751      * @dev See {IERC721Metadata-name}.
752      */
753     function name() public view virtual override returns (string memory) {
754         return _name;
755     }
756 
757     /**
758      * @dev See {IERC721Metadata-symbol}.
759      */
760     function symbol() public view virtual override returns (string memory) {
761         return _symbol;
762     }
763 
764     /**
765      * @dev See {IERC721Metadata-tokenURI}.
766      */
767     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
768         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
769 
770         string memory baseURI = _baseURI();
771         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
772     }
773 
774     /**
775      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
776      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
777      * by default, can be overriden in child contracts.
778      */
779     function _baseURI() internal view virtual returns (string memory) {
780         return "";
781     }
782 
783     /**
784      * @dev See {IERC721-approve}.
785      */
786     function approve(address to, uint256 tokenId) public virtual override {
787         address owner = ERC721.ownerOf(tokenId);
788         require(to != owner, "ERC721: approval to current owner");
789 
790         require(
791             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
792             "ERC721: approve caller is not owner nor approved for all"
793         );
794 
795         _approve(to, tokenId);
796     }
797 
798     /**
799      * @dev See {IERC721-getApproved}.
800      */
801     function getApproved(uint256 tokenId) public view virtual override returns (address) {
802         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
803 
804         return _tokenApprovals[tokenId];
805     }
806 
807     /**
808      * @dev See {IERC721-setApprovalForAll}.
809      */
810     function setApprovalForAll(address operator, bool approved) public virtual override {
811         _setApprovalForAll(_msgSender(), operator, approved);
812     }
813 
814     /**
815      * @dev See {IERC721-isApprovedForAll}.
816      */
817     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
818         return _operatorApprovals[owner][operator];
819     }
820 
821     /**
822      * @dev See {IERC721-transferFrom}.
823      */
824     function transferFrom(
825         address from,
826         address to,
827         uint256 tokenId
828     ) public virtual override {
829         //solhint-disable-next-line max-line-length
830         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
831 
832         _transfer(from, to, tokenId);
833     }
834 
835     /**
836      * @dev See {IERC721-safeTransferFrom}.
837      */
838     function safeTransferFrom(
839         address from,
840         address to,
841         uint256 tokenId
842     ) public virtual override {
843         safeTransferFrom(from, to, tokenId, "");
844     }
845 
846     /**
847      * @dev See {IERC721-safeTransferFrom}.
848      */
849     function safeTransferFrom(
850         address from,
851         address to,
852         uint256 tokenId,
853         bytes memory _data
854     ) public virtual override {
855         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
856         _safeTransfer(from, to, tokenId, _data);
857     }
858 
859     /**
860      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
861      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
862      *
863      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
864      *
865      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
866      * implement alternative mechanisms to perform token transfer, such as signature-based.
867      *
868      * Requirements:
869      *
870      * - `from` cannot be the zero address.
871      * - `to` cannot be the zero address.
872      * - `tokenId` token must exist and be owned by `from`.
873      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
874      *
875      * Emits a {Transfer} event.
876      */
877     function _safeTransfer(
878         address from,
879         address to,
880         uint256 tokenId,
881         bytes memory _data
882     ) internal virtual {
883         _transfer(from, to, tokenId);
884         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
885     }
886 
887     /**
888      * @dev Returns whether `tokenId` exists.
889      *
890      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
891      *
892      * Tokens start existing when they are minted (`_mint`),
893      * and stop existing when they are burned (`_burn`).
894      */
895     function _exists(uint256 tokenId) internal view virtual returns (bool) {
896         return _owners[tokenId] != address(0);
897     }
898 
899     /**
900      * @dev Returns whether `spender` is allowed to manage `tokenId`.
901      *
902      * Requirements:
903      *
904      * - `tokenId` must exist.
905      */
906     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
907         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
908         address owner = ERC721.ownerOf(tokenId);
909         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
910     }
911 
912     /**
913      * @dev Safely mints `tokenId` and transfers it to `to`.
914      *
915      * Requirements:
916      *
917      * - `tokenId` must not exist.
918      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
919      *
920      * Emits a {Transfer} event.
921      */
922     function _safeMint(address to, uint256 tokenId) internal virtual {
923         _safeMint(to, tokenId, "");
924     }
925 
926     /**
927      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
928      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
929      */
930     function _safeMint(
931         address to,
932         uint256 tokenId,
933         bytes memory _data
934     ) internal virtual {
935         _mint(to, tokenId);
936         require(
937             _checkOnERC721Received(address(0), to, tokenId, _data),
938             "ERC721: transfer to non ERC721Receiver implementer"
939         );
940     }
941 
942     /**
943      * @dev Mints `tokenId` and transfers it to `to`.
944      *
945      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
946      *
947      * Requirements:
948      *
949      * - `tokenId` must not exist.
950      * - `to` cannot be the zero address.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _mint(address to, uint256 tokenId) internal virtual {
955         require(to != address(0), "ERC721: mint to the zero address");
956         require(!_exists(tokenId), "ERC721: token already minted");
957 
958         _beforeTokenTransfer(address(0), to, tokenId);
959 
960         _balances[to] += 1;
961         _owners[tokenId] = to;
962 
963         emit Transfer(address(0), to, tokenId);
964     }
965 
966     /**
967      * @dev Destroys `tokenId`.
968      * The approval is cleared when the token is burned.
969      *
970      * Requirements:
971      *
972      * - `tokenId` must exist.
973      *
974      * Emits a {Transfer} event.
975      */
976     function _burn(uint256 tokenId) internal virtual {
977         address owner = ERC721.ownerOf(tokenId);
978 
979         _beforeTokenTransfer(owner, address(0), tokenId);
980 
981         // Clear approvals
982         _approve(address(0), tokenId);
983 
984         _balances[owner] -= 1;
985         delete _owners[tokenId];
986 
987         emit Transfer(owner, address(0), tokenId);
988     }
989 
990     /**
991      * @dev Transfers `tokenId` from `from` to `to`.
992      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
993      *
994      * Requirements:
995      *
996      * - `to` cannot be the zero address.
997      * - `tokenId` token must be owned by `from`.
998      *
999      * Emits a {Transfer} event.
1000      */
1001     function _transfer(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) internal virtual {
1006         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1007         require(to != address(0), "ERC721: transfer to the zero address");
1008 
1009         _beforeTokenTransfer(from, to, tokenId);
1010 
1011         // Clear approvals from the previous owner
1012         _approve(address(0), tokenId);
1013 
1014         _balances[from] -= 1;
1015         _balances[to] += 1;
1016         _owners[tokenId] = to;
1017 
1018         emit Transfer(from, to, tokenId);
1019     }
1020 
1021     /**
1022      * @dev Approve `to` to operate on `tokenId`
1023      *
1024      * Emits a {Approval} event.
1025      */
1026     function _approve(address to, uint256 tokenId) internal virtual {
1027         _tokenApprovals[tokenId] = to;
1028         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1029     }
1030 
1031     /**
1032      * @dev Approve `operator` to operate on all of `owner` tokens
1033      *
1034      * Emits a {ApprovalForAll} event.
1035      */
1036     function _setApprovalForAll(
1037         address owner,
1038         address operator,
1039         bool approved
1040     ) internal virtual {
1041         require(owner != operator, "ERC721: approve to caller");
1042         _operatorApprovals[owner][operator] = approved;
1043         emit ApprovalForAll(owner, operator, approved);
1044     }
1045 
1046     /**
1047      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1048      * The call is not executed if the target address is not a contract.
1049      *
1050      * @param from address representing the previous owner of the given token ID
1051      * @param to target address that will receive the tokens
1052      * @param tokenId uint256 ID of the token to be transferred
1053      * @param _data bytes optional data to send along with the call
1054      * @return bool whether the call correctly returned the expected magic value
1055      */
1056     function _checkOnERC721Received(
1057         address from,
1058         address to,
1059         uint256 tokenId,
1060         bytes memory _data
1061     ) private returns (bool) {
1062         if (to.isContract()) {
1063             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1064                 return retval == IERC721Receiver.onERC721Received.selector;
1065             } catch (bytes memory reason) {
1066                 if (reason.length == 0) {
1067                     revert("ERC721: transfer to non ERC721Receiver implementer");
1068                 } else {
1069                     assembly {
1070                         revert(add(32, reason), mload(reason))
1071                     }
1072                 }
1073             }
1074         } else {
1075             return true;
1076         }
1077     }
1078 
1079     /**
1080      * @dev Hook that is called before any token transfer. This includes minting
1081      * and burning.
1082      *
1083      * Calling conditions:
1084      *
1085      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1086      * transferred to `to`.
1087      * - When `from` is zero, `tokenId` will be minted for `to`.
1088      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1089      * - `from` and `to` are never both zero.
1090      *
1091      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1092      */
1093     function _beforeTokenTransfer(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) internal virtual {}
1098 }
1099 
1100 
1101 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1102 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1103 pragma solidity ^0.8.0;
1104 /**
1105  * @dev Contract module that helps prevent reentrant calls to a function.
1106  *
1107  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1108  * available, which can be applied to functions to make sure there are no nested
1109  * (reentrant) calls to them.
1110  *
1111  * Note that because there is a single `nonReentrant` guard, functions marked as
1112  * `nonReentrant` may not call one another. This can be worked around by making
1113  * those functions `private`, and then adding `external` `nonReentrant` entry
1114  * points to them.
1115  *
1116  * TIP: If you would like to learn more about reentrancy and alternative ways
1117  * to protect against it, check out our blog post
1118  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1119  */
1120 abstract contract ReentrancyGuard {
1121     // Booleans are more expensive than uint256 or any type that takes up a full
1122     // word because each write operation emits an extra SLOAD to first read the
1123     // slot's contents, replace the bits taken up by the boolean, and then write
1124     // back. This is the compiler's defense against contract upgrades and
1125     // pointer aliasing, and it cannot be disabled.
1126 
1127     // The values being non-zero value makes deployment a bit more expensive,
1128     // but in exchange the refund on every call to nonReentrant will be lower in
1129     // amount. Since refunds are capped to a percentage of the total
1130     // transaction's gas, it is best to keep them low in cases like this one, to
1131     // increase the likelihood of the full refund coming into effect.
1132     uint256 private constant _NOT_ENTERED = 1;
1133     uint256 private constant _ENTERED = 2;
1134 
1135     uint256 private _status;
1136 
1137     constructor() {
1138         _status = _NOT_ENTERED;
1139     }
1140 
1141     /**
1142      * @dev Prevents a contract from calling itself, directly or indirectly.
1143      * Calling a `nonReentrant` function from another `nonReentrant`
1144      * function is not supported. It is possible to prevent this from happening
1145      * by making the `nonReentrant` function external, and making it call a
1146      * `private` function that does the actual work.
1147      */
1148     modifier nonReentrant() {
1149         // On the first call to nonReentrant, _notEntered will be true
1150         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1151 
1152         // Any calls to nonReentrant after this point will fail
1153         _status = _ENTERED;
1154 
1155         _;
1156 
1157         // By storing the original value once again, a refund is triggered (see
1158         // https://eips.ethereum.org/EIPS/eip-2200)
1159         _status = _NOT_ENTERED;
1160     }
1161 }
1162 
1163 
1164 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1165 pragma solidity ^0.8.0;
1166 /**
1167  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1168  *
1169  * These functions can be used to verify that a message was signed by the holder
1170  * of the private keys of a given address.
1171  */
1172 library ECDSA {
1173     enum RecoverError {
1174         NoError,
1175         InvalidSignature,
1176         InvalidSignatureLength,
1177         InvalidSignatureS,
1178         InvalidSignatureV
1179     }
1180 
1181     function _throwError(RecoverError error) private pure {
1182         if (error == RecoverError.NoError) {
1183             return; // no error: do nothing
1184         } else if (error == RecoverError.InvalidSignature) {
1185             revert("ECDSA: invalid signature");
1186         } else if (error == RecoverError.InvalidSignatureLength) {
1187             revert("ECDSA: invalid signature length");
1188         } else if (error == RecoverError.InvalidSignatureS) {
1189             revert("ECDSA: invalid signature 's' value");
1190         } else if (error == RecoverError.InvalidSignatureV) {
1191             revert("ECDSA: invalid signature 'v' value");
1192         }
1193     }
1194 
1195     /**
1196      * @dev Returns the address that signed a hashed message (`hash`) with
1197      * `signature` or error string. This address can then be used for verification purposes.
1198      *
1199      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1200      * this function rejects them by requiring the `s` value to be in the lower
1201      * half order, and the `v` value to be either 27 or 28.
1202      *
1203      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1204      * verification to be secure: it is possible to craft signatures that
1205      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1206      * this is by receiving a hash of the original message (which may otherwise
1207      * be too long), and then calling {toEthSignedMessageHash} on it.
1208      *
1209      * Documentation for signature generation:
1210      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1211      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1212      *
1213      * _Available since v4.3._
1214      */
1215     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1216         // Check the signature length
1217         // - case 65: r,s,v signature (standard)
1218         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1219         if (signature.length == 65) {
1220             bytes32 r;
1221             bytes32 s;
1222             uint8 v;
1223             // ecrecover takes the signature parameters, and the only way to get them
1224             // currently is to use assembly.
1225             assembly {
1226                 r := mload(add(signature, 0x20))
1227                 s := mload(add(signature, 0x40))
1228                 v := byte(0, mload(add(signature, 0x60)))
1229             }
1230             return tryRecover(hash, v, r, s);
1231         } else if (signature.length == 64) {
1232             bytes32 r;
1233             bytes32 vs;
1234             // ecrecover takes the signature parameters, and the only way to get them
1235             // currently is to use assembly.
1236             assembly {
1237                 r := mload(add(signature, 0x20))
1238                 vs := mload(add(signature, 0x40))
1239             }
1240             return tryRecover(hash, r, vs);
1241         } else {
1242             return (address(0), RecoverError.InvalidSignatureLength);
1243         }
1244     }
1245 
1246     /**
1247      * @dev Returns the address that signed a hashed message (`hash`) with
1248      * `signature`. This address can then be used for verification purposes.
1249      *
1250      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1251      * this function rejects them by requiring the `s` value to be in the lower
1252      * half order, and the `v` value to be either 27 or 28.
1253      *
1254      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1255      * verification to be secure: it is possible to craft signatures that
1256      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1257      * this is by receiving a hash of the original message (which may otherwise
1258      * be too long), and then calling {toEthSignedMessageHash} on it.
1259      */
1260     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1261         (address recovered, RecoverError error) = tryRecover(hash, signature);
1262         _throwError(error);
1263         return recovered;
1264     }
1265 
1266     /**
1267      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1268      *
1269      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1270      *
1271      * _Available since v4.3._
1272      */
1273     function tryRecover(
1274         bytes32 hash,
1275         bytes32 r,
1276         bytes32 vs
1277     ) internal pure returns (address, RecoverError) {
1278         bytes32 s;
1279         uint8 v;
1280         assembly {
1281             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1282             v := add(shr(255, vs), 27)
1283         }
1284         return tryRecover(hash, v, r, s);
1285     }
1286 
1287     /**
1288      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1289      *
1290      * _Available since v4.2._
1291      */
1292     function recover(
1293         bytes32 hash,
1294         bytes32 r,
1295         bytes32 vs
1296     ) internal pure returns (address) {
1297         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1298         _throwError(error);
1299         return recovered;
1300     }
1301 
1302     /**
1303      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1304      * `r` and `s` signature fields separately.
1305      *
1306      * _Available since v4.3._
1307      */
1308     function tryRecover(
1309         bytes32 hash,
1310         uint8 v,
1311         bytes32 r,
1312         bytes32 s
1313     ) internal pure returns (address, RecoverError) {
1314         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1315         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1316         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1317         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1318         //
1319         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1320         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1321         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1322         // these malleable signatures as well.
1323         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1324             return (address(0), RecoverError.InvalidSignatureS);
1325         }
1326         if (v != 27 && v != 28) {
1327             return (address(0), RecoverError.InvalidSignatureV);
1328         }
1329 
1330         // If the signature is valid (and not malleable), return the signer address
1331         address signer = ecrecover(hash, v, r, s);
1332         if (signer == address(0)) {
1333             return (address(0), RecoverError.InvalidSignature);
1334         }
1335 
1336         return (signer, RecoverError.NoError);
1337     }
1338 
1339     /**
1340      * @dev Overload of {ECDSA-recover} that receives the `v`,
1341      * `r` and `s` signature fields separately.
1342      */
1343     function recover(
1344         bytes32 hash,
1345         uint8 v,
1346         bytes32 r,
1347         bytes32 s
1348     ) internal pure returns (address) {
1349         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1350         _throwError(error);
1351         return recovered;
1352     }
1353 
1354     /**
1355      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1356      * produces hash corresponding to the one signed with the
1357      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1358      * JSON-RPC method as part of EIP-191.
1359      *
1360      * See {recover}.
1361      */
1362     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1363         // 32 is the length in bytes of hash,
1364         // enforced by the type signature above
1365         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1366     }
1367 
1368     /**
1369      * @dev Returns an Ethereum Signed Message, created from `s`. This
1370      * produces hash corresponding to the one signed with the
1371      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1372      * JSON-RPC method as part of EIP-191.
1373      *
1374      * See {recover}.
1375      */
1376     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1377         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1378     }
1379 
1380     /**
1381      * @dev Returns an Ethereum Signed Typed Data, created from a
1382      * `domainSeparator` and a `structHash`. This produces hash corresponding
1383      * to the one signed with the
1384      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1385      * JSON-RPC method as part of EIP-712.
1386      *
1387      * See {recover}.
1388      */
1389     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1390         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1391     }
1392 }
1393 
1394 
1395 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1396 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1397 pragma solidity ^0.8.0;
1398 /**
1399  * @dev These functions deal with verification of Merkle Trees proofs.
1400  *
1401  * The proofs can be generated using the JavaScript library
1402  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1403  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1404  *
1405  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1406  */
1407 library MerkleProof {
1408     /**
1409      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1410      * defined by `root`. For this, a `proof` must be provided, containing
1411      * sibling hashes on the branch from the leaf to the root of the tree. Each
1412      * pair of leaves and each pair of pre-images are assumed to be sorted.
1413      */
1414     function verify(
1415         bytes32[] memory proof,
1416         bytes32 root,
1417         bytes32 leaf
1418     ) internal pure returns (bool) {
1419         return processProof(proof, leaf) == root;
1420     }
1421 
1422     /**
1423      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1424      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1425      * hash matches the root of the tree. When processing the proof, the pairs
1426      * of leafs & pre-images are assumed to be sorted.
1427      *
1428      * _Available since v4.4._
1429      */
1430     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1431         bytes32 computedHash = leaf;
1432         for (uint256 i = 0; i < proof.length; i++) {
1433             bytes32 proofElement = proof[i];
1434             if (computedHash <= proofElement) {
1435                 // Hash(current computed hash + current element of the proof)
1436                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1437             } else {
1438                 // Hash(current element of the proof + current computed hash)
1439                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1440             }
1441         }
1442         return computedHash;
1443     }
1444 }
1445 
1446 // File: contracts/Bapetaverse.sol
1447 pragma solidity 0.8.12;
1448 
1449 // @author: https://twitter.com/3DC0D3
1450 
1451 contract BapetaverseNFT is ERC721, IERC2981, Ownable, ReentrancyGuard {
1452 	using Strings for uint256;
1453 	using Counters for Counters.Counter;
1454 	Counters.Counter private supply;
1455 
1456 	enum MintStatus {
1457 		CLOSED,
1458 		PRESALE,
1459 		PUBLIC
1460 	}
1461 
1462 	string public uriPrefix;
1463 	string public uriSuffix = "";
1464 	string public hiddenMetadataUri;
1465 
1466 	uint256 public cost = 0.30 ether;
1467 	uint256 public maxSupply = 10000;
1468 	uint256 public nftPerAddressLimit = 2;
1469 	uint256 public royaltiesPercentage = 750;
1470 	uint256 public constant MAX_MINT_AMOUNT_PER_TX = 2;
1471 
1472 	bool public revealed = false;
1473 	MintStatus public mintStatus = MintStatus.CLOSED;
1474 
1475 	address public signerAddress = 0x1D80Ffd75C924Bc19F22B21E85a1BC472558184A;
1476 	address public constant WITHDRAW_ADDRESS = 0xFC4BF9d0AB489E7684aB0E06D33B8E2257D8fF60;
1477 	bytes32 public merkleRoot = 0x5d89ec5b68e28718105b1c05c18a849e7b82c2cb93e58d194df0839e792aacb3;
1478 
1479 	mapping(address => bool) private whitelist;
1480 	mapping(address => uint256) private addressMintedBalance;
1481 
1482     event RoyaltyPercentageEvent(uint256 _newPercentage);
1483     event NFTPerAddressLimitEvent(uint256 _limit);
1484     event CostEvent(uint256 _newCost);
1485     event MaxSupplyEvent(uint256 _newSupply);
1486 
1487 	/////////////////////////////////////////////////////////////////////////////////////////
1488 	/////////////////////////////////////////////////////////////////////////////////////////
1489 
1490 	constructor(string memory _initUriPrefix, string memory _initHiddenMetadataUri) ERC721("(B)APETAVERSE", "BVS") {
1491 		setUriPrefix(_initUriPrefix);
1492 		setHiddenMetadataUri(_initHiddenMetadataUri);
1493 	}
1494 
1495 	modifier onlyExternal() {
1496 		require(msg.sender == tx.origin, "Contracts not allowed to mint");
1497 		_;
1498 	}
1499 
1500 	modifier mintCompliance(uint256 _mintAmount) {
1501 		require(mintStatus != MintStatus.CLOSED, "Minting is closed");
1502 		require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded");
1503 		require(_mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT_PER_TX, "Invalid mint amount");
1504 		require(msg.value >= cost * _mintAmount, "Insufficient funds");
1505 		require(addressMintedBalance[msg.sender] + _mintAmount <= nftPerAddressLimit, "Max NFT per address exceeded");
1506 		_;
1507 	}
1508 
1509 	// external
1510 	function royaltyInfo(uint256, uint256 _salePrice) external view override returns (address receiver, uint256 royaltyAmount) {
1511 		uint256 royalties = (_salePrice * royaltiesPercentage) / 10000;
1512 		return (owner(), royalties);
1513 	}
1514 
1515 	// public
1516 	function supportsInterface(bytes4 interfaceId) public view override(IERC165, ERC721) returns (bool) {
1517 		return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1518 	}
1519 
1520 	function mintForAddress(address _receiver, uint256 _mintAmount) public onlyOwner {
1521         require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded");
1522 		_mintLoop(_receiver, _mintAmount);
1523 	}
1524 
1525 	function _mintLoop(address _receiver, uint256 _mintAmount) private {
1526 		for (uint256 i = 0; i < _mintAmount; i++) {
1527 			addressMintedBalance[_receiver]++;
1528 			supply.increment();
1529 			_safeMint(_receiver, supply.current());
1530 		}
1531 	}
1532 
1533 	function _mintPresale(uint256 _mintAmount, bytes32[] memory _proof) private {
1534 		require(mintStatus == MintStatus.PRESALE, "Not presale");
1535 		require(whitelist[msg.sender], "Not Whitelisted");
1536 
1537 		if (verify(_proof)) {
1538 			_mintLoop(msg.sender, _mintAmount);
1539 		} else {
1540 			revert("Proof failed");
1541 		}
1542 	}
1543 
1544 	function _mintPublic(uint256 _mintAmount, bytes memory _signature) private {
1545 		require(mintStatus == MintStatus.PUBLIC, "Not public sale");
1546 
1547 		if (signerOwner(_signature) == signerAddress) {
1548 			_mintLoop(msg.sender, _mintAmount);
1549 		} else {
1550 			revert("Not Authorised");
1551 		}
1552 	}
1553 
1554 	function mint(
1555 		uint256 _mintAmount,
1556 		bytes32[] memory _proof,
1557 		bytes memory _signature
1558 	) public payable mintCompliance(_mintAmount) onlyExternal nonReentrant {
1559 		if (mintStatus == MintStatus.PRESALE) {
1560 			_mintPresale(_mintAmount, _proof);
1561 		} else if (mintStatus == MintStatus.PUBLIC) {
1562 			_mintPublic(_mintAmount, _signature);
1563 		}
1564 	}
1565 
1566 	function signerOwner(bytes memory _signature) private view returns (address) {
1567 		return ECDSA.recover(keccak256(abi.encode(msg.sender)), _signature);
1568 	}
1569 
1570 	function verify(bytes32[] memory _proof) public view returns (bool) {
1571 		return
1572 			MerkleProof.verify(
1573 				_proof,
1574 				merkleRoot,
1575 				keccak256(abi.encodePacked(msg.sender))
1576 			);
1577 	}
1578 
1579 	function totalSupply() public view returns (uint256) {
1580 		return supply.current();
1581 	}
1582 
1583 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1584 		require(_exists(tokenId), "URI query for nonexistent token");
1585 
1586 		if (revealed == false) {
1587 			return bytes(hiddenMetadataUri).length > 0 ? string(abi.encodePacked(hiddenMetadataUri, tokenId.toString(), uriSuffix)) : "";
1588 		}
1589 
1590 		string memory currentUriPrefix = _baseURI();
1591 		return bytes(currentUriPrefix).length > 0 ? string(abi.encodePacked(currentUriPrefix, tokenId.toString(), uriSuffix)) : "";
1592 	}
1593 
1594 	//only owner
1595 	function setRoyaltyPercentage(uint256 _newPercentage) public onlyOwner {
1596 		royaltiesPercentage = _newPercentage;
1597         emit RoyaltyPercentageEvent(royaltiesPercentage);
1598 	}
1599 
1600 	function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1601 		nftPerAddressLimit = _limit;
1602         emit NFTPerAddressLimitEvent(nftPerAddressLimit);
1603 	}
1604 
1605 	function setCost(uint256 _newCost) public onlyOwner {
1606 		cost = _newCost;
1607         emit CostEvent(cost);
1608 	}
1609 
1610 	function setMaxSupply(uint256 _newSupply) public onlyOwner {
1611 		maxSupply = _newSupply;
1612         emit MaxSupplyEvent(maxSupply);
1613 	}
1614 
1615 	function setUriPrefix(string memory _newUriPrefix) public onlyOwner {
1616 		uriPrefix = _newUriPrefix;
1617 	}
1618 
1619 	function setUriSuffix(string memory _newUriSuffix) public onlyOwner {
1620 		uriSuffix = _newUriSuffix;
1621 	}
1622 
1623 	function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1624 		hiddenMetadataUri = _hiddenMetadataUri;
1625 	}
1626 
1627 	function whitelistAddresses(address[] memory _addresses) external onlyOwner {
1628 		for (uint256 i; i < _addresses.length; i++) {
1629 			whitelist[_addresses[i]] = true;
1630 		}
1631 	}
1632 
1633 	function setSignerAddress(address _newSignerAddress) public onlyOwner {
1634 		signerAddress = _newSignerAddress;
1635 	}
1636 
1637 	function whitelistStatus(address _address) external view returns (bool) {
1638 		return whitelist[_address];
1639 	}
1640 
1641     function mintedBalance(address _address) external view returns (uint256) {
1642 		return addressMintedBalance[_address];
1643 	}
1644 
1645 	function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1646 		merkleRoot = _merkleRoot;
1647 	}
1648 
1649 	function setReveal(bool _state) public onlyOwner {
1650 		revealed = _state;
1651 	}
1652 
1653 	function setMintStatus(uint8 _status) external onlyOwner {
1654 		mintStatus = MintStatus(_status);
1655 	}
1656 
1657 	function withdraw() public onlyOwner {
1658 		require(address(this).balance != 0, "Balance is zero");
1659 		(bool success, ) = payable(WITHDRAW_ADDRESS).call{ value: address(this).balance }("");
1660 		require(success, "Withdrawal failed");
1661 	}
1662 
1663 	// internal
1664 	function _baseURI() internal view virtual override returns (string memory) {
1665 		return uriPrefix;
1666 	}
1667 }