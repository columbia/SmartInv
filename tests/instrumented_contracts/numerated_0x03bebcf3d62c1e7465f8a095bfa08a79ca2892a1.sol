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
179 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
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
399 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
429 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
457 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
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
488 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
630 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
631 
632 
633 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
634 
635 pragma solidity ^0.8.0;
636 
637 
638 /**
639  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
640  * @dev See https://eips.ethereum.org/EIPS/eip-721
641  */
642 interface IERC721Metadata is IERC721 {
643     /**
644      * @dev Returns the token collection name.
645      */
646     function name() external view returns (string memory);
647 
648     /**
649      * @dev Returns the token collection symbol.
650      */
651     function symbol() external view returns (string memory);
652 
653     /**
654      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
655      */
656     function tokenURI(uint256 tokenId) external view returns (string memory);
657 }
658 
659 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
660 
661 
662 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
663 
664 pragma solidity ^0.8.0;
665 
666 
667 
668 
669 
670 
671 
672 
673 /**
674  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
675  * the Metadata extension, but not including the Enumerable extension, which is available separately as
676  * {ERC721Enumerable}.
677  */
678 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
679     using Address for address;
680     using Strings for uint256;
681 
682     // Token name
683     string private _name;
684 
685     // Token symbol
686     string private _symbol;
687 
688     // Mapping from token ID to owner address
689     mapping(uint256 => address) private _owners;
690 
691     // Mapping owner address to token count
692     mapping(address => uint256) private _balances;
693 
694     // Mapping from token ID to approved address
695     mapping(uint256 => address) private _tokenApprovals;
696 
697     // Mapping from owner to operator approvals
698     mapping(address => mapping(address => bool)) private _operatorApprovals;
699 
700     /**
701      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
702      */
703     constructor(string memory name_, string memory symbol_) {
704         _name = name_;
705         _symbol = symbol_;
706     }
707 
708     /**
709      * @dev See {IERC165-supportsInterface}.
710      */
711     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
712         return
713             interfaceId == type(IERC721).interfaceId ||
714             interfaceId == type(IERC721Metadata).interfaceId ||
715             super.supportsInterface(interfaceId);
716     }
717 
718     /**
719      * @dev See {IERC721-balanceOf}.
720      */
721     function balanceOf(address owner) public view virtual override returns (uint256) {
722         require(owner != address(0), "ERC721: balance query for the zero address");
723         return _balances[owner];
724     }
725 
726     /**
727      * @dev See {IERC721-ownerOf}.
728      */
729     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
730         address owner = _owners[tokenId];
731         require(owner != address(0), "ERC721: owner query for nonexistent token");
732         return owner;
733     }
734 
735     /**
736      * @dev See {IERC721Metadata-name}.
737      */
738     function name() public view virtual override returns (string memory) {
739         return _name;
740     }
741 
742     /**
743      * @dev See {IERC721Metadata-symbol}.
744      */
745     function symbol() public view virtual override returns (string memory) {
746         return _symbol;
747     }
748 
749     /**
750      * @dev See {IERC721Metadata-tokenURI}.
751      */
752     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
753         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
754 
755         string memory baseURI = _baseURI();
756         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
757     }
758 
759     /**
760      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
761      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
762      * by default, can be overriden in child contracts.
763      */
764     function _baseURI() internal view virtual returns (string memory) {
765         return "";
766     }
767 
768     /**
769      * @dev See {IERC721-approve}.
770      */
771     function approve(address to, uint256 tokenId) public virtual override {
772         address owner = ERC721.ownerOf(tokenId);
773         require(to != owner, "ERC721: approval to current owner");
774 
775         require(
776             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
777             "ERC721: approve caller is not owner nor approved for all"
778         );
779 
780         _approve(to, tokenId);
781     }
782 
783     /**
784      * @dev See {IERC721-getApproved}.
785      */
786     function getApproved(uint256 tokenId) public view virtual override returns (address) {
787         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
788 
789         return _tokenApprovals[tokenId];
790     }
791 
792     /**
793      * @dev See {IERC721-setApprovalForAll}.
794      */
795     function setApprovalForAll(address operator, bool approved) public virtual override {
796         _setApprovalForAll(_msgSender(), operator, approved);
797     }
798 
799     /**
800      * @dev See {IERC721-isApprovedForAll}.
801      */
802     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
803         return _operatorApprovals[owner][operator];
804     }
805 
806     /**
807      * @dev See {IERC721-transferFrom}.
808      */
809     function transferFrom(
810         address from,
811         address to,
812         uint256 tokenId
813     ) public virtual override {
814         //solhint-disable-next-line max-line-length
815         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
816 
817         _transfer(from, to, tokenId);
818     }
819 
820     /**
821      * @dev See {IERC721-safeTransferFrom}.
822      */
823     function safeTransferFrom(
824         address from,
825         address to,
826         uint256 tokenId
827     ) public virtual override {
828         safeTransferFrom(from, to, tokenId, "");
829     }
830 
831     /**
832      * @dev See {IERC721-safeTransferFrom}.
833      */
834     function safeTransferFrom(
835         address from,
836         address to,
837         uint256 tokenId,
838         bytes memory _data
839     ) public virtual override {
840         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
841         _safeTransfer(from, to, tokenId, _data);
842     }
843 
844     /**
845      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
846      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
847      *
848      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
849      *
850      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
851      * implement alternative mechanisms to perform token transfer, such as signature-based.
852      *
853      * Requirements:
854      *
855      * - `from` cannot be the zero address.
856      * - `to` cannot be the zero address.
857      * - `tokenId` token must exist and be owned by `from`.
858      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _safeTransfer(
863         address from,
864         address to,
865         uint256 tokenId,
866         bytes memory _data
867     ) internal virtual {
868         _transfer(from, to, tokenId);
869         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
870     }
871 
872     /**
873      * @dev Returns whether `tokenId` exists.
874      *
875      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
876      *
877      * Tokens start existing when they are minted (`_mint`),
878      * and stop existing when they are burned (`_burn`).
879      */
880     function _exists(uint256 tokenId) internal view virtual returns (bool) {
881         return _owners[tokenId] != address(0);
882     }
883 
884     /**
885      * @dev Returns whether `spender` is allowed to manage `tokenId`.
886      *
887      * Requirements:
888      *
889      * - `tokenId` must exist.
890      */
891     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
892         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
893         address owner = ERC721.ownerOf(tokenId);
894         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
895     }
896 
897     /**
898      * @dev Safely mints `tokenId` and transfers it to `to`.
899      *
900      * Requirements:
901      *
902      * - `tokenId` must not exist.
903      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _safeMint(address to, uint256 tokenId) internal virtual {
908         _safeMint(to, tokenId, "");
909     }
910 
911     /**
912      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
913      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
914      */
915     function _safeMint(
916         address to,
917         uint256 tokenId,
918         bytes memory _data
919     ) internal virtual {
920         _mint(to, tokenId);
921         require(
922             _checkOnERC721Received(address(0), to, tokenId, _data),
923             "ERC721: transfer to non ERC721Receiver implementer"
924         );
925     }
926 
927     /**
928      * @dev Mints `tokenId` and transfers it to `to`.
929      *
930      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
931      *
932      * Requirements:
933      *
934      * - `tokenId` must not exist.
935      * - `to` cannot be the zero address.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _mint(address to, uint256 tokenId) internal virtual {
940         require(to != address(0), "ERC721: mint to the zero address");
941         require(!_exists(tokenId), "ERC721: token already minted");
942 
943         _beforeTokenTransfer(address(0), to, tokenId);
944 
945         _balances[to] += 1;
946         _owners[tokenId] = to;
947 
948         emit Transfer(address(0), to, tokenId);
949     }
950 
951     /**
952      * @dev Destroys `tokenId`.
953      * The approval is cleared when the token is burned.
954      *
955      * Requirements:
956      *
957      * - `tokenId` must exist.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _burn(uint256 tokenId) internal virtual {
962         address owner = ERC721.ownerOf(tokenId);
963 
964         _beforeTokenTransfer(owner, address(0), tokenId);
965 
966         // Clear approvals
967         _approve(address(0), tokenId);
968 
969         _balances[owner] -= 1;
970         delete _owners[tokenId];
971 
972         emit Transfer(owner, address(0), tokenId);
973     }
974 
975     /**
976      * @dev Transfers `tokenId` from `from` to `to`.
977      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
978      *
979      * Requirements:
980      *
981      * - `to` cannot be the zero address.
982      * - `tokenId` token must be owned by `from`.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _transfer(
987         address from,
988         address to,
989         uint256 tokenId
990     ) internal virtual {
991         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
992         require(to != address(0), "ERC721: transfer to the zero address");
993 
994         _beforeTokenTransfer(from, to, tokenId);
995 
996         // Clear approvals from the previous owner
997         _approve(address(0), tokenId);
998 
999         _balances[from] -= 1;
1000         _balances[to] += 1;
1001         _owners[tokenId] = to;
1002 
1003         emit Transfer(from, to, tokenId);
1004     }
1005 
1006     /**
1007      * @dev Approve `to` to operate on `tokenId`
1008      *
1009      * Emits a {Approval} event.
1010      */
1011     function _approve(address to, uint256 tokenId) internal virtual {
1012         _tokenApprovals[tokenId] = to;
1013         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1014     }
1015 
1016     /**
1017      * @dev Approve `operator` to operate on all of `owner` tokens
1018      *
1019      * Emits a {ApprovalForAll} event.
1020      */
1021     function _setApprovalForAll(
1022         address owner,
1023         address operator,
1024         bool approved
1025     ) internal virtual {
1026         require(owner != operator, "ERC721: approve to caller");
1027         _operatorApprovals[owner][operator] = approved;
1028         emit ApprovalForAll(owner, operator, approved);
1029     }
1030 
1031     /**
1032      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1033      * The call is not executed if the target address is not a contract.
1034      *
1035      * @param from address representing the previous owner of the given token ID
1036      * @param to target address that will receive the tokens
1037      * @param tokenId uint256 ID of the token to be transferred
1038      * @param _data bytes optional data to send along with the call
1039      * @return bool whether the call correctly returned the expected magic value
1040      */
1041     function _checkOnERC721Received(
1042         address from,
1043         address to,
1044         uint256 tokenId,
1045         bytes memory _data
1046     ) private returns (bool) {
1047         if (to.isContract()) {
1048             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1049                 return retval == IERC721Receiver.onERC721Received.selector;
1050             } catch (bytes memory reason) {
1051                 if (reason.length == 0) {
1052                     revert("ERC721: transfer to non ERC721Receiver implementer");
1053                 } else {
1054                     assembly {
1055                         revert(add(32, reason), mload(reason))
1056                     }
1057                 }
1058             }
1059         } else {
1060             return true;
1061         }
1062     }
1063 
1064     /**
1065      * @dev Hook that is called before any token transfer. This includes minting
1066      * and burning.
1067      *
1068      * Calling conditions:
1069      *
1070      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1071      * transferred to `to`.
1072      * - When `from` is zero, `tokenId` will be minted for `to`.
1073      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1074      * - `from` and `to` are never both zero.
1075      *
1076      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1077      */
1078     function _beforeTokenTransfer(
1079         address from,
1080         address to,
1081         uint256 tokenId
1082     ) internal virtual {}
1083 }
1084 
1085 // File: contracts/LeAnime2Simplified_RELEASEDAY/Anime2-wrapper_13_stripped_down_FINAL.sol
1086 
1087 
1088 pragma solidity ^0.8.10;
1089 
1090 /// Le Anime Phase 2 by toomuchlag
1091 
1092 
1093 
1094 
1095 
1096 interface IMerger {
1097     function heroURI(uint256 tokenId) external view returns (string memory);
1098 }
1099 interface ITokenURICustom {
1100     function constructTokenURI(uint256 tokenId) external view returns (string memory);
1101 }
1102 
1103 contract LeAnime_Phase2_Wrapper is ERC721, Ownable {
1104     using Strings for uint256;
1105 
1106     // ERC-2981: NFT Royalty Standard
1107     bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
1108     address payable private _royaltyRecipient;
1109     uint256 private _royaltyBps;
1110                     
1111     uint256 private constant OFFSETNG = 12800010000;
1112     uint256 private constant OFFSETAN2 = 100000;
1113 
1114     uint256 private constant OFFSET_SPIRITS = 1573;
1115     
1116     //IERC721metadata to reference Le Anime OE NFT tokens  
1117     IERC721Metadata public mainToken = IERC721Metadata(0x41113bcE4659cB4912ED61d48154839F75131d7A);
1118     
1119     //address of the mergeContract - able to lock the tokens in this contract when creating Heroes
1120     address public mergeContract;
1121 
1122     //addres of the initial spirits minter contract
1123     address public minterContract;
1124     
1125     //this is to select what "Wrapped Anime" shows, the soul or the walking man video
1126     mapping(uint256 => bool) public uriSelection;
1127     
1128     //optional customURI contract for upgradability
1129     address private _customURIContract;
1130     
1131     //bools to close some upgradable aspects forever
1132     
1133     bool public closedMergeContractUpdate = false;
1134 
1135     bool public closedUriUpdate = false;
1136 
1137     bool public closedMinterUpdate = false;
1138 
1139     bool public closedMergeActiveUpdate = false;
1140 
1141     bool public emergencyRevoked = false;
1142 
1143     bool public mergeActive = false;
1144     
1145     //baseURI for souls and spirits JSON metadata
1146     string public baseURI = "ipfs://ipfs/QmfM9ajo9WybPcrSHJrDRS7Cr9D21mRW52DaBmXK1vEp4p/"; 
1147     string public baseURI_OE = "https://leanime.art/metadataphase2/oe/";
1148 
1149     string public preheroURI = "https://leanime.art/metadataphase2/prehero";
1150     
1151     uint256 constant animeFirst = 1;
1152     uint256 constant animeLast = 1573;
1153     uint256 constant spiritsFirst = 1574;
1154     uint256 constant spiritsLast = 10627;
1155         
1156     constructor(address mainTkn) ERC721("Le Anime by toomuchlag", "LAG") {
1157         // set original Le Anime OE token for wrapping;
1158         mainToken = IERC721Metadata(mainTkn);   
1159         _royaltyRecipient = payable(0x50b88F3f1Ea8948731c6af4C0EBfDEf1beccD6Fa);
1160         _royaltyBps = 1000;
1161     }
1162 
1163     //register interfaceID _INTERFACE_ID_ERC2981
1164     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
1165         return
1166             interfaceId == _INTERFACE_ID_ERC2981 || super.supportsInterface(interfaceId);
1167     }
1168 
1169     // *** Token URI functions *** 
1170     
1171     function setBaseURI(string calldata newBaseURI, string calldata newBaseURI_OE) public onlyOwner {
1172         require(closedUriUpdate == false, "Uri finalised");
1173         baseURI = newBaseURI;
1174         baseURI_OE = newBaseURI_OE;
1175     }
1176 
1177     function setCustomURI(address contractURI) public onlyOwner {
1178         require(closedUriUpdate == false, "Uri finalised");
1179         _customURIContract = contractURI;
1180     }
1181     
1182     //flips the tokenURI from soul to walking hero and back - only for le Anime OE
1183     function flipURI(uint256 tokenId) public  {
1184         require(tokenId >= OFFSETAN2 + 1 && tokenId <= OFFSETAN2 + 1573, "Only Le Anime");
1185         require(msg.sender == ownerOf(tokenId), "You are not the owner");
1186         uriSelection[tokenId] = !uriSelection[tokenId]; 
1187     }
1188     
1189     //return URI for Anime, Spirits and HEROES - UPGRADABLE
1190     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1191         require(_exists(tokenId), "Nonexistent token");
1192 
1193         //custom URI section to allow extensions at future stage
1194         if(_customURIContract != address(0)) {
1195             return ITokenURICustom(_customURIContract).constructTokenURI(tokenId);
1196         }
1197         else { //default token URI section
1198              //Le Anime and Spirits Section
1199             if(tokenId > OFFSETAN2) { //&& !heroLocked[heroId]
1200                 if(uriSelection[tokenId]) { //just possible for Le Anime OE - cannot flipURI in spirits
1201                     return string(abi.encodePacked(baseURI_OE, tokenId.toString()));
1202                 }
1203                 return string(abi.encodePacked(baseURI, tokenId.toString()));
1204             }
1205             else {
1206                 if(mergeActive) {
1207                     return IMerger(mergeContract).heroURI(tokenId);
1208                 }
1209                 else {
1210                     return preheroURI;
1211                 }
1212             }
1213         }
1214     }
1215     
1216     // *** Admin functions *** ONLY OWNER
1217     
1218     function closeMergeContractUpdate() onlyOwner public {
1219         closedMergeContractUpdate = true;
1220     }
1221 
1222     function closeMergeActiveUpdate() onlyOwner public {
1223         closedMergeActiveUpdate = true;
1224     }
1225 
1226     function closeMinterUpdate() onlyOwner public {
1227         closedMinterUpdate = true;
1228     }
1229 
1230     function closeUriUpdate() onlyOwner public {
1231         closedUriUpdate = true;
1232     }
1233 
1234     function setMergeActive(bool flag) onlyOwner public {
1235         require(!closedMergeActiveUpdate, "Cannot update");
1236         mergeActive = flag;
1237     }
1238 
1239     // set the merge Contract
1240     function setMergeContract(address mergeContractAddress) public onlyOwner {
1241         require(!closedMergeContractUpdate, "Cannot update merge");
1242         mergeContract = mergeContractAddress;
1243     }
1244 
1245     // set the initial mint/claim Contract
1246     function setMinterContract(address minterContractAddress) public onlyOwner {
1247         require(!closedMinterUpdate, "Cannot update minter");
1248         minterContract = minterContractAddress;
1249     }
1250 
1251     //this revokes the temporary emergency function to recover lost tokens - only smart contract owner can trigger it
1252     function revokeEmergency() onlyOwner public {
1253         emergencyRevoked = true;
1254     }
1255 
1256     // *** EMERGENCY functions *** emergency withdrawal to recover stuck external ERC721 sent to the contract accidentally
1257     function emergencyRecover(address to, address contractAddress, uint256 tokenId) public onlyOwner {
1258         require(emergencyRevoked == false, "Emergency power revoked");
1259         IERC721 contractERC721 = IERC721(contractAddress);
1260         contractERC721.transferFrom(address(this), to, tokenId);
1261     }
1262     
1263     // *** Wrapping / Unwrapping / Depositing / Withdrawing Le Anime OE to Souls
1264     
1265     function wrapTokenBatch(uint256[] calldata tokenId) public {
1266         //address mainOwner;
1267         for (uint256 i = 0; i < tokenId.length ; i++){
1268             require(tokenId[i] <= 1573, "Wrapping not existing token ");
1269 
1270             //user need to set approval on the mainContract to this contract to allow the next transfer to work
1271             mainToken.transferFrom(msg.sender, address(this), tokenId[i] + OFFSETNG);
1272             
1273             //generating the soul & free spirits the first time it gets wrapped
1274             if(!_exists(tokenId[i] + OFFSETAN2)) {
1275                 _mint(msg.sender, tokenId[i] + OFFSETAN2);
1276                 _mint(msg.sender, tokenId[i] + OFFSET_SPIRITS + OFFSETAN2);
1277             }
1278             else {
1279                 _safeTransfer(address(this), msg.sender, tokenId[i] + OFFSETAN2, "");
1280             }
1281 
1282         }
1283     }
1284     
1285     function unwrapTokenBatch(uint256[] calldata tokenId) public {
1286         
1287         for (uint256 i = 0; i < tokenId.length ; i++){
1288             transferFrom(msg.sender, address(this), tokenId[i] + OFFSETAN2);
1289             mainToken.safeTransferFrom(address(this), msg.sender, tokenId[i] + OFFSETNG);
1290             
1291             //resets the uriSelection to default
1292             uriSelection[tokenId[i] + OFFSETAN2] = false;
1293         }
1294     }
1295 
1296     //this is to batch transfer multiple tokens - useful to batch deposit in the merge contract!
1297     function transferFromBatch(address from, address to, uint256[] calldata tokenId) public {
1298         for (uint256 i = 0; i < tokenId.length ; i++){
1299             transferFrom(from, to, tokenId[i]);   
1300         }
1301     }
1302 
1303     function transferFromBatchMerger(address from, address to, uint16[] calldata tokenId) public {
1304         require(msg.sender == mergeContract, "Not allowed");
1305         for (uint256 i = 0; i < tokenId.length ; i++){
1306             transferFrom(from, to, tokenId[i] + OFFSETAN2);   
1307         }
1308     }
1309 
1310     //to check if token exists - needed in merge
1311     function exists(uint256 tokenId) public view returns (bool) {
1312         return _exists(tokenId);
1313     }
1314      
1315     // *** Hero Section to mint/burn the hero ID from the main contract address
1316     function mintHero(uint256 heroId, address account) external {
1317         require(msg.sender == mergeContract, "Not allowed");
1318         require(mergeActive, "Merge not active");
1319         require(heroId <= OFFSETAN2, "Only for Heroes");
1320         
1321          _mint(account, heroId);
1322     }
1323 
1324     function burnHero(uint256 heroId) external {
1325         require(msg.sender == mergeContract, "Not allowed");
1326         require(mergeActive, "Merge not active");
1327         require(heroId <= OFFSETAN2, "Only for Heroes");
1328 
1329         _burn(heroId);
1330     }
1331 
1332     // *** Minting Section Souls/Spirits***
1333 
1334     function mintSpirits(address account, uint256[] calldata tokenId) external {
1335         require(msg.sender == minterContract);
1336 
1337         for (uint256 i = 0; i < tokenId.length ; i++){
1338             require(tokenId[i] >= spiritsFirst && tokenId[i] <= spiritsLast, "Out of Bound minting");
1339             _mint(account, tokenId[i] + OFFSETAN2);
1340         }
1341     }
1342 
1343     // *** Royalty standard - EIP-2981 ***
1344 
1345     function setRoyaltyPercentageBasisPoints(uint256 royaltyPercentageBasisPoints) public onlyOwner {
1346         _royaltyBps = royaltyPercentageBasisPoints;
1347     }
1348 
1349     function setRoyaltyReceipientAddress(address payable royaltyReceipientAddress) public onlyOwner {
1350         _royaltyRecipient = royaltyReceipientAddress;
1351     }
1352 
1353     function royaltyInfo(uint256 tokenId, uint256 salePrice) external view returns (address receiver, uint256 royaltyAmount) {
1354         uint256 royalty = (salePrice * _royaltyBps) / 10000;
1355         return (_royaltyRecipient, royalty);
1356     }
1357     
1358 }