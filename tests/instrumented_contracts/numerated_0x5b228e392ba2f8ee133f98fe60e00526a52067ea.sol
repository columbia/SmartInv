1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/access/Ownable.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _transferOwnership(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _transferOwnership(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _transferOwnership(newOwner);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Internal function without access restriction.
168      */
169     function _transferOwnership(address newOwner) internal virtual {
170         address oldOwner = _owner;
171         _owner = newOwner;
172         emit OwnershipTransferred(oldOwner, newOwner);
173     }
174 }
175 
176 // File: @openzeppelin/contracts/utils/Address.sol
177 
178 
179 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
180 
181 pragma solidity ^0.8.1;
182 
183 /**
184  * @dev Collection of functions related to the address type
185  */
186 library Address {
187     /**
188      * @dev Returns true if `account` is a contract.
189      *
190      * [IMPORTANT]
191      * ====
192      * It is unsafe to assume that an address for which this function returns
193      * false is an externally-owned account (EOA) and not a contract.
194      *
195      * Among others, `isContract` will return false for the following
196      * types of addresses:
197      *
198      *  - an externally-owned account
199      *  - a contract in construction
200      *  - an address where a contract will be created
201      *  - an address where a contract lived, but was destroyed
202      * ====
203      *
204      * [IMPORTANT]
205      * ====
206      * You shouldn't rely on `isContract` to protect against flash loan attacks!
207      *
208      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
209      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
210      * constructor.
211      * ====
212      */
213     function isContract(address account) internal view returns (bool) {
214         // This method relies on extcodesize/address.code.length, which returns 0
215         // for contracts in construction, since the code is only stored at the end
216         // of the constructor execution.
217 
218         return account.code.length > 0;
219     }
220 
221     /**
222      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
223      * `recipient`, forwarding all available gas and reverting on errors.
224      *
225      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
226      * of certain opcodes, possibly making contracts go over the 2300 gas limit
227      * imposed by `transfer`, making them unable to receive funds via
228      * `transfer`. {sendValue} removes this limitation.
229      *
230      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
231      *
232      * IMPORTANT: because control is transferred to `recipient`, care must be
233      * taken to not create reentrancy vulnerabilities. Consider using
234      * {ReentrancyGuard} or the
235      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
236      */
237     function sendValue(address payable recipient, uint256 amount) internal {
238         require(address(this).balance >= amount, "Address: insufficient balance");
239 
240         (bool success, ) = recipient.call{value: amount}("");
241         require(success, "Address: unable to send value, recipient may have reverted");
242     }
243 
244     /**
245      * @dev Performs a Solidity function call using a low level `call`. A
246      * plain `call` is an unsafe replacement for a function call: use this
247      * function instead.
248      *
249      * If `target` reverts with a revert reason, it is bubbled up by this
250      * function (like regular Solidity function calls).
251      *
252      * Returns the raw returned data. To convert to the expected return value,
253      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
254      *
255      * Requirements:
256      *
257      * - `target` must be a contract.
258      * - calling `target` with `data` must not revert.
259      *
260      * _Available since v3.1._
261      */
262     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
263         return functionCall(target, data, "Address: low-level call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
268      * `errorMessage` as a fallback revert reason when `target` reverts.
269      *
270      * _Available since v3.1._
271      */
272     function functionCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         return functionCallWithValue(target, data, 0, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but also transferring `value` wei to `target`.
283      *
284      * Requirements:
285      *
286      * - the calling contract must have an ETH balance of at least `value`.
287      * - the called Solidity function must be `payable`.
288      *
289      * _Available since v3.1._
290      */
291     function functionCallWithValue(
292         address target,
293         bytes memory data,
294         uint256 value
295     ) internal returns (bytes memory) {
296         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
301      * with `errorMessage` as a fallback revert reason when `target` reverts.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(
306         address target,
307         bytes memory data,
308         uint256 value,
309         string memory errorMessage
310     ) internal returns (bytes memory) {
311         require(address(this).balance >= value, "Address: insufficient balance for call");
312         require(isContract(target), "Address: call to non-contract");
313 
314         (bool success, bytes memory returndata) = target.call{value: value}(data);
315         return verifyCallResult(success, returndata, errorMessage);
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
320      * but performing a static call.
321      *
322      * _Available since v3.3._
323      */
324     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
325         return functionStaticCall(target, data, "Address: low-level static call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
330      * but performing a static call.
331      *
332      * _Available since v3.3._
333      */
334     function functionStaticCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal view returns (bytes memory) {
339         require(isContract(target), "Address: static call to non-contract");
340 
341         (bool success, bytes memory returndata) = target.staticcall(data);
342         return verifyCallResult(success, returndata, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but performing a delegate call.
348      *
349      * _Available since v3.4._
350      */
351     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
357      * but performing a delegate call.
358      *
359      * _Available since v3.4._
360      */
361     function functionDelegateCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         require(isContract(target), "Address: delegate call to non-contract");
367 
368         (bool success, bytes memory returndata) = target.delegatecall(data);
369         return verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
374      * revert reason using the provided one.
375      *
376      * _Available since v4.3._
377      */
378     function verifyCallResult(
379         bool success,
380         bytes memory returndata,
381         string memory errorMessage
382     ) internal pure returns (bytes memory) {
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
402 
403 
404 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 /**
409  * @title ERC721 token receiver interface
410  * @dev Interface for any contract that wants to support safeTransfers
411  * from ERC721 asset contracts.
412  */
413 interface IERC721Receiver {
414     /**
415      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
416      * by `operator` from `from`, this function is called.
417      *
418      * It must return its Solidity selector to confirm the token transfer.
419      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
420      *
421      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
422      */
423     function onERC721Received(
424         address operator,
425         address from,
426         uint256 tokenId,
427         bytes calldata data
428     ) external returns (bytes4);
429 }
430 
431 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
432 
433 
434 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
435 
436 pragma solidity ^0.8.0;
437 
438 /**
439  * @dev Interface of the ERC165 standard, as defined in the
440  * https://eips.ethereum.org/EIPS/eip-165[EIP].
441  *
442  * Implementers can declare support of contract interfaces, which can then be
443  * queried by others ({ERC165Checker}).
444  *
445  * For an implementation, see {ERC165}.
446  */
447 interface IERC165 {
448     /**
449      * @dev Returns true if this contract implements the interface defined by
450      * `interfaceId`. See the corresponding
451      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
452      * to learn more about how these ids are created.
453      *
454      * This function call must use less than 30 000 gas.
455      */
456     function supportsInterface(bytes4 interfaceId) external view returns (bool);
457 }
458 
459 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
460 
461 
462 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
463 
464 pragma solidity ^0.8.0;
465 
466 
467 /**
468  * @dev Implementation of the {IERC165} interface.
469  *
470  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
471  * for the additional interface id that will be supported. For example:
472  *
473  * ```solidity
474  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
475  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
476  * }
477  * ```
478  *
479  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
480  */
481 abstract contract ERC165 is IERC165 {
482     /**
483      * @dev See {IERC165-supportsInterface}.
484      */
485     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
486         return interfaceId == type(IERC165).interfaceId;
487     }
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
491 
492 
493 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 
498 /**
499  * @dev Required interface of an ERC721 compliant contract.
500  */
501 interface IERC721 is IERC165 {
502     /**
503      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
504      */
505     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
506 
507     /**
508      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
509      */
510     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
511 
512     /**
513      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
514      */
515     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
516 
517     /**
518      * @dev Returns the number of tokens in ``owner``'s account.
519      */
520     function balanceOf(address owner) external view returns (uint256 balance);
521 
522     /**
523      * @dev Returns the owner of the `tokenId` token.
524      *
525      * Requirements:
526      *
527      * - `tokenId` must exist.
528      */
529     function ownerOf(uint256 tokenId) external view returns (address owner);
530 
531     /**
532      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
533      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
534      *
535      * Requirements:
536      *
537      * - `from` cannot be the zero address.
538      * - `to` cannot be the zero address.
539      * - `tokenId` token must exist and be owned by `from`.
540      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
541      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
542      *
543      * Emits a {Transfer} event.
544      */
545     function safeTransferFrom(
546         address from,
547         address to,
548         uint256 tokenId
549     ) external;
550 
551     /**
552      * @dev Transfers `tokenId` token from `from` to `to`.
553      *
554      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must be owned by `from`.
561      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
562      *
563      * Emits a {Transfer} event.
564      */
565     function transferFrom(
566         address from,
567         address to,
568         uint256 tokenId
569     ) external;
570 
571     /**
572      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
573      * The approval is cleared when the token is transferred.
574      *
575      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
576      *
577      * Requirements:
578      *
579      * - The caller must own the token or be an approved operator.
580      * - `tokenId` must exist.
581      *
582      * Emits an {Approval} event.
583      */
584     function approve(address to, uint256 tokenId) external;
585 
586     /**
587      * @dev Returns the account approved for `tokenId` token.
588      *
589      * Requirements:
590      *
591      * - `tokenId` must exist.
592      */
593     function getApproved(uint256 tokenId) external view returns (address operator);
594 
595     /**
596      * @dev Approve or remove `operator` as an operator for the caller.
597      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
598      *
599      * Requirements:
600      *
601      * - The `operator` cannot be the caller.
602      *
603      * Emits an {ApprovalForAll} event.
604      */
605     function setApprovalForAll(address operator, bool _approved) external;
606 
607     /**
608      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
609      *
610      * See {setApprovalForAll}
611      */
612     function isApprovedForAll(address owner, address operator) external view returns (bool);
613 
614     /**
615      * @dev Safely transfers `tokenId` token from `from` to `to`.
616      *
617      * Requirements:
618      *
619      * - `from` cannot be the zero address.
620      * - `to` cannot be the zero address.
621      * - `tokenId` token must exist and be owned by `from`.
622      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
623      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
624      *
625      * Emits a {Transfer} event.
626      */
627     function safeTransferFrom(
628         address from,
629         address to,
630         uint256 tokenId,
631         bytes calldata data
632     ) external;
633 }
634 
635 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
636 
637 
638 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 
643 /**
644  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
645  * @dev See https://eips.ethereum.org/EIPS/eip-721
646  */
647 interface IERC721Metadata is IERC721 {
648     /**
649      * @dev Returns the token collection name.
650      */
651     function name() external view returns (string memory);
652 
653     /**
654      * @dev Returns the token collection symbol.
655      */
656     function symbol() external view returns (string memory);
657 
658     /**
659      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
660      */
661     function tokenURI(uint256 tokenId) external view returns (string memory);
662 }
663 
664 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
665 
666 
667 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 
672 
673 
674 
675 
676 
677 
678 /**
679  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
680  * the Metadata extension, but not including the Enumerable extension, which is available separately as
681  * {ERC721Enumerable}.
682  */
683 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
684     using Address for address;
685     using Strings for uint256;
686 
687     // Token name
688     string private _name;
689 
690     // Token symbol
691     string private _symbol;
692 
693     // Mapping from token ID to owner address
694     mapping(uint256 => address) private _owners;
695 
696     // Mapping owner address to token count
697     mapping(address => uint256) private _balances;
698 
699     // Mapping from token ID to approved address
700     mapping(uint256 => address) private _tokenApprovals;
701 
702     // Mapping from owner to operator approvals
703     mapping(address => mapping(address => bool)) private _operatorApprovals;
704 
705     /**
706      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
707      */
708     constructor(string memory name_, string memory symbol_) {
709         _name = name_;
710         _symbol = symbol_;
711     }
712 
713     /**
714      * @dev See {IERC165-supportsInterface}.
715      */
716     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
717         return
718             interfaceId == type(IERC721).interfaceId ||
719             interfaceId == type(IERC721Metadata).interfaceId ||
720             super.supportsInterface(interfaceId);
721     }
722 
723     /**
724      * @dev See {IERC721-balanceOf}.
725      */
726     function balanceOf(address owner) public view virtual override returns (uint256) {
727         require(owner != address(0), "ERC721: balance query for the zero address");
728         return _balances[owner];
729     }
730 
731     /**
732      * @dev See {IERC721-ownerOf}.
733      */
734     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
735         address owner = _owners[tokenId];
736         require(owner != address(0), "ERC721: owner query for nonexistent token");
737         return owner;
738     }
739 
740     /**
741      * @dev See {IERC721Metadata-name}.
742      */
743     function name() public view virtual override returns (string memory) {
744         return _name;
745     }
746 
747     /**
748      * @dev See {IERC721Metadata-symbol}.
749      */
750     function symbol() public view virtual override returns (string memory) {
751         return _symbol;
752     }
753 
754     /**
755      * @dev See {IERC721Metadata-tokenURI}.
756      */
757     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
758         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
759 
760         string memory baseURI = _baseURI();
761         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
762     }
763 
764     /**
765      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
766      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
767      * by default, can be overriden in child contracts.
768      */
769     function _baseURI() internal view virtual returns (string memory) {
770         return "";
771     }
772 
773     /**
774      * @dev See {IERC721-approve}.
775      */
776     function approve(address to, uint256 tokenId) public virtual override {
777         address owner = ERC721.ownerOf(tokenId);
778         require(to != owner, "ERC721: approval to current owner");
779 
780         require(
781             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
782             "ERC721: approve caller is not owner nor approved for all"
783         );
784 
785         _approve(to, tokenId);
786     }
787 
788     /**
789      * @dev See {IERC721-getApproved}.
790      */
791     function getApproved(uint256 tokenId) public view virtual override returns (address) {
792         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
793 
794         return _tokenApprovals[tokenId];
795     }
796 
797     /**
798      * @dev See {IERC721-setApprovalForAll}.
799      */
800     function setApprovalForAll(address operator, bool approved) public virtual override {
801         _setApprovalForAll(_msgSender(), operator, approved);
802     }
803 
804     /**
805      * @dev See {IERC721-isApprovedForAll}.
806      */
807     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
808         return _operatorApprovals[owner][operator];
809     }
810 
811     /**
812      * @dev See {IERC721-transferFrom}.
813      */
814     function transferFrom(
815         address from,
816         address to,
817         uint256 tokenId
818     ) public virtual override {
819         //solhint-disable-next-line max-line-length
820         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
821 
822         _transfer(from, to, tokenId);
823     }
824 
825     /**
826      * @dev See {IERC721-safeTransferFrom}.
827      */
828     function safeTransferFrom(
829         address from,
830         address to,
831         uint256 tokenId
832     ) public virtual override {
833         safeTransferFrom(from, to, tokenId, "");
834     }
835 
836     /**
837      * @dev See {IERC721-safeTransferFrom}.
838      */
839     function safeTransferFrom(
840         address from,
841         address to,
842         uint256 tokenId,
843         bytes memory _data
844     ) public virtual override {
845         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
846         _safeTransfer(from, to, tokenId, _data);
847     }
848 
849     /**
850      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
851      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
852      *
853      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
854      *
855      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
856      * implement alternative mechanisms to perform token transfer, such as signature-based.
857      *
858      * Requirements:
859      *
860      * - `from` cannot be the zero address.
861      * - `to` cannot be the zero address.
862      * - `tokenId` token must exist and be owned by `from`.
863      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
864      *
865      * Emits a {Transfer} event.
866      */
867     function _safeTransfer(
868         address from,
869         address to,
870         uint256 tokenId,
871         bytes memory _data
872     ) internal virtual {
873         _transfer(from, to, tokenId);
874         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
875     }
876 
877     /**
878      * @dev Returns whether `tokenId` exists.
879      *
880      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
881      *
882      * Tokens start existing when they are minted (`_mint`),
883      * and stop existing when they are burned (`_burn`).
884      */
885     function _exists(uint256 tokenId) internal view virtual returns (bool) {
886         return _owners[tokenId] != address(0);
887     }
888 
889     /**
890      * @dev Returns whether `spender` is allowed to manage `tokenId`.
891      *
892      * Requirements:
893      *
894      * - `tokenId` must exist.
895      */
896     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
897         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
898         address owner = ERC721.ownerOf(tokenId);
899         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
900     }
901 
902     /**
903      * @dev Safely mints `tokenId` and transfers it to `to`.
904      *
905      * Requirements:
906      *
907      * - `tokenId` must not exist.
908      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _safeMint(address to, uint256 tokenId) internal virtual {
913         _safeMint(to, tokenId, "");
914     }
915 
916     /**
917      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
918      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
919      */
920     function _safeMint(
921         address to,
922         uint256 tokenId,
923         bytes memory _data
924     ) internal virtual {
925         _mint(to, tokenId);
926         require(
927             _checkOnERC721Received(address(0), to, tokenId, _data),
928             "ERC721: transfer to non ERC721Receiver implementer"
929         );
930     }
931 
932     /**
933      * @dev Mints `tokenId` and transfers it to `to`.
934      *
935      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
936      *
937      * Requirements:
938      *
939      * - `tokenId` must not exist.
940      * - `to` cannot be the zero address.
941      *
942      * Emits a {Transfer} event.
943      */
944     function _mint(address to, uint256 tokenId) internal virtual {
945         require(to != address(0), "ERC721: mint to the zero address");
946         require(!_exists(tokenId), "ERC721: token already minted");
947 
948         _beforeTokenTransfer(address(0), to, tokenId);
949 
950         _balances[to] += 1;
951         _owners[tokenId] = to;
952 
953         emit Transfer(address(0), to, tokenId);
954 
955         _afterTokenTransfer(address(0), to, tokenId);
956     }
957 
958     /**
959      * @dev Destroys `tokenId`.
960      * The approval is cleared when the token is burned.
961      *
962      * Requirements:
963      *
964      * - `tokenId` must exist.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _burn(uint256 tokenId) internal virtual {
969         address owner = ERC721.ownerOf(tokenId);
970 
971         _beforeTokenTransfer(owner, address(0), tokenId);
972 
973         // Clear approvals
974         _approve(address(0), tokenId);
975 
976         _balances[owner] -= 1;
977         delete _owners[tokenId];
978 
979         emit Transfer(owner, address(0), tokenId);
980 
981         _afterTokenTransfer(owner, address(0), tokenId);
982     }
983 
984     /**
985      * @dev Transfers `tokenId` from `from` to `to`.
986      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
987      *
988      * Requirements:
989      *
990      * - `to` cannot be the zero address.
991      * - `tokenId` token must be owned by `from`.
992      *
993      * Emits a {Transfer} event.
994      */
995     function _transfer(
996         address from,
997         address to,
998         uint256 tokenId
999     ) internal virtual {
1000         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1001         require(to != address(0), "ERC721: transfer to the zero address");
1002 
1003         _beforeTokenTransfer(from, to, tokenId);
1004 
1005         // Clear approvals from the previous owner
1006         _approve(address(0), tokenId);
1007 
1008         _balances[from] -= 1;
1009         _balances[to] += 1;
1010         _owners[tokenId] = to;
1011 
1012         emit Transfer(from, to, tokenId);
1013 
1014         _afterTokenTransfer(from, to, tokenId);
1015     }
1016 
1017     /**
1018      * @dev Approve `to` to operate on `tokenId`
1019      *
1020      * Emits a {Approval} event.
1021      */
1022     function _approve(address to, uint256 tokenId) internal virtual {
1023         _tokenApprovals[tokenId] = to;
1024         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev Approve `operator` to operate on all of `owner` tokens
1029      *
1030      * Emits a {ApprovalForAll} event.
1031      */
1032     function _setApprovalForAll(
1033         address owner,
1034         address operator,
1035         bool approved
1036     ) internal virtual {
1037         require(owner != operator, "ERC721: approve to caller");
1038         _operatorApprovals[owner][operator] = approved;
1039         emit ApprovalForAll(owner, operator, approved);
1040     }
1041 
1042     /**
1043      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1044      * The call is not executed if the target address is not a contract.
1045      *
1046      * @param from address representing the previous owner of the given token ID
1047      * @param to target address that will receive the tokens
1048      * @param tokenId uint256 ID of the token to be transferred
1049      * @param _data bytes optional data to send along with the call
1050      * @return bool whether the call correctly returned the expected magic value
1051      */
1052     function _checkOnERC721Received(
1053         address from,
1054         address to,
1055         uint256 tokenId,
1056         bytes memory _data
1057     ) private returns (bool) {
1058         if (to.isContract()) {
1059             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1060                 return retval == IERC721Receiver.onERC721Received.selector;
1061             } catch (bytes memory reason) {
1062                 if (reason.length == 0) {
1063                     revert("ERC721: transfer to non ERC721Receiver implementer");
1064                 } else {
1065                     assembly {
1066                         revert(add(32, reason), mload(reason))
1067                     }
1068                 }
1069             }
1070         } else {
1071             return true;
1072         }
1073     }
1074 
1075     /**
1076      * @dev Hook that is called before any token transfer. This includes minting
1077      * and burning.
1078      *
1079      * Calling conditions:
1080      *
1081      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1082      * transferred to `to`.
1083      * - When `from` is zero, `tokenId` will be minted for `to`.
1084      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1085      * - `from` and `to` are never both zero.
1086      *
1087      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1088      */
1089     function _beforeTokenTransfer(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) internal virtual {}
1094 
1095     /**
1096      * @dev Hook that is called after any transfer of tokens. This includes
1097      * minting and burning.
1098      *
1099      * Calling conditions:
1100      *
1101      * - when `from` and `to` are both non-zero.
1102      * - `from` and `to` are never both zero.
1103      *
1104      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1105      */
1106     function _afterTokenTransfer(
1107         address from,
1108         address to,
1109         uint256 tokenId
1110     ) internal virtual {}
1111 }
1112 
1113 // File: contracts/gator_raid.sol
1114 
1115 
1116 pragma solidity 0.8.11;
1117 
1118 
1119 
1120 contract GatorRaidNft is ERC721, Ownable {
1121     string public baseURI;
1122     uint256 MAX_SUPPLY = 4223;
1123     uint256 MAX_FREE_SUPPLY = 445;
1124     uint256 MAX_RESERVED_SUPPLY = 223;
1125     uint256 tokenPrice = 0.05 ether;
1126     uint256 public totalFreeSupply = 0;
1127     uint256 totalPublicSupply = 0;
1128     uint256 totalReserved = 0;
1129     mapping (address => bool) hasUserFreeMinted; 
1130     mapping (address => uint256) userReserveCount; 
1131     address public treasury = 0x1958E5D7477ed777390e7034A9CC9719632838C3;
1132     bool public isMintingOn = false;
1133     uint256 MAX_MINT_COUNT = 8;
1134     uint256 MAX_FREE_MINT_COUNT = 2;
1135 
1136     constructor() ERC721("Gator Raid", "GTR") {
1137     }
1138 
1139     function withdraw() external onlyOwner {
1140         uint256 balance = address(this).balance;
1141         payable(treasury).transfer(balance);
1142     }
1143 
1144     function setBaseURI(string memory base) external onlyOwner {
1145         baseURI = base;
1146     }
1147 
1148     function switchMintingStatus() external onlyOwner {
1149         isMintingOn = !isMintingOn;
1150     }
1151 
1152     function updateTreasury(address _treasury) external onlyOwner {
1153         treasury = _treasury;
1154     }
1155 
1156     function _baseURI() internal view virtual override returns (string memory) {
1157         return baseURI;
1158     }
1159 
1160     function setReserve(address recipient, uint256 count) external onlyOwner {
1161      userReserveCount[recipient] = count;
1162     }
1163 
1164     function changePrice(uint256 price) external onlyOwner {
1165      tokenPrice = price;
1166     }
1167 
1168 
1169 
1170     // function mint(uint256 count) external payable {
1171     //     require(isMintingOn , "minting not started");
1172     //     require(count < MAX_MINT_COUNT, "Max Mint per Txn exceeded");
1173     //     require(totalPublicSupply + count < MAX_SUPPLY, "All testnets have already been minted!");
1174     //     require(tokenPrice * count == msg.value, "Insufficient / Incorrect Funds");
1175     //     for (uint256 i =0 ;i < count + 1 ; i++){
1176     //     _safeMint(msg.sender, totalPublicSupply + i);
1177     //     }
1178     //     totalPublicSupply += count;
1179     // }
1180 
1181     function mint(uint256 freeCount, uint256 paidCount) external payable {
1182         require(isMintingOn , "minting not started");
1183         uint256 count = freeCount + paidCount;
1184         // Total
1185         require(count < MAX_MINT_COUNT, "Max Mint per Txn exceeded");
1186         // Free
1187         require (hasUserFreeMinted[msg.sender] == false || freeCount == 0 , "user already free minted");
1188         require (freeCount < MAX_FREE_MINT_COUNT , "free mints exceed count");
1189         require(totalFreeSupply + freeCount < MAX_FREE_SUPPLY , "free mints exceed supply");
1190         // Paid
1191         require(tokenPrice * paidCount == msg.value, "Insufficient / Incorrect Funds");
1192         require (totalPublicSupply + count < MAX_SUPPLY ,"All testnets have already been minted!");
1193 
1194         for (uint256 i =1 ;i < count + 1 ; i++){
1195         _safeMint(msg.sender, totalPublicSupply + i);
1196         }
1197         totalFreeSupply +=freeCount;
1198         totalPublicSupply +=count;
1199         hasUserFreeMinted[msg.sender] = freeCount > 0 && hasUserFreeMinted[msg.sender] == false;
1200     }
1201 
1202     function giftMint(address recipient, uint256 count) external onlyOwner{
1203         require(totalReserved + count < MAX_RESERVED_SUPPLY, "All testnets have already been minted!");
1204        // i = 0 because max supply already has +1 
1205         for (uint256 i =1 ;i < count +1;i++){
1206         _safeMint(recipient, MAX_SUPPLY-1 +totalReserved + i);
1207         }
1208         totalReserved += count;
1209     }
1210 
1211     function reserveMint(uint256 count) external {
1212         require(count < userReserveCount[msg.sender], "Not enought testnets reserved!");
1213         require(totalReserved + count < MAX_RESERVED_SUPPLY, "All testnets have already been minted!");
1214         // i = 0 because max supply already has +1 
1215         for (uint256 i =1 ; i < count  +1; i++){
1216         _safeMint(msg.sender, MAX_SUPPLY -1 +totalReserved + i);
1217         }
1218         totalReserved += count;
1219         userReserveCount[msg.sender] -= count;
1220     }
1221 
1222     function totalSupply() external view returns (uint256) {
1223         return totalPublicSupply + totalReserved;
1224     }
1225 
1226     function isFreeMintOn() external view returns (bool) {
1227         return totalFreeSupply < MAX_FREE_SUPPLY;
1228     }
1229 
1230     function canUserFreeMint() external view returns (bool) {
1231         return totalFreeSupply + 1 < MAX_FREE_SUPPLY && hasUserFreeMinted[msg.sender] != true;
1232     }
1233 
1234     function tokenURI(uint256 tokenId) public view virtual override(ERC721) returns (string memory) {
1235         return super.tokenURI(tokenId);
1236     }
1237 
1238     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721) {
1239         super._beforeTokenTransfer(from, to, tokenId);
1240     }
1241 
1242     function _burn(uint256 tokenId) internal override(ERC721) {
1243         super._burn(tokenId);
1244     }
1245 
1246     function burnMany(uint256 startTokenId , uint256 endTokenId) public onlyOwner {
1247        for (uint256 i =startTokenId ;i < endTokenId ; i++){ 
1248         _burn(i);
1249        }
1250     }
1251 
1252     function supportsInterface(bytes4 interfaceId) public view override(ERC721) returns (bool) {
1253         return super.supportsInterface(interfaceId);
1254     }
1255 }