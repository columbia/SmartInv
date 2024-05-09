1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Context.sol
74 
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Provides information about the current execution context, including the
82  * sender of the transaction and its data. While these are generally available
83  * via msg.sender and msg.data, they should not be accessed in such a direct
84  * manner, since when dealing with meta-transactions the account sending and
85  * paying for execution may not be the actual sender (as far as an application
86  * is concerned).
87  *
88  * This contract is only required for intermediate, library-like contracts.
89  */
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 // File: @openzeppelin/contracts/access/Ownable.sol
101 
102 
103 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 
108 /**
109  * @dev Contract module which provides a basic access control mechanism, where
110  * there is an account (an owner) that can be granted exclusive access to
111  * specific functions.
112  *
113  * By default, the owner account will be the one that deploys the contract. This
114  * can later be changed with {transferOwnership}.
115  *
116  * This module is used through inheritance. It will make available the modifier
117  * `onlyOwner`, which can be applied to your functions to restrict their use to
118  * the owner.
119  */
120 abstract contract Ownable is Context {
121     address private _owner;
122 
123     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124 
125     /**
126      * @dev Initializes the contract setting the deployer as the initial owner.
127      */
128     constructor() {
129         _transferOwnership(_msgSender());
130     }
131 
132     /**
133      * @dev Returns the address of the current owner.
134      */
135     function owner() public view virtual returns (address) {
136         return _owner;
137     }
138 
139     /**
140      * @dev Throws if called by any account other than the owner.
141      */
142     modifier onlyOwner() {
143         require(owner() == _msgSender(), "Ownable: caller is not the owner");
144         _;
145     }
146 
147     /**
148      * @dev Leaves the contract without owner. It will not be possible to call
149      * `onlyOwner` functions anymore. Can only be called by the current owner.
150      *
151      * NOTE: Renouncing ownership will leave the contract without an owner,
152      * thereby removing any functionality that is only available to the owner.
153      */
154     function renounceOwnership() public virtual onlyOwner {
155         _transferOwnership(address(0));
156     }
157 
158     /**
159      * @dev Transfers ownership of the contract to a new account (`newOwner`).
160      * Can only be called by the current owner.
161      */
162     function transferOwnership(address newOwner) public virtual onlyOwner {
163         require(newOwner != address(0), "Ownable: new owner is the zero address");
164         _transferOwnership(newOwner);
165     }
166 
167     /**
168      * @dev Transfers ownership of the contract to a new account (`newOwner`).
169      * Internal function without access restriction.
170      */
171     function _transferOwnership(address newOwner) internal virtual {
172         address oldOwner = _owner;
173         _owner = newOwner;
174         emit OwnershipTransferred(oldOwner, newOwner);
175     }
176 }
177 
178 // File: @openzeppelin/contracts/utils/Address.sol
179 
180 
181 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
182 
183 pragma solidity ^0.8.0;
184 
185 /**
186  * @dev Collection of functions related to the address type
187  */
188 library Address {
189     /**
190      * @dev Returns true if `account` is a contract.
191      *
192      * [IMPORTANT]
193      * ====
194      * It is unsafe to assume that an address for which this function returns
195      * false is an externally-owned account (EOA) and not a contract.
196      *
197      * Among others, `isContract` will return false for the following
198      * types of addresses:
199      *
200      *  - an externally-owned account
201      *  - a contract in construction
202      *  - an address where a contract will be created
203      *  - an address where a contract lived, but was destroyed
204      * ====
205      */
206     function isContract(address account) internal view returns (bool) {
207         // This method relies on extcodesize, which returns 0 for contracts in
208         // construction, since the code is only stored at the end of the
209         // constructor execution.
210 
211         uint256 size;
212         assembly {
213             size := extcodesize(account)
214         }
215         return size > 0;
216     }
217 
218     /**
219      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
220      * `recipient`, forwarding all available gas and reverting on errors.
221      *
222      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
223      * of certain opcodes, possibly making contracts go over the 2300 gas limit
224      * imposed by `transfer`, making them unable to receive funds via
225      * `transfer`. {sendValue} removes this limitation.
226      *
227      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
228      *
229      * IMPORTANT: because control is transferred to `recipient`, care must be
230      * taken to not create reentrancy vulnerabilities. Consider using
231      * {ReentrancyGuard} or the
232      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
233      */
234     function sendValue(address payable recipient, uint256 amount) internal {
235         require(address(this).balance >= amount, "Address: insufficient balance");
236 
237         (bool success, ) = recipient.call{value: amount}("");
238         require(success, "Address: unable to send value, recipient may have reverted");
239     }
240 
241     /**
242      * @dev Performs a Solidity function call using a low level `call`. A
243      * plain `call` is an unsafe replacement for a function call: use this
244      * function instead.
245      *
246      * If `target` reverts with a revert reason, it is bubbled up by this
247      * function (like regular Solidity function calls).
248      *
249      * Returns the raw returned data. To convert to the expected return value,
250      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
251      *
252      * Requirements:
253      *
254      * - `target` must be a contract.
255      * - calling `target` with `data` must not revert.
256      *
257      * _Available since v3.1._
258      */
259     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
260         return functionCall(target, data, "Address: low-level call failed");
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
265      * `errorMessage` as a fallback revert reason when `target` reverts.
266      *
267      * _Available since v3.1._
268      */
269     function functionCall(
270         address target,
271         bytes memory data,
272         string memory errorMessage
273     ) internal returns (bytes memory) {
274         return functionCallWithValue(target, data, 0, errorMessage);
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
279      * but also transferring `value` wei to `target`.
280      *
281      * Requirements:
282      *
283      * - the calling contract must have an ETH balance of at least `value`.
284      * - the called Solidity function must be `payable`.
285      *
286      * _Available since v3.1._
287      */
288     function functionCallWithValue(
289         address target,
290         bytes memory data,
291         uint256 value
292     ) internal returns (bytes memory) {
293         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
298      * with `errorMessage` as a fallback revert reason when `target` reverts.
299      *
300      * _Available since v3.1._
301      */
302     function functionCallWithValue(
303         address target,
304         bytes memory data,
305         uint256 value,
306         string memory errorMessage
307     ) internal returns (bytes memory) {
308         require(address(this).balance >= value, "Address: insufficient balance for call");
309         require(isContract(target), "Address: call to non-contract");
310 
311         (bool success, bytes memory returndata) = target.call{value: value}(data);
312         return verifyCallResult(success, returndata, errorMessage);
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but performing a static call.
318      *
319      * _Available since v3.3._
320      */
321     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
322         return functionStaticCall(target, data, "Address: low-level static call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
327      * but performing a static call.
328      *
329      * _Available since v3.3._
330      */
331     function functionStaticCall(
332         address target,
333         bytes memory data,
334         string memory errorMessage
335     ) internal view returns (bytes memory) {
336         require(isContract(target), "Address: static call to non-contract");
337 
338         (bool success, bytes memory returndata) = target.staticcall(data);
339         return verifyCallResult(success, returndata, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but performing a delegate call.
345      *
346      * _Available since v3.4._
347      */
348     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
349         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
354      * but performing a delegate call.
355      *
356      * _Available since v3.4._
357      */
358     function functionDelegateCall(
359         address target,
360         bytes memory data,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         require(isContract(target), "Address: delegate call to non-contract");
364 
365         (bool success, bytes memory returndata) = target.delegatecall(data);
366         return verifyCallResult(success, returndata, errorMessage);
367     }
368 
369     /**
370      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
371      * revert reason using the provided one.
372      *
373      * _Available since v4.3._
374      */
375     function verifyCallResult(
376         bool success,
377         bytes memory returndata,
378         string memory errorMessage
379     ) internal pure returns (bytes memory) {
380         if (success) {
381             return returndata;
382         } else {
383             // Look for revert reason and bubble it up if present
384             if (returndata.length > 0) {
385                 // The easiest way to bubble the revert reason is using memory via assembly
386 
387                 assembly {
388                     let returndata_size := mload(returndata)
389                     revert(add(32, returndata), returndata_size)
390                 }
391             } else {
392                 revert(errorMessage);
393             }
394         }
395     }
396 }
397 
398 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
399 
400 
401 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
402 
403 pragma solidity ^0.8.0;
404 
405 /**
406  * @title ERC721 token receiver interface
407  * @dev Interface for any contract that wants to support safeTransfers
408  * from ERC721 asset contracts.
409  */
410 interface IERC721Receiver {
411     /**
412      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
413      * by `operator` from `from`, this function is called.
414      *
415      * It must return its Solidity selector to confirm the token transfer.
416      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
417      *
418      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
419      */
420     function onERC721Received(
421         address operator,
422         address from,
423         uint256 tokenId,
424         bytes calldata data
425     ) external returns (bytes4);
426 }
427 
428 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
429 
430 
431 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
432 
433 pragma solidity ^0.8.0;
434 
435 /**
436  * @dev Interface of the ERC165 standard, as defined in the
437  * https://eips.ethereum.org/EIPS/eip-165[EIP].
438  *
439  * Implementers can declare support of contract interfaces, which can then be
440  * queried by others ({ERC165Checker}).
441  *
442  * For an implementation, see {ERC165}.
443  */
444 interface IERC165 {
445     /**
446      * @dev Returns true if this contract implements the interface defined by
447      * `interfaceId`. See the corresponding
448      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
449      * to learn more about how these ids are created.
450      *
451      * This function call must use less than 30 000 gas.
452      */
453     function supportsInterface(bytes4 interfaceId) external view returns (bool);
454 }
455 
456 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
457 
458 
459 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 
464 /**
465  * @dev Implementation of the {IERC165} interface.
466  *
467  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
468  * for the additional interface id that will be supported. For example:
469  *
470  * ```solidity
471  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
472  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
473  * }
474  * ```
475  *
476  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
477  */
478 abstract contract ERC165 is IERC165 {
479     /**
480      * @dev See {IERC165-supportsInterface}.
481      */
482     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
483         return interfaceId == type(IERC165).interfaceId;
484     }
485 }
486 
487 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
488 
489 
490 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
491 
492 pragma solidity ^0.8.0;
493 
494 
495 /**
496  * @dev Required interface of an ERC721 compliant contract.
497  */
498 interface IERC721 is IERC165 {
499     /**
500      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
501      */
502     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
503 
504     /**
505      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
506      */
507     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
508 
509     /**
510      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
511      */
512     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
513 
514     /**
515      * @dev Returns the number of tokens in ``owner``'s account.
516      */
517     function balanceOf(address owner) external view returns (uint256 balance);
518 
519     /**
520      * @dev Returns the owner of the `tokenId` token.
521      *
522      * Requirements:
523      *
524      * - `tokenId` must exist.
525      */
526     function ownerOf(uint256 tokenId) external view returns (address owner);
527 
528     /**
529      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
530      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
531      *
532      * Requirements:
533      *
534      * - `from` cannot be the zero address.
535      * - `to` cannot be the zero address.
536      * - `tokenId` token must exist and be owned by `from`.
537      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
538      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
539      *
540      * Emits a {Transfer} event.
541      */
542     function safeTransferFrom(
543         address from,
544         address to,
545         uint256 tokenId
546     ) external;
547 
548     /**
549      * @dev Transfers `tokenId` token from `from` to `to`.
550      *
551      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
552      *
553      * Requirements:
554      *
555      * - `from` cannot be the zero address.
556      * - `to` cannot be the zero address.
557      * - `tokenId` token must be owned by `from`.
558      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
559      *
560      * Emits a {Transfer} event.
561      */
562     function transferFrom(
563         address from,
564         address to,
565         uint256 tokenId
566     ) external;
567 
568     /**
569      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
570      * The approval is cleared when the token is transferred.
571      *
572      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
573      *
574      * Requirements:
575      *
576      * - The caller must own the token or be an approved operator.
577      * - `tokenId` must exist.
578      *
579      * Emits an {Approval} event.
580      */
581     function approve(address to, uint256 tokenId) external;
582 
583     /**
584      * @dev Returns the account approved for `tokenId` token.
585      *
586      * Requirements:
587      *
588      * - `tokenId` must exist.
589      */
590     function getApproved(uint256 tokenId) external view returns (address operator);
591 
592     /**
593      * @dev Approve or remove `operator` as an operator for the caller.
594      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
595      *
596      * Requirements:
597      *
598      * - The `operator` cannot be the caller.
599      *
600      * Emits an {ApprovalForAll} event.
601      */
602     function setApprovalForAll(address operator, bool _approved) external;
603 
604     /**
605      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
606      *
607      * See {setApprovalForAll}
608      */
609     function isApprovedForAll(address owner, address operator) external view returns (bool);
610 
611     /**
612      * @dev Safely transfers `tokenId` token from `from` to `to`.
613      *
614      * Requirements:
615      *
616      * - `from` cannot be the zero address.
617      * - `to` cannot be the zero address.
618      * - `tokenId` token must exist and be owned by `from`.
619      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
620      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
621      *
622      * Emits a {Transfer} event.
623      */
624     function safeTransferFrom(
625         address from,
626         address to,
627         uint256 tokenId,
628         bytes calldata data
629     ) external;
630 }
631 
632 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
633 
634 
635 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
636 
637 pragma solidity ^0.8.0;
638 
639 
640 /**
641  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
642  * @dev See https://eips.ethereum.org/EIPS/eip-721
643  */
644 interface IERC721Enumerable is IERC721 {
645     /**
646      * @dev Returns the total amount of tokens stored by the contract.
647      */
648     function totalSupply() external view returns (uint256);
649 
650     /**
651      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
652      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
653      */
654     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
655 
656     /**
657      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
658      * Use along with {totalSupply} to enumerate all tokens.
659      */
660     function tokenByIndex(uint256 index) external view returns (uint256);
661 }
662 
663 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
664 
665 
666 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 
671 /**
672  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
673  * @dev See https://eips.ethereum.org/EIPS/eip-721
674  */
675 interface IERC721Metadata is IERC721 {
676     /**
677      * @dev Returns the token collection name.
678      */
679     function name() external view returns (string memory);
680 
681     /**
682      * @dev Returns the token collection symbol.
683      */
684     function symbol() external view returns (string memory);
685 
686     /**
687      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
688      */
689     function tokenURI(uint256 tokenId) external view returns (string memory);
690 }
691 
692 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
693 
694 
695 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
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
829         _setApprovalForAll(_msgSender(), operator, approved);
830     }
831 
832     /**
833      * @dev See {IERC721-isApprovedForAll}.
834      */
835     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
836         return _operatorApprovals[owner][operator];
837     }
838 
839     /**
840      * @dev See {IERC721-transferFrom}.
841      */
842     function transferFrom(
843         address from,
844         address to,
845         uint256 tokenId
846     ) public virtual override {
847         //solhint-disable-next-line max-line-length
848         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
849 
850         _transfer(from, to, tokenId);
851     }
852 
853     /**
854      * @dev See {IERC721-safeTransferFrom}.
855      */
856     function safeTransferFrom(
857         address from,
858         address to,
859         uint256 tokenId
860     ) public virtual override {
861         safeTransferFrom(from, to, tokenId, "");
862     }
863 
864     /**
865      * @dev See {IERC721-safeTransferFrom}.
866      */
867     function safeTransferFrom(
868         address from,
869         address to,
870         uint256 tokenId,
871         bytes memory _data
872     ) public virtual override {
873         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
874         _safeTransfer(from, to, tokenId, _data);
875     }
876 
877     /**
878      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
879      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
880      *
881      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
882      *
883      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
884      * implement alternative mechanisms to perform token transfer, such as signature-based.
885      *
886      * Requirements:
887      *
888      * - `from` cannot be the zero address.
889      * - `to` cannot be the zero address.
890      * - `tokenId` token must exist and be owned by `from`.
891      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
892      *
893      * Emits a {Transfer} event.
894      */
895     function _safeTransfer(
896         address from,
897         address to,
898         uint256 tokenId,
899         bytes memory _data
900     ) internal virtual {
901         _transfer(from, to, tokenId);
902         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
903     }
904 
905     /**
906      * @dev Returns whether `tokenId` exists.
907      *
908      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
909      *
910      * Tokens start existing when they are minted (`_mint`),
911      * and stop existing when they are burned (`_burn`).
912      */
913     function _exists(uint256 tokenId) internal view virtual returns (bool) {
914         return _owners[tokenId] != address(0);
915     }
916 
917     /**
918      * @dev Returns whether `spender` is allowed to manage `tokenId`.
919      *
920      * Requirements:
921      *
922      * - `tokenId` must exist.
923      */
924     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
925         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
926         address owner = ERC721.ownerOf(tokenId);
927         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
928     }
929 
930     /**
931      * @dev Safely mints `tokenId` and transfers it to `to`.
932      *
933      * Requirements:
934      *
935      * - `tokenId` must not exist.
936      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _safeMint(address to, uint256 tokenId) internal virtual {
941         _safeMint(to, tokenId, "");
942     }
943 
944     /**
945      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
946      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
947      */
948     function _safeMint(
949         address to,
950         uint256 tokenId,
951         bytes memory _data
952     ) internal virtual {
953         _mint(to, tokenId);
954         require(
955             _checkOnERC721Received(address(0), to, tokenId, _data),
956             "ERC721: transfer to non ERC721Receiver implementer"
957         );
958     }
959 
960     /**
961      * @dev Mints `tokenId` and transfers it to `to`.
962      *
963      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
964      *
965      * Requirements:
966      *
967      * - `tokenId` must not exist.
968      * - `to` cannot be the zero address.
969      *
970      * Emits a {Transfer} event.
971      */
972     function _mint(address to, uint256 tokenId) internal virtual {
973         require(to != address(0), "ERC721: mint to the zero address");
974         require(!_exists(tokenId), "ERC721: token already minted");
975 
976         _beforeTokenTransfer(address(0), to, tokenId);
977 
978         _balances[to] += 1;
979         _owners[tokenId] = to;
980 
981         emit Transfer(address(0), to, tokenId);
982     }
983 
984     /**
985      * @dev Destroys `tokenId`.
986      * The approval is cleared when the token is burned.
987      *
988      * Requirements:
989      *
990      * - `tokenId` must exist.
991      *
992      * Emits a {Transfer} event.
993      */
994     function _burn(uint256 tokenId) internal virtual {
995         address owner = ERC721.ownerOf(tokenId);
996 
997         _beforeTokenTransfer(owner, address(0), tokenId);
998 
999         // Clear approvals
1000         _approve(address(0), tokenId);
1001 
1002         _balances[owner] -= 1;
1003         delete _owners[tokenId];
1004 
1005         emit Transfer(owner, address(0), tokenId);
1006     }
1007 
1008     /**
1009      * @dev Transfers `tokenId` from `from` to `to`.
1010      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1011      *
1012      * Requirements:
1013      *
1014      * - `to` cannot be the zero address.
1015      * - `tokenId` token must be owned by `from`.
1016      *
1017      * Emits a {Transfer} event.
1018      */
1019     function _transfer(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) internal virtual {
1024         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1025         require(to != address(0), "ERC721: transfer to the zero address");
1026 
1027         _beforeTokenTransfer(from, to, tokenId);
1028 
1029         // Clear approvals from the previous owner
1030         _approve(address(0), tokenId);
1031 
1032         _balances[from] -= 1;
1033         _balances[to] += 1;
1034         _owners[tokenId] = to;
1035 
1036         emit Transfer(from, to, tokenId);
1037     }
1038 
1039     /**
1040      * @dev Approve `to` to operate on `tokenId`
1041      *
1042      * Emits a {Approval} event.
1043      */
1044     function _approve(address to, uint256 tokenId) internal virtual {
1045         _tokenApprovals[tokenId] = to;
1046         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1047     }
1048 
1049     /**
1050      * @dev Approve `operator` to operate on all of `owner` tokens
1051      *
1052      * Emits a {ApprovalForAll} event.
1053      */
1054     function _setApprovalForAll(
1055         address owner,
1056         address operator,
1057         bool approved
1058     ) internal virtual {
1059         require(owner != operator, "ERC721: approve to caller");
1060         _operatorApprovals[owner][operator] = approved;
1061         emit ApprovalForAll(owner, operator, approved);
1062     }
1063 
1064     /**
1065      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1066      * The call is not executed if the target address is not a contract.
1067      *
1068      * @param from address representing the previous owner of the given token ID
1069      * @param to target address that will receive the tokens
1070      * @param tokenId uint256 ID of the token to be transferred
1071      * @param _data bytes optional data to send along with the call
1072      * @return bool whether the call correctly returned the expected magic value
1073      */
1074     function _checkOnERC721Received(
1075         address from,
1076         address to,
1077         uint256 tokenId,
1078         bytes memory _data
1079     ) private returns (bool) {
1080         if (to.isContract()) {
1081             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1082                 return retval == IERC721Receiver.onERC721Received.selector;
1083             } catch (bytes memory reason) {
1084                 if (reason.length == 0) {
1085                     revert("ERC721: transfer to non ERC721Receiver implementer");
1086                 } else {
1087                     assembly {
1088                         revert(add(32, reason), mload(reason))
1089                     }
1090                 }
1091             }
1092         } else {
1093             return true;
1094         }
1095     }
1096 
1097     /**
1098      * @dev Hook that is called before any token transfer. This includes minting
1099      * and burning.
1100      *
1101      * Calling conditions:
1102      *
1103      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1104      * transferred to `to`.
1105      * - When `from` is zero, `tokenId` will be minted for `to`.
1106      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1107      * - `from` and `to` are never both zero.
1108      *
1109      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1110      */
1111     function _beforeTokenTransfer(
1112         address from,
1113         address to,
1114         uint256 tokenId
1115     ) internal virtual {}
1116 }
1117 
1118 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1119 
1120 
1121 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1122 
1123 pragma solidity ^0.8.0;
1124 
1125 
1126 
1127 /**
1128  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1129  * enumerability of all the token ids in the contract as well as all token ids owned by each
1130  * account.
1131  */
1132 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1133     // Mapping from owner to list of owned token IDs
1134     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1135 
1136     // Mapping from token ID to index of the owner tokens list
1137     mapping(uint256 => uint256) private _ownedTokensIndex;
1138 
1139     // Array with all token ids, used for enumeration
1140     uint256[] private _allTokens;
1141 
1142     // Mapping from token id to position in the allTokens array
1143     mapping(uint256 => uint256) private _allTokensIndex;
1144 
1145     /**
1146      * @dev See {IERC165-supportsInterface}.
1147      */
1148     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1149         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1150     }
1151 
1152     /**
1153      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1154      */
1155     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1156         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1157         return _ownedTokens[owner][index];
1158     }
1159 
1160     /**
1161      * @dev See {IERC721Enumerable-totalSupply}.
1162      */
1163     function totalSupply() public view virtual override returns (uint256) {
1164         return _allTokens.length;
1165     }
1166 
1167     /**
1168      * @dev See {IERC721Enumerable-tokenByIndex}.
1169      */
1170     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1171         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1172         return _allTokens[index];
1173     }
1174 
1175     /**
1176      * @dev Hook that is called before any token transfer. This includes minting
1177      * and burning.
1178      *
1179      * Calling conditions:
1180      *
1181      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1182      * transferred to `to`.
1183      * - When `from` is zero, `tokenId` will be minted for `to`.
1184      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1185      * - `from` cannot be the zero address.
1186      * - `to` cannot be the zero address.
1187      *
1188      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1189      */
1190     function _beforeTokenTransfer(
1191         address from,
1192         address to,
1193         uint256 tokenId
1194     ) internal virtual override {
1195         super._beforeTokenTransfer(from, to, tokenId);
1196 
1197         if (from == address(0)) {
1198             _addTokenToAllTokensEnumeration(tokenId);
1199         } else if (from != to) {
1200             _removeTokenFromOwnerEnumeration(from, tokenId);
1201         }
1202         if (to == address(0)) {
1203             _removeTokenFromAllTokensEnumeration(tokenId);
1204         } else if (to != from) {
1205             _addTokenToOwnerEnumeration(to, tokenId);
1206         }
1207     }
1208 
1209     /**
1210      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1211      * @param to address representing the new owner of the given token ID
1212      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1213      */
1214     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1215         uint256 length = ERC721.balanceOf(to);
1216         _ownedTokens[to][length] = tokenId;
1217         _ownedTokensIndex[tokenId] = length;
1218     }
1219 
1220     /**
1221      * @dev Private function to add a token to this extension's token tracking data structures.
1222      * @param tokenId uint256 ID of the token to be added to the tokens list
1223      */
1224     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1225         _allTokensIndex[tokenId] = _allTokens.length;
1226         _allTokens.push(tokenId);
1227     }
1228 
1229     /**
1230      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1231      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1232      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1233      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1234      * @param from address representing the previous owner of the given token ID
1235      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1236      */
1237     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1238         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1239         // then delete the last slot (swap and pop).
1240 
1241         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1242         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1243 
1244         // When the token to delete is the last token, the swap operation is unnecessary
1245         if (tokenIndex != lastTokenIndex) {
1246             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1247 
1248             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1249             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1250         }
1251 
1252         // This also deletes the contents at the last position of the array
1253         delete _ownedTokensIndex[tokenId];
1254         delete _ownedTokens[from][lastTokenIndex];
1255     }
1256 
1257     /**
1258      * @dev Private function to remove a token from this extension's token tracking data structures.
1259      * This has O(1) time complexity, but alters the order of the _allTokens array.
1260      * @param tokenId uint256 ID of the token to be removed from the tokens list
1261      */
1262     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1263         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1264         // then delete the last slot (swap and pop).
1265 
1266         uint256 lastTokenIndex = _allTokens.length - 1;
1267         uint256 tokenIndex = _allTokensIndex[tokenId];
1268 
1269         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1270         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1271         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1272         uint256 lastTokenId = _allTokens[lastTokenIndex];
1273 
1274         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1275         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1276 
1277         // This also deletes the contents at the last position of the array
1278         delete _allTokensIndex[tokenId];
1279         _allTokens.pop();
1280     }
1281 }
1282 
1283 // File: contracts/cyberducks.sol
1284 
1285 
1286 
1287 pragma solidity ^0.8.0;
1288 
1289 interface Opensea {
1290     function balanceOf(address tokenOwner, uint tokenId) external view returns (bool);
1291 
1292     function safeTransferFrom(address _from, address _to, uint _id, uint _value, bytes memory _data) external;
1293 }
1294 
1295 
1296 
1297 
1298 pragma solidity ^0.8.0;
1299 library MerkleProof {
1300     function verify(bytes32 root, bytes32 leaf, bytes32[] memory proof) internal pure returns (bool) {
1301         bytes32 computedHash = leaf;
1302 
1303         for (uint256 i = 0; i < proof.length; i++) {
1304             bytes32 proofElement = proof[i];
1305 
1306             if (computedHash <= proofElement) {
1307                 // Hash(current computed hash + current element of the proof)
1308                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1309             } else {
1310                 // Hash(current element of the proof + current computed hash)
1311                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1312             }
1313         }
1314 
1315         // Check if the computed hash (root) is equal to the provided root
1316         return computedHash == root;
1317     }
1318 }
1319 
1320 
1321 
1322 
1323 
1324 
1325 
1326 
1327 
1328 pragma solidity ^0.8.11;
1329 
1330 contract CyberDucksEvolution is ERC721Enumerable, Ownable {
1331     using Strings for uint256;
1332 
1333     uint256 public constant MAX_DUCKS = 7777;
1334     uint256 public constant RESERVES = 27;
1335     bool public paused = false;
1336     bool public revealed = false;
1337     string public baseExtension = ".json";
1338     string public notRevealedUri;
1339     string public baseTokenURI;
1340     bytes32 public merkleRoot;
1341     uint256 private _maxPerTx = 10;
1342     uint256 private _price = 40000000000000000; // .04 ETH
1343     uint256 private _price_wl = 30000000000000000; // .03 ETH
1344     uint256 private _saleTime = 1640736000; // 29/12/2021 @ 00:00:00 (GMT)
1345     address private OPENSEA_STORE = 0x495f947276749Ce646f68AC8c248420045cb7b5e;
1346 
1347     mapping(uint256 => bool) ducksUsedForFree;
1348     mapping(address => uint256) addressToWLDucksMinted;
1349 
1350     uint256[150] private genesisDucks = [
1351     33545808174778596038611434130458611713285808338920316774188539806835659505665,
1352     33545808174778596038611434130458611713285808338920316774188539807935171133441,
1353     33545808174778596038611434130458611713285808338920316774188539809034682761217,
1354     33545808174778596038611434130458611713285808338920316774188539810134194388993,
1355     33545808174778596038611434130458611713285808338920316774188539811233706016769,
1356     33545808174778596038611434130458611713285808338920316774188539812333217644545,
1357     33545808174778596038611434130458611713285808338920316774188539813432729272321,
1358     33545808174778596038611434130458611713285808338920316774188539814532240900097,
1359     33545808174778596038611434130458611713285808338920316774188539815631752527873,
1360     33545808174778596038611434130458611713285808338920316774188539816731264155649,
1361     33545808174778596038611434130458611713285808338920316774188539817830775783425,
1362     33545808174778596038611434130458611713285808338920316774188539818930287411201,
1363     33545808174778596038611434130458611713285808338920316774188539820029799038977,
1364     33545808174778596038611434130458611713285808338920316774188539821129310666753,
1365     33545808174778596038611434130458611713285808338920316774188539822228822294529,
1366     33545808174778596038611434130458611713285808338920316774188539823328333922305,
1367     33545808174778596038611434130458611713285808338920316774188539824427845550081,
1368     33545808174778596038611434130458611713285808338920316774188539825527357177857,
1369     33545808174778596038611434130458611713285808338920316774188539826626868805633,
1370     33545808174778596038611434130458611713285808338920316774188539827726380433409,
1371     33545808174778596038611434130458611713285808338920316774188539829925403688961,
1372     33545808174778596038611434130458611713285808338920316774188539831024915316737,
1373     33545808174778596038611434130458611713285808338920316774188539832124426944513,
1374     33545808174778596038611434130458611713285808338920316774188539833223938572289,
1375     33545808174778596038611434130458611713285808338920316774188539834323450200065,
1376     33545808174778596038611434130458611713285808338920316774188539835422961827841,
1377     33545808174778596038611434130458611713285808338920316774188539836522473455617,
1378     33545808174778596038611434130458611713285808338920316774188539837621985083393,
1379     33545808174778596038611434130458611713285808338920316774188539838721496711169,
1380     33545808174778596038611434130458611713285808338920316774188539839821008338945,
1381     33545808174778596038611434130458611713285808338920316774188539840920519966721,
1382     33545808174778596038611434130458611713285808338920316774188539842020031594497,
1383     33545808174778596038611434130458611713285808338920316774188539843119543222273,
1384     33545808174778596038611434130458611713285808338920316774188539844219054850049,
1385     33545808174778596038611434130458611713285808338920316774188539845318566477825,
1386     33545808174778596038611434130458611713285808338920316774188539846418078105601,
1387     33545808174778596038611434130458611713285808338920316774188539847517589733377,
1388     33545808174778596038611434130458611713285808338920316774188539848617101361153,
1389     33545808174778596038611434130458611713285808338920316774188539849716612988929,
1390     33545808174778596038611434130458611713285808338920316774188539850816124616705,
1391     33545808174778596038611434130458611713285808338920316774188539851915636244481,
1392     33545808174778596038611434130458611713285808338920316774188539853015147872257,
1393     33545808174778596038611434130458611713285808338920316774188539854114659500033,
1394     33545808174778596038611434130458611713285808338920316774188539855214171127809,
1395     33545808174778596038611434130458611713285808338920316774188539856313682755585,
1396     33545808174778596038611434130458611713285808338920316774188539857413194383361,
1397     33545808174778596038611434130458611713285808338920316774188539858512706011137,
1398     33545808174778596038611434130458611713285808338920316774188539859612217638913,
1399     33545808174778596038611434130458611713285808338920316774188539860711729266689,
1400     33545808174778596038611434130458611713285808338920316774188539861811240894465,
1401     33545808174778596038611434130458611713285808338920316774188539862910752522241,
1402     33545808174778596038611434130458611713285808338920316774188539864010264150017,
1403     33545808174778596038611434130458611713285808338920316774188539865109775777793,
1404     33545808174778596038611434130458611713285808338920316774188539866209287405569,
1405     33545808174778596038611434130458611713285808338920316774188539867308799033345,
1406     33545808174778596038611434130458611713285808338920316774188539868408310661121,
1407     33545808174778596038611434130458611713285808338920316774188539869507822288897,
1408     33545808174778596038611434130458611713285808338920316774188539870607333916673,
1409     33545808174778596038611434130458611713285808338920316774188539871706845544449,
1410     33545808174778596038611434130458611713285808338920316774188539872806357172225,
1411     33545808174778596038611434130458611713285808338920316774188539873905868800001,
1412     33545808174778596038611434130458611713285808338920316774188539875005380427777,
1413     33545808174778596038611434130458611713285808338920316774188539876104892055553,
1414     33545808174778596038611434130458611713285808338920316774188539877204403683329,
1415     33545808174778596038611434130458611713285808338920316774188539878303915311105,
1416     33545808174778596038611434130458611713285808338920316774188539879403426938881,
1417     33545808174778596038611434130458611713285808338920316774188539880502938566657,
1418     33545808174778596038611434130458611713285808338920316774188539881602450194433,
1419     33545808174778596038611434130458611713285808338920316774188539882701961822209,
1420     33545808174778596038611434130458611713285808338920316774188539883801473449985,
1421     33545808174778596038611434130458611713285808338920316774188539884900985077761,
1422     33545808174778596038611434130458611713285808338920316774188539886000496705537,
1423     33545808174778596038611434130458611713285808338920316774188539887100008333313,
1424     33545808174778596038611434130458611713285808338920316774188539888199519961089,
1425     33545808174778596038611434130458611713285808338920316774188539889299031588865,
1426     33545808174778596038611434130458611713285808338920316774188539890398543216641,
1427     33545808174778596038611434130458611713285808338920316774188539891498054844417,
1428     33545808174778596038611434130458611713285808338920316774188539892597566472193,
1429     33545808174778596038611434130458611713285808338920316774188539893697078099969,
1430     33545808174778596038611434130458611713285808338920316774188539894796589727745,
1431     33545808174778596038611434130458611713285808338920316774188539895896101355521,
1432     33545808174778596038611434130458611713285808338920316774188539896995612983297,
1433     33545808174778596038611434130458611713285808338920316774188539898095124611073,
1434     33545808174778596038611434130458611713285808338920316774188539899194636238849,
1435     33545808174778596038611434130458611713285808338920316774188539900294147866625,
1436     33545808174778596038611434130458611713285808338920316774188539901393659494401,
1437     33545808174778596038611434130458611713285808338920316774188539902493171122177,
1438     33545808174778596038611434130458611713285808338920316774188539903592682749953,
1439     33545808174778596038611434130458611713285808338920316774188539904692194377729,
1440     33545808174778596038611434130458611713285808338920316774188539905791706005505,
1441     33545808174778596038611434130458611713285808338920316774188539906891217633281,
1442     33545808174778596038611434130458611713285808338920316774188539907990729261057,
1443     33545808174778596038611434130458611713285808338920316774188539909090240888833,
1444     33545808174778596038611434130458611713285808338920316774188539910189752516609,
1445     33545808174778596038611434130458611713285808338920316774188539911289264144385,
1446     33545808174778596038611434130458611713285808338920316774188539912388775772161,
1447     33545808174778596038611434130458611713285808338920316774188539913488287399937,
1448     33545808174778596038611434130458611713285808338920316774188539914587799027713,
1449     33545808174778596038611434130458611713285808338920316774188539915687310655489,
1450     33545808174778596038611434130458611713285808338920316774188539916786822283265,
1451     33545808174778596038611434130458611713285808338920316774188539917886333911041,
1452     33545808174778596038611434130458611713285808338920316774188539918985845538817,
1453     33545808174778596038611434130458611713285808338920316774188539920085357166593,
1454     33545808174778596038611434130458611713285808338920316774188539921184868794369,
1455     33545808174778596038611434130458611713285808338920316774188539922284380422145,
1456     33545808174778596038611434130458611713285808338920316774188539923383892049921,
1457     33545808174778596038611434130458611713285808338920316774188539924483403677697,
1458     33545808174778596038611434130458611713285808338920316774188539925582915305473,
1459     33545808174778596038611434130458611713285808338920316774188539926682426933249,
1460     33545808174778596038611434130458611713285808338920316774188539927781938561025,
1461     33545808174778596038611434130458611713285808338920316774188539928881450188801,
1462     33545808174778596038611434130458611713285808338920316774188539929980961816577,
1463     33545808174778596038611434130458611713285808338920316774188539931080473444353,
1464     33545808174778596038611434130458611713285808338920316774188539932179985072129,
1465     33545808174778596038611434130458611713285808338920316774188539933279496699905,
1466     33545808174778596038611434130458611713285808338920316774188539934379008327681,
1467     33545808174778596038611434130458611713285808338920316774188539935478519955457,
1468     33545808174778596038611434130458611713285808338920316774188539936578031583233,
1469     33545808174778596038611434130458611713285808338920316774188539937677543211009,
1470     33545808174778596038611434130458611713285808338920316774188539938777054838785,
1471     33545808174778596038611434130458611713285808338920316774188539939876566466561,
1472     33545808174778596038611434130458611713285808338920316774188539940976078094337,
1473     33545808174778596038611434130458611713285808338920316774188539942075589722113,
1474     33545808174778596038611434130458611713285808338920316774188539943175101349889,
1475     33545808174778596038611434130458611713285808338920316774188539944274612977665,
1476     33545808174778596038611434130458611713285808338920316774188539945374124605441,
1477     33545808174778596038611434130458611713285808338920316774188539946473636233217,
1478     33545808174778596038611434130458611713285808338920316774188539947573147860993,
1479     33545808174778596038611434130458611713285808338920316774188539948672659488769,
1480     33545808174778596038611434130458611713285808338920316774188539949772171116545,
1481     33545808174778596038611434130458611713285808338920316774188539950871682744321,
1482     33545808174778596038611434130458611713285808338920316774188539951971194372097,
1483     33545808174778596038611434130458611713285808338920316774188539953070705999873,
1484     33545808174778596038611434130458611713285808338920316774188539954170217627649,
1485     33545808174778596038611434130458611713285808338920316774188539955269729255425,
1486     33545808174778596038611434130458611713285808338920316774188539956369240883201,
1487     33545808174778596038611434130458611713285808338920316774188539957468752510977,
1488     33545808174778596038611434130458611713285808338920316774188539958568264138753,
1489     33545808174778596038611434130458611713285808338920316774188539959667775766529,
1490     33545808174778596038611434130458611713285808338920316774188539960767287394305,
1491     33545808174778596038611434130458611713285808338920316774188539961866799022081,
1492     33545808174778596038611434130458611713285808338920316774188539962966310649857,
1493     33545808174778596038611434130458611713285808338920316774188539964065822277633,
1494     33545808174778596038611434130458611713285808338920316774188539965165333905409,
1495     33545808174778596038611434130458611713285808338920316774188539966264845533185,
1496     33545808174778596038611434130458611713285808338920316774188539967364357160961,
1497     33545808174778596038611434130458611713285808338920316774188539968463868788737,
1498     33545808174778596038611434130458611713285808338920316774188539969563380416513,
1499     33545808174778596038611434130458611713285808338920316774188539970662892044289,
1500     33545808174778596038611434130458611713285808338920316774188539971762403672065
1501     ];
1502 
1503     constructor(string memory baseURI, string memory initNotRevealedUri,bytes32 _merkleRoot)
1504     ERC721("CyberDucksEvolution", "CDE")
1505     {
1506         setBaseURI(baseURI);
1507         setNotRevealedURI(initNotRevealedUri);
1508         setMerkleRoot(_merkleRoot);
1509     }
1510 
1511     modifier preSaleIsOpen() {
1512         require(
1513             block.timestamp >= _saleTime - 172800, //2g
1514             "The presale has not yet started"
1515         );
1516         require(
1517             block.timestamp < _saleTime,
1518             "The public sale has already started"
1519         );
1520         _;
1521     }
1522 
1523     modifier saleIsOpen() {
1524         require(block.timestamp >= _saleTime, "Sale is not yet open");
1525         _;
1526     }
1527 
1528     function _baseURI() internal view virtual override returns (string memory) {
1529         return baseTokenURI;
1530     }
1531 
1532     function setPrice(uint256 _newWEIPrice) public onlyOwner {
1533         _price = _newWEIPrice;
1534     }
1535 
1536     function getSaleTime() public view returns (uint256) {
1537         return _saleTime;
1538     }
1539 
1540     function getPrice() public view returns (uint256) {
1541         return _price;
1542     }
1543 
1544     function getWLDucksMinted(address _address) internal view returns (uint256) {
1545         return addressToWLDucksMinted[_address];
1546     }
1547 
1548     function getWLDucksAmount() internal view returns (uint256) {
1549         uint256 ducksOwned = 0;
1550 
1551         for (uint i = 0; i < genesisDucks.length; i ++) {
1552             if(Opensea(OPENSEA_STORE).balanceOf(msg.sender,genesisDucks[i])){
1553                 ducksOwned += 1;
1554             }
1555         }
1556 
1557         if(ducksOwned == 0)
1558             ducksOwned = 1;
1559 
1560         return ducksOwned * 5;
1561     }
1562 
1563     function getGenesisDucks() internal returns (uint256) {
1564         uint256 ducksOwned = 0;
1565 
1566         for (uint i = 0; i < genesisDucks.length; i ++) {
1567             if(!ducksUsedForFree[genesisDucks[i]]){//Exclude genesis already used
1568                 if(Opensea(OPENSEA_STORE).balanceOf(msg.sender,genesisDucks[i])){
1569                     ducksOwned += 1;
1570                     ducksUsedForFree[genesisDucks[i]] = true;
1571                 }
1572             }
1573         }
1574 
1575         return ducksOwned;
1576     }
1577 
1578     function publicCheckFreeDucks() public view returns(uint256) {
1579         uint256 ducksOwned = 0;
1580 
1581         for (uint i = 0; i < genesisDucks.length; i ++) {
1582             if(!ducksUsedForFree[genesisDucks[i]]){//Exclude genesis already used
1583                 if(Opensea(OPENSEA_STORE).balanceOf(msg.sender,genesisDucks[i])){
1584                     ducksOwned += 1;
1585                 }
1586             }
1587         }
1588 
1589         return ducksOwned;
1590     }
1591 
1592     function getMintedDucks() public view returns(uint256){
1593         return totalSupply();
1594     }
1595 
1596     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) public pure returns (bool) {
1597         return MerkleProof.verify(root, leaf, proof);
1598     }
1599 
1600     function whiteListMint(uint256 _count,bytes32[] calldata _merkleProof) public payable preSaleIsOpen{
1601         uint256 totalSupply = totalSupply();
1602 
1603         require(
1604             !paused,
1605             "The contract is paused"
1606         );
1607 
1608         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1609 
1610         require(
1611             verify(_merkleProof, merkleRoot, leaf),
1612             "You are not in whitelist"
1613         );
1614 
1615         uint256 wlDucksAmount = getWLDucksAmount();
1616 
1617         if(addressToWLDucksMinted[msg.sender] + _count >= wlDucksAmount){
1618             _count = wlDucksAmount - addressToWLDucksMinted[msg.sender];
1619         }
1620 
1621         require(
1622             wlDucksAmount > 0,
1623             "No more Ducks to be minted"
1624         );
1625 
1626         require(
1627             _count <= _maxPerTx,
1628             "You can mint up to 10 Ducks per time"
1629         );
1630 
1631         require(
1632             _price_wl * _count <= msg.value,
1633             "Transaction value too low");
1634 
1635         for (uint256 i; i < _count; i++) {
1636             _safeMint(msg.sender, totalSupply + i);
1637         }
1638 
1639         addressToWLDucksMinted[msg.sender] += _count;
1640     }
1641 
1642     function freeMint() public payable {
1643         uint256 totalSupply = totalSupply();
1644 
1645         require(
1646             !paused,
1647             "The contract is paused"
1648         );
1649 
1650         uint256 _genesisDucks = getGenesisDucks();
1651 
1652         require(
1653             _genesisDucks > 0,
1654             "You cannot claim any other Ducks for free"
1655         );
1656 
1657         for (uint256 i; i < _genesisDucks; i++) {
1658             _safeMint(msg.sender, totalSupply + i);
1659         }
1660     }
1661 
1662     function mint(uint256 _count) public payable saleIsOpen{
1663         uint256 totalSupply = totalSupply();
1664 
1665         require(
1666             !paused,
1667             "The contract is paused"
1668         );
1669 
1670         require(
1671             _count > 0,
1672             "Mint at least 1 Duck"
1673         );
1674 
1675         require(
1676             _count <= _maxPerTx,
1677             "You can mint up to 10 Ducks per time"
1678         );
1679 
1680         require(
1681             totalSupply < MAX_DUCKS,
1682             "All Duck are already minted");
1683 
1684         require(
1685             totalSupply + _count <= MAX_DUCKS,
1686             "This amount of Ducks will exceed max supply"
1687         );
1688 
1689         require(
1690             _price * _count <= msg.value,
1691             "Transaction value too low");
1692 
1693         for (uint256 i; i < _count; i++) {
1694             _safeMint(msg.sender, totalSupply + i);
1695         }
1696     }
1697 
1698     function walletOfOwner(address _address) public view returns (uint256[] memory) {
1699         uint256 tokenCount = balanceOf(_address);
1700         if (tokenCount == 0) {
1701             return new uint256[](0);
1702         }
1703 
1704         uint256[] memory tokensId = new uint256[](tokenCount);
1705         for (uint256 i; i < tokenCount; i++) {
1706             tokensId[i] = tokenOfOwnerByIndex(_address, i);
1707         }
1708         return tokensId;
1709     }
1710 
1711     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1712         require(
1713             _exists(tokenId),
1714             "ERC721Metadata: URI query for nonexistent token"
1715         );
1716 
1717         if(revealed == false) {
1718             return notRevealedUri;
1719         }
1720 
1721         string memory currentBaseURI = _baseURI();
1722         return bytes(currentBaseURI).length > 0
1723         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1724         : "";
1725     }
1726 
1727     /*only owner*/
1728     function reveal(bool _reveal) public onlyOwner() {
1729         revealed = _reveal;
1730     }
1731 
1732     function pause(bool _state) public onlyOwner {
1733         paused = _state;
1734     }
1735 
1736     function setSaleTime(uint256 _time) public onlyOwner {
1737         _saleTime = _time;
1738     }
1739 
1740     function setBaseURI(string memory baseURI) public onlyOwner {
1741         baseTokenURI = baseURI;
1742     }
1743 
1744     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1745         merkleRoot = _merkleRoot;
1746     }
1747 
1748     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1749         baseExtension = _newBaseExtension;
1750     }
1751 
1752     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1753         notRevealedUri = _notRevealedURI;
1754     }
1755 
1756     function withdrawAll() public payable onlyOwner {
1757 
1758         (bool hs, ) = payable(0xA8AC6BFc4D6B1339A37574705B951475771f9a9D).call{value: address(this).balance * 15 / 100}("");
1759         require(hs);
1760 
1761         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1762         require(os);
1763     }
1764 
1765     function reserveDUCKS(uint256 _count) public onlyOwner {
1766         uint256 totalSupply = totalSupply();
1767 
1768         for (uint256 i; i < _count; i++) {
1769             _safeMint(msg.sender, totalSupply + i);
1770         }
1771     }
1772 }