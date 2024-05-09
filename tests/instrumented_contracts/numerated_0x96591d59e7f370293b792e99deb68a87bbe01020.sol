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
635 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
636 
637 
638 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 
643 /**
644  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
645  * @dev See https://eips.ethereum.org/EIPS/eip-721
646  */
647 interface IERC721Enumerable is IERC721 {
648     /**
649      * @dev Returns the total amount of tokens stored by the contract.
650      */
651     function totalSupply() external view returns (uint256);
652 
653     /**
654      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
655      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
656      */
657     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
658 
659     /**
660      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
661      * Use along with {totalSupply} to enumerate all tokens.
662      */
663     function tokenByIndex(uint256 index) external view returns (uint256);
664 }
665 
666 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 
674 /**
675  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
676  * @dev See https://eips.ethereum.org/EIPS/eip-721
677  */
678 interface IERC721Metadata is IERC721 {
679     /**
680      * @dev Returns the token collection name.
681      */
682     function name() external view returns (string memory);
683 
684     /**
685      * @dev Returns the token collection symbol.
686      */
687     function symbol() external view returns (string memory);
688 
689     /**
690      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
691      */
692     function tokenURI(uint256 tokenId) external view returns (string memory);
693 }
694 
695 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
696 
697 
698 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
699 
700 pragma solidity ^0.8.0;
701 
702 
703 
704 
705 
706 
707 
708 
709 /**
710  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
711  * the Metadata extension, but not including the Enumerable extension, which is available separately as
712  * {ERC721Enumerable}.
713  */
714 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
715     using Address for address;
716     using Strings for uint256;
717 
718     // Token name
719     string private _name;
720 
721     // Token symbol
722     string private _symbol;
723 
724     // Mapping from token ID to owner address
725     mapping(uint256 => address) private _owners;
726 
727     // Mapping owner address to token count
728     mapping(address => uint256) private _balances;
729 
730     // Mapping from token ID to approved address
731     mapping(uint256 => address) private _tokenApprovals;
732 
733     // Mapping from owner to operator approvals
734     mapping(address => mapping(address => bool)) private _operatorApprovals;
735 
736     /**
737      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
738      */
739     constructor(string memory name_, string memory symbol_) {
740         _name = name_;
741         _symbol = symbol_;
742     }
743 
744     /**
745      * @dev See {IERC165-supportsInterface}.
746      */
747     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
748         return
749             interfaceId == type(IERC721).interfaceId ||
750             interfaceId == type(IERC721Metadata).interfaceId ||
751             super.supportsInterface(interfaceId);
752     }
753 
754     /**
755      * @dev See {IERC721-balanceOf}.
756      */
757     function balanceOf(address owner) public view virtual override returns (uint256) {
758         require(owner != address(0), "ERC721: balance query for the zero address");
759         return _balances[owner];
760     }
761 
762     /**
763      * @dev See {IERC721-ownerOf}.
764      */
765     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
766         address owner = _owners[tokenId];
767         require(owner != address(0), "ERC721: owner query for nonexistent token");
768         return owner;
769     }
770 
771     /**
772      * @dev See {IERC721Metadata-name}.
773      */
774     function name() public view virtual override returns (string memory) {
775         return _name;
776     }
777 
778     /**
779      * @dev See {IERC721Metadata-symbol}.
780      */
781     function symbol() public view virtual override returns (string memory) {
782         return _symbol;
783     }
784 
785     /**
786      * @dev See {IERC721Metadata-tokenURI}.
787      */
788     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
789         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
790 
791         string memory baseURI = _baseURI();
792         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
793     }
794 
795     /**
796      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
797      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
798      * by default, can be overriden in child contracts.
799      */
800     function _baseURI() internal view virtual returns (string memory) {
801         return "";
802     }
803 
804     /**
805      * @dev See {IERC721-approve}.
806      */
807     function approve(address to, uint256 tokenId) public virtual override {
808         address owner = ERC721.ownerOf(tokenId);
809         require(to != owner, "ERC721: approval to current owner");
810 
811         require(
812             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
813             "ERC721: approve caller is not owner nor approved for all"
814         );
815 
816         _approve(to, tokenId);
817     }
818 
819     /**
820      * @dev See {IERC721-getApproved}.
821      */
822     function getApproved(uint256 tokenId) public view virtual override returns (address) {
823         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
824 
825         return _tokenApprovals[tokenId];
826     }
827 
828     /**
829      * @dev See {IERC721-setApprovalForAll}.
830      */
831     function setApprovalForAll(address operator, bool approved) public virtual override {
832         _setApprovalForAll(_msgSender(), operator, approved);
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
985 
986         _afterTokenTransfer(address(0), to, tokenId);
987     }
988 
989     /**
990      * @dev Destroys `tokenId`.
991      * The approval is cleared when the token is burned.
992      *
993      * Requirements:
994      *
995      * - `tokenId` must exist.
996      *
997      * Emits a {Transfer} event.
998      */
999     function _burn(uint256 tokenId) internal virtual {
1000         address owner = ERC721.ownerOf(tokenId);
1001 
1002         _beforeTokenTransfer(owner, address(0), tokenId);
1003 
1004         // Clear approvals
1005         _approve(address(0), tokenId);
1006 
1007         _balances[owner] -= 1;
1008         delete _owners[tokenId];
1009 
1010         emit Transfer(owner, address(0), tokenId);
1011 
1012         _afterTokenTransfer(owner, address(0), tokenId);
1013     }
1014 
1015     /**
1016      * @dev Transfers `tokenId` from `from` to `to`.
1017      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1018      *
1019      * Requirements:
1020      *
1021      * - `to` cannot be the zero address.
1022      * - `tokenId` token must be owned by `from`.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function _transfer(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) internal virtual {
1031         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1032         require(to != address(0), "ERC721: transfer to the zero address");
1033 
1034         _beforeTokenTransfer(from, to, tokenId);
1035 
1036         // Clear approvals from the previous owner
1037         _approve(address(0), tokenId);
1038 
1039         _balances[from] -= 1;
1040         _balances[to] += 1;
1041         _owners[tokenId] = to;
1042 
1043         emit Transfer(from, to, tokenId);
1044 
1045         _afterTokenTransfer(from, to, tokenId);
1046     }
1047 
1048     /**
1049      * @dev Approve `to` to operate on `tokenId`
1050      *
1051      * Emits a {Approval} event.
1052      */
1053     function _approve(address to, uint256 tokenId) internal virtual {
1054         _tokenApprovals[tokenId] = to;
1055         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1056     }
1057 
1058     /**
1059      * @dev Approve `operator` to operate on all of `owner` tokens
1060      *
1061      * Emits a {ApprovalForAll} event.
1062      */
1063     function _setApprovalForAll(
1064         address owner,
1065         address operator,
1066         bool approved
1067     ) internal virtual {
1068         require(owner != operator, "ERC721: approve to caller");
1069         _operatorApprovals[owner][operator] = approved;
1070         emit ApprovalForAll(owner, operator, approved);
1071     }
1072 
1073     /**
1074      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1075      * The call is not executed if the target address is not a contract.
1076      *
1077      * @param from address representing the previous owner of the given token ID
1078      * @param to target address that will receive the tokens
1079      * @param tokenId uint256 ID of the token to be transferred
1080      * @param _data bytes optional data to send along with the call
1081      * @return bool whether the call correctly returned the expected magic value
1082      */
1083     function _checkOnERC721Received(
1084         address from,
1085         address to,
1086         uint256 tokenId,
1087         bytes memory _data
1088     ) private returns (bool) {
1089         if (to.isContract()) {
1090             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1091                 return retval == IERC721Receiver.onERC721Received.selector;
1092             } catch (bytes memory reason) {
1093                 if (reason.length == 0) {
1094                     revert("ERC721: transfer to non ERC721Receiver implementer");
1095                 } else {
1096                     assembly {
1097                         revert(add(32, reason), mload(reason))
1098                     }
1099                 }
1100             }
1101         } else {
1102             return true;
1103         }
1104     }
1105 
1106     /**
1107      * @dev Hook that is called before any token transfer. This includes minting
1108      * and burning.
1109      *
1110      * Calling conditions:
1111      *
1112      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1113      * transferred to `to`.
1114      * - When `from` is zero, `tokenId` will be minted for `to`.
1115      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1116      * - `from` and `to` are never both zero.
1117      *
1118      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1119      */
1120     function _beforeTokenTransfer(
1121         address from,
1122         address to,
1123         uint256 tokenId
1124     ) internal virtual {}
1125 
1126     /**
1127      * @dev Hook that is called after any transfer of tokens. This includes
1128      * minting and burning.
1129      *
1130      * Calling conditions:
1131      *
1132      * - when `from` and `to` are both non-zero.
1133      * - `from` and `to` are never both zero.
1134      *
1135      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1136      */
1137     function _afterTokenTransfer(
1138         address from,
1139         address to,
1140         uint256 tokenId
1141     ) internal virtual {}
1142 }
1143 
1144 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1145 
1146 
1147 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1148 
1149 pragma solidity ^0.8.0;
1150 
1151 
1152 
1153 /**
1154  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1155  * enumerability of all the token ids in the contract as well as all token ids owned by each
1156  * account.
1157  */
1158 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1159     // Mapping from owner to list of owned token IDs
1160     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1161 
1162     // Mapping from token ID to index of the owner tokens list
1163     mapping(uint256 => uint256) private _ownedTokensIndex;
1164 
1165     // Array with all token ids, used for enumeration
1166     uint256[] private _allTokens;
1167 
1168     // Mapping from token id to position in the allTokens array
1169     mapping(uint256 => uint256) private _allTokensIndex;
1170 
1171     /**
1172      * @dev See {IERC165-supportsInterface}.
1173      */
1174     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1175         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1176     }
1177 
1178     /**
1179      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1180      */
1181     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1182         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1183         return _ownedTokens[owner][index];
1184     }
1185 
1186     /**
1187      * @dev See {IERC721Enumerable-totalSupply}.
1188      */
1189     function totalSupply() public view virtual override returns (uint256) {
1190         return _allTokens.length;
1191     }
1192 
1193     /**
1194      * @dev See {IERC721Enumerable-tokenByIndex}.
1195      */
1196     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1197         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1198         return _allTokens[index];
1199     }
1200 
1201     /**
1202      * @dev Hook that is called before any token transfer. This includes minting
1203      * and burning.
1204      *
1205      * Calling conditions:
1206      *
1207      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1208      * transferred to `to`.
1209      * - When `from` is zero, `tokenId` will be minted for `to`.
1210      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1211      * - `from` cannot be the zero address.
1212      * - `to` cannot be the zero address.
1213      *
1214      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1215      */
1216     function _beforeTokenTransfer(
1217         address from,
1218         address to,
1219         uint256 tokenId
1220     ) internal virtual override {
1221         super._beforeTokenTransfer(from, to, tokenId);
1222 
1223         if (from == address(0)) {
1224             _addTokenToAllTokensEnumeration(tokenId);
1225         } else if (from != to) {
1226             _removeTokenFromOwnerEnumeration(from, tokenId);
1227         }
1228         if (to == address(0)) {
1229             _removeTokenFromAllTokensEnumeration(tokenId);
1230         } else if (to != from) {
1231             _addTokenToOwnerEnumeration(to, tokenId);
1232         }
1233     }
1234 
1235     /**
1236      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1237      * @param to address representing the new owner of the given token ID
1238      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1239      */
1240     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1241         uint256 length = ERC721.balanceOf(to);
1242         _ownedTokens[to][length] = tokenId;
1243         _ownedTokensIndex[tokenId] = length;
1244     }
1245 
1246     /**
1247      * @dev Private function to add a token to this extension's token tracking data structures.
1248      * @param tokenId uint256 ID of the token to be added to the tokens list
1249      */
1250     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1251         _allTokensIndex[tokenId] = _allTokens.length;
1252         _allTokens.push(tokenId);
1253     }
1254 
1255     /**
1256      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1257      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1258      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1259      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1260      * @param from address representing the previous owner of the given token ID
1261      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1262      */
1263     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1264         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1265         // then delete the last slot (swap and pop).
1266 
1267         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1268         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1269 
1270         // When the token to delete is the last token, the swap operation is unnecessary
1271         if (tokenIndex != lastTokenIndex) {
1272             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1273 
1274             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1275             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1276         }
1277 
1278         // This also deletes the contents at the last position of the array
1279         delete _ownedTokensIndex[tokenId];
1280         delete _ownedTokens[from][lastTokenIndex];
1281     }
1282 
1283     /**
1284      * @dev Private function to remove a token from this extension's token tracking data structures.
1285      * This has O(1) time complexity, but alters the order of the _allTokens array.
1286      * @param tokenId uint256 ID of the token to be removed from the tokens list
1287      */
1288     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1289         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1290         // then delete the last slot (swap and pop).
1291 
1292         uint256 lastTokenIndex = _allTokens.length - 1;
1293         uint256 tokenIndex = _allTokensIndex[tokenId];
1294 
1295         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1296         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1297         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1298         uint256 lastTokenId = _allTokens[lastTokenIndex];
1299 
1300         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1301         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1302 
1303         // This also deletes the contents at the last position of the array
1304         delete _allTokensIndex[tokenId];
1305         _allTokens.pop();
1306     }
1307 }
1308 
1309 // File: contracts/FireTheBoss.sol
1310 
1311 // Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
1312 
1313 pragma solidity ^0.8.7;
1314 
1315 
1316 
1317 
1318 contract FIRETHEBOSS is ERC721Enumerable, Ownable {
1319     using Strings for uint256;
1320 
1321     bool public _isSaleActive = false;
1322 
1323     // Constants
1324     uint256 public constant MAX_SUPPLY = 1039;
1325     uint256 public constant TEAM_RESERVE = 9;
1326     uint256 public earlyPassBalance = 122;
1327     uint256 public eventBalance = 20;
1328     uint256 public publicMintBalance = 888;
1329     uint256 public mintPrice = 0.25 ether;
1330     uint256 public roundBalance = 0;
1331     uint256 public maxMint = 5;
1332 
1333     string baseURI;
1334     string public baseExtension = ".json";
1335 
1336     mapping(uint256 => string) private _tokenURIs;
1337 
1338     constructor(string memory initBaseURI)
1339         ERC721("FIRE THE BOSS", "FTB")
1340     {
1341         setBaseURI(initBaseURI);
1342         // Team Reservation
1343         for (uint256 i = 0; i < TEAM_RESERVE; i++) {
1344             _safeMint(0x9Cc5d37D2053dBa7e6255068d127C1Eaaad2199F, i);
1345         }
1346     }
1347 
1348     function mintFTB(uint256 mintBalance) public payable {
1349         require(msg.sender == tx.origin, "Should not mint through contracts");
1350         require(_isSaleActive, "Sale is not active now");
1351         require(totalSupply() + mintBalance <= MAX_SUPPLY, "exceed max supply");
1352         require(mintBalance <= roundBalance, "exceed round balance");
1353         require(mintBalance <= publicMintBalance, "No enough public mint quata");
1354         require(mintBalance <= maxMint, "exceed max mint per time");
1355         require(mintBalance * mintPrice <= msg.value, "Not enough ether");
1356 
1357         roundBalance -= mintBalance;
1358         publicMintBalance -= mintBalance;
1359         _mintFTB(msg.sender, mintBalance);
1360     }
1361 
1362     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1363         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1364 
1365         string memory _tokenURI = _tokenURIs[tokenId];
1366         string memory base = _baseURI();
1367 
1368         // If there is no base URI, return the token URI.
1369         if (bytes(base).length == 0) {
1370             return _tokenURI;
1371         }
1372         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1373         if (bytes(_tokenURI).length > 0) {
1374             return string(abi.encodePacked(base, _tokenURI));
1375         }
1376         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1377         return string(abi.encodePacked(base, tokenId.toString(), baseExtension));
1378     }
1379 
1380     // internal Functions
1381     function _baseURI() internal view virtual override returns (string memory) {
1382         return baseURI;
1383     }
1384 
1385     function _mintFTB(address to, uint256 mintBalance) internal {
1386         for (uint256 i = 0; i < mintBalance; i++) {
1387             uint256 mintIndex = totalSupply();
1388             if (totalSupply() < MAX_SUPPLY) {
1389                 _safeMint(to, mintIndex);
1390             }
1391         }
1392     }
1393 
1394     // onlyOwner Functions
1395 
1396     // Airdrop for Influencers and Events, limited 1 per time
1397     function airdropEvent(address to) public onlyOwner {
1398         require(totalSupply() + 1 <= MAX_SUPPLY, "Airdrop would exceed max supply");
1399         require(eventBalance - 1 >= 0, "No more airdrop quota");
1400 
1401         eventBalance -= 1;
1402         _mintFTB(to, 1);
1403     }
1404 
1405     // Airdrop for Early Pass and Dessert Shop
1406     function airdropEarlyPass(address to, uint256 airdropBalance) public onlyOwner {
1407         require(totalSupply() + airdropBalance <= MAX_SUPPLY, "Airdrop would exceed max supply");
1408         require(earlyPassBalance - airdropBalance >= 0, "No more airdrop quota");
1409 
1410         earlyPassBalance -= airdropBalance;
1411         _mintFTB(to, airdropBalance);
1412     }
1413 
1414     function flipSaleState() public onlyOwner {
1415         _isSaleActive = !_isSaleActive;
1416     }
1417 
1418     function setRoundBalance(uint256 _roundBalance) public onlyOwner {
1419         roundBalance = _roundBalance;
1420     }
1421 
1422     function setMintPrice(uint256 _mintPrice) public onlyOwner {
1423         mintPrice = _mintPrice;
1424     }
1425 
1426     function setMaxMint(uint256 _maxMint) public onlyOwner {
1427         maxMint = _maxMint;
1428     }
1429 
1430     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1431         baseURI = _newBaseURI;
1432     }
1433 
1434     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1435         baseExtension = _newBaseExtension;
1436     }
1437 
1438     function withdraw(address to) public onlyOwner {
1439         uint256 balance = address(this).balance;
1440         payable(to).transfer(balance);
1441     }
1442 }