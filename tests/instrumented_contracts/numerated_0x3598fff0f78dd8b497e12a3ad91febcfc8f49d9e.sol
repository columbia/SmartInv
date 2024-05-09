1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
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
74 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
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
101 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
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
179 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
180 
181 pragma solidity ^0.8.0;
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
203      */
204     function isContract(address account) internal view returns (bool) {
205         // This method relies on extcodesize, which returns 0 for contracts in
206         // construction, since the code is only stored at the end of the
207         // constructor execution.
208 
209         uint256 size;
210         assembly {
211             size := extcodesize(account)
212         }
213         return size > 0;
214     }
215 
216     /**
217      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
218      * `recipient`, forwarding all available gas and reverting on errors.
219      *
220      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
221      * of certain opcodes, possibly making contracts go over the 2300 gas limit
222      * imposed by `transfer`, making them unable to receive funds via
223      * `transfer`. {sendValue} removes this limitation.
224      *
225      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
226      *
227      * IMPORTANT: because control is transferred to `recipient`, care must be
228      * taken to not create reentrancy vulnerabilities. Consider using
229      * {ReentrancyGuard} or the
230      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
231      */
232     function sendValue(address payable recipient, uint256 amount) internal {
233         require(address(this).balance >= amount, "Address: insufficient balance");
234 
235         (bool success, ) = recipient.call{value: amount}("");
236         require(success, "Address: unable to send value, recipient may have reverted");
237     }
238 
239     /**
240      * @dev Performs a Solidity function call using a low level `call`. A
241      * plain `call` is an unsafe replacement for a function call: use this
242      * function instead.
243      *
244      * If `target` reverts with a revert reason, it is bubbled up by this
245      * function (like regular Solidity function calls).
246      *
247      * Returns the raw returned data. To convert to the expected return value,
248      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
249      *
250      * Requirements:
251      *
252      * - `target` must be a contract.
253      * - calling `target` with `data` must not revert.
254      *
255      * _Available since v3.1._
256      */
257     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
258         return functionCall(target, data, "Address: low-level call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
263      * `errorMessage` as a fallback revert reason when `target` reverts.
264      *
265      * _Available since v3.1._
266      */
267     function functionCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         return functionCallWithValue(target, data, 0, errorMessage);
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
277      * but also transferring `value` wei to `target`.
278      *
279      * Requirements:
280      *
281      * - the calling contract must have an ETH balance of at least `value`.
282      * - the called Solidity function must be `payable`.
283      *
284      * _Available since v3.1._
285      */
286     function functionCallWithValue(
287         address target,
288         bytes memory data,
289         uint256 value
290     ) internal returns (bytes memory) {
291         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
296      * with `errorMessage` as a fallback revert reason when `target` reverts.
297      *
298      * _Available since v3.1._
299      */
300     function functionCallWithValue(
301         address target,
302         bytes memory data,
303         uint256 value,
304         string memory errorMessage
305     ) internal returns (bytes memory) {
306         require(address(this).balance >= value, "Address: insufficient balance for call");
307         require(isContract(target), "Address: call to non-contract");
308 
309         (bool success, bytes memory returndata) = target.call{value: value}(data);
310         return verifyCallResult(success, returndata, errorMessage);
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
315      * but performing a static call.
316      *
317      * _Available since v3.3._
318      */
319     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
320         return functionStaticCall(target, data, "Address: low-level static call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
325      * but performing a static call.
326      *
327      * _Available since v3.3._
328      */
329     function functionStaticCall(
330         address target,
331         bytes memory data,
332         string memory errorMessage
333     ) internal view returns (bytes memory) {
334         require(isContract(target), "Address: static call to non-contract");
335 
336         (bool success, bytes memory returndata) = target.staticcall(data);
337         return verifyCallResult(success, returndata, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but performing a delegate call.
343      *
344      * _Available since v3.4._
345      */
346     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
347         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
352      * but performing a delegate call.
353      *
354      * _Available since v3.4._
355      */
356     function functionDelegateCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         require(isContract(target), "Address: delegate call to non-contract");
362 
363         (bool success, bytes memory returndata) = target.delegatecall(data);
364         return verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
369      * revert reason using the provided one.
370      *
371      * _Available since v4.3._
372      */
373     function verifyCallResult(
374         bool success,
375         bytes memory returndata,
376         string memory errorMessage
377     ) internal pure returns (bytes memory) {
378         if (success) {
379             return returndata;
380         } else {
381             // Look for revert reason and bubble it up if present
382             if (returndata.length > 0) {
383                 // The easiest way to bubble the revert reason is using memory via assembly
384 
385                 assembly {
386                     let returndata_size := mload(returndata)
387                     revert(add(32, returndata), returndata_size)
388                 }
389             } else {
390                 revert(errorMessage);
391             }
392         }
393     }
394 }
395 
396 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
397 
398 
399 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 /**
404  * @title ERC721 token receiver interface
405  * @dev Interface for any contract that wants to support safeTransfers
406  * from ERC721 asset contracts.
407  */
408 interface IERC721Receiver {
409     /**
410      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
411      * by `operator` from `from`, this function is called.
412      *
413      * It must return its Solidity selector to confirm the token transfer.
414      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
415      *
416      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
417      */
418     function onERC721Received(
419         address operator,
420         address from,
421         uint256 tokenId,
422         bytes calldata data
423     ) external returns (bytes4);
424 }
425 
426 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
427 
428 
429 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
430 
431 pragma solidity ^0.8.0;
432 
433 /**
434  * @dev Interface of the ERC165 standard, as defined in the
435  * https://eips.ethereum.org/EIPS/eip-165[EIP].
436  *
437  * Implementers can declare support of contract interfaces, which can then be
438  * queried by others ({ERC165Checker}).
439  *
440  * For an implementation, see {ERC165}.
441  */
442 interface IERC165 {
443     /**
444      * @dev Returns true if this contract implements the interface defined by
445      * `interfaceId`. See the corresponding
446      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
447      * to learn more about how these ids are created.
448      *
449      * This function call must use less than 30 000 gas.
450      */
451     function supportsInterface(bytes4 interfaceId) external view returns (bool);
452 }
453 
454 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
455 
456 
457 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 
462 /**
463  * @dev Implementation of the {IERC165} interface.
464  *
465  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
466  * for the additional interface id that will be supported. For example:
467  *
468  * ```solidity
469  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
470  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
471  * }
472  * ```
473  *
474  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
475  */
476 abstract contract ERC165 is IERC165 {
477     /**
478      * @dev See {IERC165-supportsInterface}.
479      */
480     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
481         return interfaceId == type(IERC165).interfaceId;
482     }
483 }
484 
485 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
486 
487 
488 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
489 
490 pragma solidity ^0.8.0;
491 
492 
493 /**
494  * @dev Required interface of an ERC721 compliant contract.
495  */
496 interface IERC721 is IERC165 {
497     /**
498      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
499      */
500     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
501 
502     /**
503      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
504      */
505     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
506 
507     /**
508      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
509      */
510     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
511 
512     /**
513      * @dev Returns the number of tokens in ``owner``'s account.
514      */
515     function balanceOf(address owner) external view returns (uint256 balance);
516 
517     /**
518      * @dev Returns the owner of the `tokenId` token.
519      *
520      * Requirements:
521      *
522      * - `tokenId` must exist.
523      */
524     function ownerOf(uint256 tokenId) external view returns (address owner);
525 
526     /**
527      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
528      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
529      *
530      * Requirements:
531      *
532      * - `from` cannot be the zero address.
533      * - `to` cannot be the zero address.
534      * - `tokenId` token must exist and be owned by `from`.
535      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
536      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
537      *
538      * Emits a {Transfer} event.
539      */
540     function safeTransferFrom(
541         address from,
542         address to,
543         uint256 tokenId
544     ) external;
545 
546     /**
547      * @dev Transfers `tokenId` token from `from` to `to`.
548      *
549      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
550      *
551      * Requirements:
552      *
553      * - `from` cannot be the zero address.
554      * - `to` cannot be the zero address.
555      * - `tokenId` token must be owned by `from`.
556      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
557      *
558      * Emits a {Transfer} event.
559      */
560     function transferFrom(
561         address from,
562         address to,
563         uint256 tokenId
564     ) external;
565 
566     /**
567      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
568      * The approval is cleared when the token is transferred.
569      *
570      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
571      *
572      * Requirements:
573      *
574      * - The caller must own the token or be an approved operator.
575      * - `tokenId` must exist.
576      *
577      * Emits an {Approval} event.
578      */
579     function approve(address to, uint256 tokenId) external;
580 
581     /**
582      * @dev Returns the account approved for `tokenId` token.
583      *
584      * Requirements:
585      *
586      * - `tokenId` must exist.
587      */
588     function getApproved(uint256 tokenId) external view returns (address operator);
589 
590     /**
591      * @dev Approve or remove `operator` as an operator for the caller.
592      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
593      *
594      * Requirements:
595      *
596      * - The `operator` cannot be the caller.
597      *
598      * Emits an {ApprovalForAll} event.
599      */
600     function setApprovalForAll(address operator, bool _approved) external;
601 
602     /**
603      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
604      *
605      * See {setApprovalForAll}
606      */
607     function isApprovedForAll(address owner, address operator) external view returns (bool);
608 
609     /**
610      * @dev Safely transfers `tokenId` token from `from` to `to`.
611      *
612      * Requirements:
613      *
614      * - `from` cannot be the zero address.
615      * - `to` cannot be the zero address.
616      * - `tokenId` token must exist and be owned by `from`.
617      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
618      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
619      *
620      * Emits a {Transfer} event.
621      */
622     function safeTransferFrom(
623         address from,
624         address to,
625         uint256 tokenId,
626         bytes calldata data
627     ) external;
628 }
629 
630 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
631 
632 
633 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
634 
635 pragma solidity ^0.8.0;
636 
637 
638 /**
639  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
640  * @dev See https://eips.ethereum.org/EIPS/eip-721
641  */
642 interface IERC721Enumerable is IERC721 {
643     /**
644      * @dev Returns the total amount of tokens stored by the contract.
645      */
646     function totalSupply() external view returns (uint256);
647 
648     /**
649      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
650      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
651      */
652     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
653 
654     /**
655      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
656      * Use along with {totalSupply} to enumerate all tokens.
657      */
658     function tokenByIndex(uint256 index) external view returns (uint256);
659 }
660 
661 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
662 
663 
664 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
665 
666 pragma solidity ^0.8.0;
667 
668 
669 /**
670  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
671  * @dev See https://eips.ethereum.org/EIPS/eip-721
672  */
673 interface IERC721Metadata is IERC721 {
674     /**
675      * @dev Returns the token collection name.
676      */
677     function name() external view returns (string memory);
678 
679     /**
680      * @dev Returns the token collection symbol.
681      */
682     function symbol() external view returns (string memory);
683 
684     /**
685      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
686      */
687     function tokenURI(uint256 tokenId) external view returns (string memory);
688 }
689 
690 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
691 
692 
693 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
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
827         _setApprovalForAll(_msgSender(), operator, approved);
828     }
829 
830     /**
831      * @dev See {IERC721-isApprovedForAll}.
832      */
833     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
834         return _operatorApprovals[owner][operator];
835     }
836 
837     /**
838      * @dev See {IERC721-transferFrom}.
839      */
840     function transferFrom(
841         address from,
842         address to,
843         uint256 tokenId
844     ) public virtual override {
845         //solhint-disable-next-line max-line-length
846         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
847 
848         _transfer(from, to, tokenId);
849     }
850 
851     /**
852      * @dev See {IERC721-safeTransferFrom}.
853      */
854     function safeTransferFrom(
855         address from,
856         address to,
857         uint256 tokenId
858     ) public virtual override {
859         safeTransferFrom(from, to, tokenId, "");
860     }
861 
862     /**
863      * @dev See {IERC721-safeTransferFrom}.
864      */
865     function safeTransferFrom(
866         address from,
867         address to,
868         uint256 tokenId,
869         bytes memory _data
870     ) public virtual override {
871         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
872         _safeTransfer(from, to, tokenId, _data);
873     }
874 
875     /**
876      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
877      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
878      *
879      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
880      *
881      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
882      * implement alternative mechanisms to perform token transfer, such as signature-based.
883      *
884      * Requirements:
885      *
886      * - `from` cannot be the zero address.
887      * - `to` cannot be the zero address.
888      * - `tokenId` token must exist and be owned by `from`.
889      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
890      *
891      * Emits a {Transfer} event.
892      */
893     function _safeTransfer(
894         address from,
895         address to,
896         uint256 tokenId,
897         bytes memory _data
898     ) internal virtual {
899         _transfer(from, to, tokenId);
900         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
901     }
902 
903     /**
904      * @dev Returns whether `tokenId` exists.
905      *
906      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
907      *
908      * Tokens start existing when they are minted (`_mint`),
909      * and stop existing when they are burned (`_burn`).
910      */
911     function _exists(uint256 tokenId) internal view virtual returns (bool) {
912         return _owners[tokenId] != address(0);
913     }
914 
915     /**
916      * @dev Returns whether `spender` is allowed to manage `tokenId`.
917      *
918      * Requirements:
919      *
920      * - `tokenId` must exist.
921      */
922     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
923         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
924         address owner = ERC721.ownerOf(tokenId);
925         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
926     }
927 
928     /**
929      * @dev Safely mints `tokenId` and transfers it to `to`.
930      *
931      * Requirements:
932      *
933      * - `tokenId` must not exist.
934      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
935      *
936      * Emits a {Transfer} event.
937      */
938     function _safeMint(address to, uint256 tokenId) internal virtual {
939         _safeMint(to, tokenId, "");
940     }
941 
942     /**
943      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
944      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
945      */
946     function _safeMint(
947         address to,
948         uint256 tokenId,
949         bytes memory _data
950     ) internal virtual {
951         _mint(to, tokenId);
952         require(
953             _checkOnERC721Received(address(0), to, tokenId, _data),
954             "ERC721: transfer to non ERC721Receiver implementer"
955         );
956     }
957 
958     /**
959      * @dev Mints `tokenId` and transfers it to `to`.
960      *
961      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
962      *
963      * Requirements:
964      *
965      * - `tokenId` must not exist.
966      * - `to` cannot be the zero address.
967      *
968      * Emits a {Transfer} event.
969      */
970     function _mint(address to, uint256 tokenId) internal virtual {
971         require(to != address(0), "ERC721: mint to the zero address");
972         require(!_exists(tokenId), "ERC721: token already minted");
973 
974         _beforeTokenTransfer(address(0), to, tokenId);
975 
976         _balances[to] += 1;
977         _owners[tokenId] = to;
978 
979         emit Transfer(address(0), to, tokenId);
980     }
981 
982     /**
983      * @dev Destroys `tokenId`.
984      * The approval is cleared when the token is burned.
985      *
986      * Requirements:
987      *
988      * - `tokenId` must exist.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _burn(uint256 tokenId) internal virtual {
993         address owner = ERC721.ownerOf(tokenId);
994 
995         _beforeTokenTransfer(owner, address(0), tokenId);
996 
997         // Clear approvals
998         _approve(address(0), tokenId);
999 
1000         _balances[owner] -= 1;
1001         delete _owners[tokenId];
1002 
1003         emit Transfer(owner, address(0), tokenId);
1004     }
1005 
1006     /**
1007      * @dev Transfers `tokenId` from `from` to `to`.
1008      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1009      *
1010      * Requirements:
1011      *
1012      * - `to` cannot be the zero address.
1013      * - `tokenId` token must be owned by `from`.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _transfer(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) internal virtual {
1022         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1023         require(to != address(0), "ERC721: transfer to the zero address");
1024 
1025         _beforeTokenTransfer(from, to, tokenId);
1026 
1027         // Clear approvals from the previous owner
1028         _approve(address(0), tokenId);
1029 
1030         _balances[from] -= 1;
1031         _balances[to] += 1;
1032         _owners[tokenId] = to;
1033 
1034         emit Transfer(from, to, tokenId);
1035     }
1036 
1037     /**
1038      * @dev Approve `to` to operate on `tokenId`
1039      *
1040      * Emits a {Approval} event.
1041      */
1042     function _approve(address to, uint256 tokenId) internal virtual {
1043         _tokenApprovals[tokenId] = to;
1044         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1045     }
1046 
1047     /**
1048      * @dev Approve `operator` to operate on all of `owner` tokens
1049      *
1050      * Emits a {ApprovalForAll} event.
1051      */
1052     function _setApprovalForAll(
1053         address owner,
1054         address operator,
1055         bool approved
1056     ) internal virtual {
1057         require(owner != operator, "ERC721: approve to caller");
1058         _operatorApprovals[owner][operator] = approved;
1059         emit ApprovalForAll(owner, operator, approved);
1060     }
1061 
1062     /**
1063      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1064      * The call is not executed if the target address is not a contract.
1065      *
1066      * @param from address representing the previous owner of the given token ID
1067      * @param to target address that will receive the tokens
1068      * @param tokenId uint256 ID of the token to be transferred
1069      * @param _data bytes optional data to send along with the call
1070      * @return bool whether the call correctly returned the expected magic value
1071      */
1072     function _checkOnERC721Received(
1073         address from,
1074         address to,
1075         uint256 tokenId,
1076         bytes memory _data
1077     ) private returns (bool) {
1078         if (to.isContract()) {
1079             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1080                 return retval == IERC721Receiver.onERC721Received.selector;
1081             } catch (bytes memory reason) {
1082                 if (reason.length == 0) {
1083                     revert("ERC721: transfer to non ERC721Receiver implementer");
1084                 } else {
1085                     assembly {
1086                         revert(add(32, reason), mload(reason))
1087                     }
1088                 }
1089             }
1090         } else {
1091             return true;
1092         }
1093     }
1094 
1095     /**
1096      * @dev Hook that is called before any token transfer. This includes minting
1097      * and burning.
1098      *
1099      * Calling conditions:
1100      *
1101      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1102      * transferred to `to`.
1103      * - When `from` is zero, `tokenId` will be minted for `to`.
1104      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1105      * - `from` and `to` are never both zero.
1106      *
1107      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1108      */
1109     function _beforeTokenTransfer(
1110         address from,
1111         address to,
1112         uint256 tokenId
1113     ) internal virtual {}
1114 }
1115 
1116 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1117 
1118 
1119 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1120 
1121 pragma solidity ^0.8.0;
1122 
1123 
1124 
1125 /**
1126  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1127  * enumerability of all the token ids in the contract as well as all token ids owned by each
1128  * account.
1129  */
1130 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1131     // Mapping from owner to list of owned token IDs
1132     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1133 
1134     // Mapping from token ID to index of the owner tokens list
1135     mapping(uint256 => uint256) private _ownedTokensIndex;
1136 
1137     // Array with all token ids, used for enumeration
1138     uint256[] private _allTokens;
1139 
1140     // Mapping from token id to position in the allTokens array
1141     mapping(uint256 => uint256) private _allTokensIndex;
1142 
1143     /**
1144      * @dev See {IERC165-supportsInterface}.
1145      */
1146     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1147         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1148     }
1149 
1150     /**
1151      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1152      */
1153     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1154         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1155         return _ownedTokens[owner][index];
1156     }
1157 
1158     /**
1159      * @dev See {IERC721Enumerable-totalSupply}.
1160      */
1161     function totalSupply() public view virtual override returns (uint256) {
1162         return _allTokens.length;
1163     }
1164 
1165     /**
1166      * @dev See {IERC721Enumerable-tokenByIndex}.
1167      */
1168     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1169         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1170         return _allTokens[index];
1171     }
1172 
1173     /**
1174      * @dev Hook that is called before any token transfer. This includes minting
1175      * and burning.
1176      *
1177      * Calling conditions:
1178      *
1179      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1180      * transferred to `to`.
1181      * - When `from` is zero, `tokenId` will be minted for `to`.
1182      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1183      * - `from` cannot be the zero address.
1184      * - `to` cannot be the zero address.
1185      *
1186      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1187      */
1188     function _beforeTokenTransfer(
1189         address from,
1190         address to,
1191         uint256 tokenId
1192     ) internal virtual override {
1193         super._beforeTokenTransfer(from, to, tokenId);
1194 
1195         if (from == address(0)) {
1196             _addTokenToAllTokensEnumeration(tokenId);
1197         } else if (from != to) {
1198             _removeTokenFromOwnerEnumeration(from, tokenId);
1199         }
1200         if (to == address(0)) {
1201             _removeTokenFromAllTokensEnumeration(tokenId);
1202         } else if (to != from) {
1203             _addTokenToOwnerEnumeration(to, tokenId);
1204         }
1205     }
1206 
1207     /**
1208      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1209      * @param to address representing the new owner of the given token ID
1210      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1211      */
1212     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1213         uint256 length = ERC721.balanceOf(to);
1214         _ownedTokens[to][length] = tokenId;
1215         _ownedTokensIndex[tokenId] = length;
1216     }
1217 
1218     /**
1219      * @dev Private function to add a token to this extension's token tracking data structures.
1220      * @param tokenId uint256 ID of the token to be added to the tokens list
1221      */
1222     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1223         _allTokensIndex[tokenId] = _allTokens.length;
1224         _allTokens.push(tokenId);
1225     }
1226 
1227     /**
1228      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1229      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1230      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1231      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1232      * @param from address representing the previous owner of the given token ID
1233      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1234      */
1235     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1236         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1237         // then delete the last slot (swap and pop).
1238 
1239         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1240         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1241 
1242         // When the token to delete is the last token, the swap operation is unnecessary
1243         if (tokenIndex != lastTokenIndex) {
1244             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1245 
1246             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1247             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1248         }
1249 
1250         // This also deletes the contents at the last position of the array
1251         delete _ownedTokensIndex[tokenId];
1252         delete _ownedTokens[from][lastTokenIndex];
1253     }
1254 
1255     /**
1256      * @dev Private function to remove a token from this extension's token tracking data structures.
1257      * This has O(1) time complexity, but alters the order of the _allTokens array.
1258      * @param tokenId uint256 ID of the token to be removed from the tokens list
1259      */
1260     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1261         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1262         // then delete the last slot (swap and pop).
1263 
1264         uint256 lastTokenIndex = _allTokens.length - 1;
1265         uint256 tokenIndex = _allTokensIndex[tokenId];
1266 
1267         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1268         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1269         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1270         uint256 lastTokenId = _allTokens[lastTokenIndex];
1271 
1272         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1273         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1274 
1275         // This also deletes the contents at the last position of the array
1276         delete _allTokensIndex[tokenId];
1277         _allTokens.pop();
1278     }
1279 }
1280 
1281 // File: contracts/nft721.sol
1282 
1283 
1284 pragma solidity ^0.8.0;
1285 
1286 
1287 
1288 contract PJPP is ERC721Enumerable, Ownable {
1289   using Strings for uint256;
1290   string public baseURI;
1291   string public baseExtension = ".json";
1292   uint256 public cost = 0.09 ether;
1293   uint256 public maxSupply = 9999;
1294   uint256 public maxLimitWhitelist = 15;
1295   uint256 public maxLimitNonWhitelist = 10;
1296   bool public paused = false;
1297   bool public revealed = false;
1298   bool public onlyWhiteList = true;
1299   string public notRevealedUri;
1300   mapping(address => bool) public whitelisted;
1301 
1302   constructor(
1303     string memory _name,
1304     string memory _symbol,
1305     string memory _initBaseURI,
1306     string memory _initNotRevealedUri
1307   ) ERC721(_name, _symbol) {
1308     setBaseURI(_initBaseURI);
1309     setNotRevealedURI(_initNotRevealedUri);
1310   }
1311 
1312   function _baseURI() internal view virtual override returns (string memory) {
1313     return baseURI;
1314   }
1315 
1316   function mint(address _to, uint256 _mintAmount) public payable {
1317     uint256 supply = totalSupply();
1318     require(!paused);
1319     require(_mintAmount > 0);
1320     require(supply + _mintAmount <= maxSupply);
1321 
1322     if (msg.sender != owner()) {
1323         
1324         uint256 minted = balanceOf(_to);
1325         if(whitelisted[_to] == true) {
1326             require(maxLimitWhitelist >= minted+_mintAmount, "cannot mint more than limit");
1327         }else{
1328             require(onlyWhiteList==false, "only whitelist addresses can mint");
1329             require(maxLimitNonWhitelist >= minted+_mintAmount, "cannot mint more than limit");
1330         }
1331         require(msg.value == cost * _mintAmount, "pay price of nft"); 
1332     }
1333     for (uint256 i = 1; i <= _mintAmount; i++) {
1334       _safeMint(_to, supply + i);
1335     }
1336   }
1337 
1338   function walletOfOwner(address _owner)
1339     public
1340     view
1341     returns (uint256[] memory)
1342   {
1343     uint256 ownerTokenCount = balanceOf(_owner);
1344     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1345     for (uint256 i; i < ownerTokenCount; i++) {
1346       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1347     }
1348     return tokenIds;
1349   }
1350 
1351   function tokenURI(uint256 tokenId)
1352     public
1353     view
1354     virtual
1355     override
1356     returns (string memory)
1357   {
1358     require(
1359       _exists(tokenId),
1360       "ERC721Metadata: URI query for nonexistent token"
1361     );
1362     
1363     if(revealed == false) {
1364         return notRevealedUri;
1365     }
1366 
1367     string memory currentBaseURI = _baseURI();
1368     return bytes(currentBaseURI).length > 0
1369         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1370         : "";
1371   }
1372 
1373   function reveal() public onlyOwner {
1374       revealed = true;
1375   }
1376 
1377   
1378   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1379     notRevealedUri = _notRevealedURI;
1380   }
1381 
1382   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1383     baseURI = _newBaseURI;
1384   }
1385 
1386   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1387     baseExtension = _newBaseExtension;
1388   }
1389 
1390   function setmaxLimitWhitelist(uint256 _limit) public onlyOwner {
1391     maxLimitWhitelist = _limit;
1392   }
1393 
1394   function setmaxLimitNonWhitelist(uint256 _limit) public onlyOwner {
1395     maxLimitNonWhitelist = _limit;
1396   }
1397 
1398   function pause(bool _state) public onlyOwner {
1399     paused = _state;
1400   }
1401 
1402   function setOnlyWhitelist(bool _state) public onlyOwner {
1403     onlyWhiteList = _state;
1404   }
1405  
1406  function whitelistUser(address _user) public onlyOwner {
1407     whitelisted[_user] = true;
1408   }
1409  
1410   function removeWhitelistUser(address _user) public onlyOwner {
1411     whitelisted[_user] = false;
1412   }
1413 
1414   function withdraw() payable public onlyOwner{
1415     uint amount = address(this).balance;
1416     require(amount>0, "Ether balance is 0 in contract");
1417     payable(address(owner())).transfer(amount);
1418   }
1419 }