1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Context.sol
71 
72 
73 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @dev Provides information about the current execution context, including the
79  * sender of the transaction and its data. While these are generally available
80  * via msg.sender and msg.data, they should not be accessed in such a direct
81  * manner, since when dealing with meta-transactions the account sending and
82  * paying for execution may not be the actual sender (as far as an application
83  * is concerned).
84  *
85  * This contract is only required for intermediate, library-like contracts.
86  */
87 abstract contract Context {
88     function _msgSender() internal view virtual returns (address) {
89         return msg.sender;
90     }
91 
92     function _msgData() internal view virtual returns (bytes calldata) {
93         return msg.data;
94     }
95 }
96 
97 // File: @openzeppelin/contracts/access/Ownable.sol
98 
99 
100 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
101 
102 pragma solidity ^0.8.0;
103 
104 
105 /**
106  * @dev Contract module which provides a basic access control mechanism, where
107  * there is an account (an owner) that can be granted exclusive access to
108  * specific functions.
109  *
110  * By default, the owner account will be the one that deploys the contract. This
111  * can later be changed with {transferOwnership}.
112  *
113  * This module is used through inheritance. It will make available the modifier
114  * `onlyOwner`, which can be applied to your functions to restrict their use to
115  * the owner.
116  */
117 abstract contract Ownable is Context {
118     address private _owner;
119 
120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122     /**
123      * @dev Initializes the contract setting the deployer as the initial owner.
124      */
125     constructor() {
126         _transferOwnership(_msgSender());
127     }
128 
129     /**
130      * @dev Returns the address of the current owner.
131      */
132     function owner() public view virtual returns (address) {
133         return _owner;
134     }
135 
136     /**
137      * @dev Throws if called by any account other than the owner.
138      */
139     modifier onlyOwner() {
140         require(owner() == _msgSender(), "Ownable: caller is not the owner");
141         _;
142     }
143 
144     /**
145      * @dev Leaves the contract without owner. It will not be possible to call
146      * `onlyOwner` functions anymore. Can only be called by the current owner.
147      *
148      * NOTE: Renouncing ownership will leave the contract without an owner,
149      * thereby removing any functionality that is only available to the owner.
150      */
151     function renounceOwnership() public virtual onlyOwner {
152         _transferOwnership(address(0));
153     }
154 
155     /**
156      * @dev Transfers ownership of the contract to a new account (`newOwner`).
157      * Can only be called by the current owner.
158      */
159     function transferOwnership(address newOwner) public virtual onlyOwner {
160         require(newOwner != address(0), "Ownable: new owner is the zero address");
161         _transferOwnership(newOwner);
162     }
163 
164     /**
165      * @dev Transfers ownership of the contract to a new account (`newOwner`).
166      * Internal function without access restriction.
167      */
168     function _transferOwnership(address newOwner) internal virtual {
169         address oldOwner = _owner;
170         _owner = newOwner;
171         emit OwnershipTransferred(oldOwner, newOwner);
172     }
173 }
174 
175 // File: @openzeppelin/contracts/utils/Address.sol
176 
177 
178 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @dev Collection of functions related to the address type
184  */
185 library Address {
186     /**
187      * @dev Returns true if `account` is a contract.
188      *
189      * [IMPORTANT]
190      * ====
191      * It is unsafe to assume that an address for which this function returns
192      * false is an externally-owned account (EOA) and not a contract.
193      *
194      * Among others, `isContract` will return false for the following
195      * types of addresses:
196      *
197      *  - an externally-owned account
198      *  - a contract in construction
199      *  - an address where a contract will be created
200      *  - an address where a contract lived, but was destroyed
201      * ====
202      */
203     function isContract(address account) internal view returns (bool) {
204         // This method relies on extcodesize, which returns 0 for contracts in
205         // construction, since the code is only stored at the end of the
206         // constructor execution.
207 
208         uint256 size;
209         assembly {
210             size := extcodesize(account)
211         }
212         return size > 0;
213     }
214 
215     /**
216      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
217      * `recipient`, forwarding all available gas and reverting on errors.
218      *
219      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
220      * of certain opcodes, possibly making contracts go over the 2300 gas limit
221      * imposed by `transfer`, making them unable to receive funds via
222      * `transfer`. {sendValue} removes this limitation.
223      *
224      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
225      *
226      * IMPORTANT: because control is transferred to `recipient`, care must be
227      * taken to not create reentrancy vulnerabilities. Consider using
228      * {ReentrancyGuard} or the
229      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
230      */
231     function sendValue(address payable recipient, uint256 amount) internal {
232         require(address(this).balance >= amount, "Address: insufficient balance");
233 
234         (bool success, ) = recipient.call{value: amount}("");
235         require(success, "Address: unable to send value, recipient may have reverted");
236     }
237 
238     /**
239      * @dev Performs a Solidity function call using a low level `call`. A
240      * plain `call` is an unsafe replacement for a function call: use this
241      * function instead.
242      *
243      * If `target` reverts with a revert reason, it is bubbled up by this
244      * function (like regular Solidity function calls).
245      *
246      * Returns the raw returned data. To convert to the expected return value,
247      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
248      *
249      * Requirements:
250      *
251      * - `target` must be a contract.
252      * - calling `target` with `data` must not revert.
253      *
254      * _Available since v3.1._
255      */
256     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
257         return functionCall(target, data, "Address: low-level call failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
262      * `errorMessage` as a fallback revert reason when `target` reverts.
263      *
264      * _Available since v3.1._
265      */
266     function functionCall(
267         address target,
268         bytes memory data,
269         string memory errorMessage
270     ) internal returns (bytes memory) {
271         return functionCallWithValue(target, data, 0, errorMessage);
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
276      * but also transferring `value` wei to `target`.
277      *
278      * Requirements:
279      *
280      * - the calling contract must have an ETH balance of at least `value`.
281      * - the called Solidity function must be `payable`.
282      *
283      * _Available since v3.1._
284      */
285     function functionCallWithValue(
286         address target,
287         bytes memory data,
288         uint256 value
289     ) internal returns (bytes memory) {
290         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
295      * with `errorMessage` as a fallback revert reason when `target` reverts.
296      *
297      * _Available since v3.1._
298      */
299     function functionCallWithValue(
300         address target,
301         bytes memory data,
302         uint256 value,
303         string memory errorMessage
304     ) internal returns (bytes memory) {
305         require(address(this).balance >= value, "Address: insufficient balance for call");
306         require(isContract(target), "Address: call to non-contract");
307 
308         (bool success, bytes memory returndata) = target.call{value: value}(data);
309         return verifyCallResult(success, returndata, errorMessage);
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
314      * but performing a static call.
315      *
316      * _Available since v3.3._
317      */
318     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
319         return functionStaticCall(target, data, "Address: low-level static call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
324      * but performing a static call.
325      *
326      * _Available since v3.3._
327      */
328     function functionStaticCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal view returns (bytes memory) {
333         require(isContract(target), "Address: static call to non-contract");
334 
335         (bool success, bytes memory returndata) = target.staticcall(data);
336         return verifyCallResult(success, returndata, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but performing a delegate call.
342      *
343      * _Available since v3.4._
344      */
345     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
346         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
351      * but performing a delegate call.
352      *
353      * _Available since v3.4._
354      */
355     function functionDelegateCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal returns (bytes memory) {
360         require(isContract(target), "Address: delegate call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.delegatecall(data);
363         return verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
368      * revert reason using the provided one.
369      *
370      * _Available since v4.3._
371      */
372     function verifyCallResult(
373         bool success,
374         bytes memory returndata,
375         string memory errorMessage
376     ) internal pure returns (bytes memory) {
377         if (success) {
378             return returndata;
379         } else {
380             // Look for revert reason and bubble it up if present
381             if (returndata.length > 0) {
382                 // The easiest way to bubble the revert reason is using memory via assembly
383 
384                 assembly {
385                     let returndata_size := mload(returndata)
386                     revert(add(32, returndata), returndata_size)
387                 }
388             } else {
389                 revert(errorMessage);
390             }
391         }
392     }
393 }
394 
395 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
396 
397 
398 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 /**
403  * @title ERC721 token receiver interface
404  * @dev Interface for any contract that wants to support safeTransfers
405  * from ERC721 asset contracts.
406  */
407 interface IERC721Receiver {
408     /**
409      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
410      * by `operator` from `from`, this function is called.
411      *
412      * It must return its Solidity selector to confirm the token transfer.
413      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
414      *
415      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
416      */
417     function onERC721Received(
418         address operator,
419         address from,
420         uint256 tokenId,
421         bytes calldata data
422     ) external returns (bytes4);
423 }
424 
425 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
426 
427 
428 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
429 
430 pragma solidity ^0.8.0;
431 
432 /**
433  * @dev Interface of the ERC165 standard, as defined in the
434  * https://eips.ethereum.org/EIPS/eip-165[EIP].
435  *
436  * Implementers can declare support of contract interfaces, which can then be
437  * queried by others ({ERC165Checker}).
438  *
439  * For an implementation, see {ERC165}.
440  */
441 interface IERC165 {
442     /**
443      * @dev Returns true if this contract implements the interface defined by
444      * `interfaceId`. See the corresponding
445      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
446      * to learn more about how these ids are created.
447      *
448      * This function call must use less than 30 000 gas.
449      */
450     function supportsInterface(bytes4 interfaceId) external view returns (bool);
451 }
452 
453 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
454 
455 
456 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 
461 /**
462  * @dev Implementation of the {IERC165} interface.
463  *
464  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
465  * for the additional interface id that will be supported. For example:
466  *
467  * ```solidity
468  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
469  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
470  * }
471  * ```
472  *
473  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
474  */
475 abstract contract ERC165 is IERC165 {
476     /**
477      * @dev See {IERC165-supportsInterface}.
478      */
479     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
480         return interfaceId == type(IERC165).interfaceId;
481     }
482 }
483 
484 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
485 
486 
487 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 
492 /**
493  * @dev Required interface of an ERC721 compliant contract.
494  */
495 interface IERC721 is IERC165 {
496     /**
497      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
498      */
499     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
500 
501     /**
502      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
503      */
504     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
505 
506     /**
507      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
508      */
509     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
510 
511     /**
512      * @dev Returns the number of tokens in ``owner``'s account.
513      */
514     function balanceOf(address owner) external view returns (uint256 balance);
515 
516     /**
517      * @dev Returns the owner of the `tokenId` token.
518      *
519      * Requirements:
520      *
521      * - `tokenId` must exist.
522      */
523     function ownerOf(uint256 tokenId) external view returns (address owner);
524 
525     /**
526      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
527      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
528      *
529      * Requirements:
530      *
531      * - `from` cannot be the zero address.
532      * - `to` cannot be the zero address.
533      * - `tokenId` token must exist and be owned by `from`.
534      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
535      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
536      *
537      * Emits a {Transfer} event.
538      */
539     function safeTransferFrom(
540         address from,
541         address to,
542         uint256 tokenId
543     ) external;
544 
545     /**
546      * @dev Transfers `tokenId` token from `from` to `to`.
547      *
548      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
549      *
550      * Requirements:
551      *
552      * - `from` cannot be the zero address.
553      * - `to` cannot be the zero address.
554      * - `tokenId` token must be owned by `from`.
555      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
556      *
557      * Emits a {Transfer} event.
558      */
559     function transferFrom(
560         address from,
561         address to,
562         uint256 tokenId
563     ) external;
564 
565     /**
566      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
567      * The approval is cleared when the token is transferred.
568      *
569      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
570      *
571      * Requirements:
572      *
573      * - The caller must own the token or be an approved operator.
574      * - `tokenId` must exist.
575      *
576      * Emits an {Approval} event.
577      */
578     function approve(address to, uint256 tokenId) external;
579 
580     /**
581      * @dev Returns the account approved for `tokenId` token.
582      *
583      * Requirements:
584      *
585      * - `tokenId` must exist.
586      */
587     function getApproved(uint256 tokenId) external view returns (address operator);
588 
589     /**
590      * @dev Approve or remove `operator` as an operator for the caller.
591      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
592      *
593      * Requirements:
594      *
595      * - The `operator` cannot be the caller.
596      *
597      * Emits an {ApprovalForAll} event.
598      */
599     function setApprovalForAll(address operator, bool _approved) external;
600 
601     /**
602      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
603      *
604      * See {setApprovalForAll}
605      */
606     function isApprovedForAll(address owner, address operator) external view returns (bool);
607 
608     /**
609      * @dev Safely transfers `tokenId` token from `from` to `to`.
610      *
611      * Requirements:
612      *
613      * - `from` cannot be the zero address.
614      * - `to` cannot be the zero address.
615      * - `tokenId` token must exist and be owned by `from`.
616      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
617      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
618      *
619      * Emits a {Transfer} event.
620      */
621     function safeTransferFrom(
622         address from,
623         address to,
624         uint256 tokenId,
625         bytes calldata data
626     ) external;
627 }
628 
629 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
630 
631 
632 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
633 
634 pragma solidity ^0.8.0;
635 
636 
637 /**
638  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
639  * @dev See https://eips.ethereum.org/EIPS/eip-721
640  */
641 interface IERC721Enumerable is IERC721 {
642     /**
643      * @dev Returns the total amount of tokens stored by the contract.
644      */
645     function totalSupply() external view returns (uint256);
646 
647     /**
648      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
649      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
650      */
651     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
652 
653     /**
654      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
655      * Use along with {totalSupply} to enumerate all tokens.
656      */
657     function tokenByIndex(uint256 index) external view returns (uint256);
658 }
659 
660 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
661 
662 
663 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 
668 /**
669  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
670  * @dev See https://eips.ethereum.org/EIPS/eip-721
671  */
672 interface IERC721Metadata is IERC721 {
673     /**
674      * @dev Returns the token collection name.
675      */
676     function name() external view returns (string memory);
677 
678     /**
679      * @dev Returns the token collection symbol.
680      */
681     function symbol() external view returns (string memory);
682 
683     /**
684      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
685      */
686     function tokenURI(uint256 tokenId) external view returns (string memory);
687 }
688 
689 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
690 
691 
692 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
693 
694 pragma solidity ^0.8.0;
695 
696 
697 
698 
699 
700 
701 
702 
703 /**
704  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
705  * the Metadata extension, but not including the Enumerable extension, which is available separately as
706  * {ERC721Enumerable}.
707  */
708 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
709     using Address for address;
710     using Strings for uint256;
711 
712     // Token name
713     string private _name;
714 
715     // Token symbol
716     string private _symbol;
717 
718     // Mapping from token ID to owner address
719     mapping(uint256 => address) private _owners;
720 
721     // Mapping owner address to token count
722     mapping(address => uint256) private _balances;
723 
724     // Mapping from token ID to approved address
725     mapping(uint256 => address) private _tokenApprovals;
726 
727     // Mapping from owner to operator approvals
728     mapping(address => mapping(address => bool)) private _operatorApprovals;
729 
730     /**
731      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
732      */
733     constructor(string memory name_, string memory symbol_) {
734         _name = name_;
735         _symbol = symbol_;
736     }
737 
738     /**
739      * @dev See {IERC165-supportsInterface}.
740      */
741     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
742         return
743             interfaceId == type(IERC721).interfaceId ||
744             interfaceId == type(IERC721Metadata).interfaceId ||
745             super.supportsInterface(interfaceId);
746     }
747 
748     /**
749      * @dev See {IERC721-balanceOf}.
750      */
751     function balanceOf(address owner) public view virtual override returns (uint256) {
752         require(owner != address(0), "ERC721: balance query for the zero address");
753         return _balances[owner];
754     }
755 
756     /**
757      * @dev See {IERC721-ownerOf}.
758      */
759     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
760         address owner = _owners[tokenId];
761         require(owner != address(0), "ERC721: owner query for nonexistent token");
762         return owner;
763     }
764 
765     /**
766      * @dev See {IERC721Metadata-name}.
767      */
768     function name() public view virtual override returns (string memory) {
769         return _name;
770     }
771 
772     /**
773      * @dev See {IERC721Metadata-symbol}.
774      */
775     function symbol() public view virtual override returns (string memory) {
776         return _symbol;
777     }
778 
779     /**
780      * @dev See {IERC721Metadata-tokenURI}.
781      */
782     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
783         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
784 
785         string memory baseURI = _baseURI();
786         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
787     }
788 
789     /**
790      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
791      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
792      * by default, can be overriden in child contracts.
793      */
794     function _baseURI() internal view virtual returns (string memory) {
795         return "";
796     }
797 
798     /**
799      * @dev See {IERC721-approve}.
800      */
801     function approve(address to, uint256 tokenId) public virtual override {
802         address owner = ERC721.ownerOf(tokenId);
803         require(to != owner, "ERC721: approval to current owner");
804 
805         require(
806             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
807             "ERC721: approve caller is not owner nor approved for all"
808         );
809 
810         _approve(to, tokenId);
811     }
812 
813     /**
814      * @dev See {IERC721-getApproved}.
815      */
816     function getApproved(uint256 tokenId) public view virtual override returns (address) {
817         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
818 
819         return _tokenApprovals[tokenId];
820     }
821 
822     /**
823      * @dev See {IERC721-setApprovalForAll}.
824      */
825     function setApprovalForAll(address operator, bool approved) public virtual override {
826         _setApprovalForAll(_msgSender(), operator, approved);
827     }
828 
829     /**
830      * @dev See {IERC721-isApprovedForAll}.
831      */
832     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
833         return _operatorApprovals[owner][operator];
834     }
835 
836     /**
837      * @dev See {IERC721-transferFrom}.
838      */
839     function transferFrom(
840         address from,
841         address to,
842         uint256 tokenId
843     ) public virtual override {
844         //solhint-disable-next-line max-line-length
845         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
846 
847         _transfer(from, to, tokenId);
848     }
849 
850     /**
851      * @dev See {IERC721-safeTransferFrom}.
852      */
853     function safeTransferFrom(
854         address from,
855         address to,
856         uint256 tokenId
857     ) public virtual override {
858         safeTransferFrom(from, to, tokenId, "");
859     }
860 
861     /**
862      * @dev See {IERC721-safeTransferFrom}.
863      */
864     function safeTransferFrom(
865         address from,
866         address to,
867         uint256 tokenId,
868         bytes memory _data
869     ) public virtual override {
870         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
871         _safeTransfer(from, to, tokenId, _data);
872     }
873 
874     /**
875      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
876      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
877      *
878      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
879      *
880      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
881      * implement alternative mechanisms to perform token transfer, such as signature-based.
882      *
883      * Requirements:
884      *
885      * - `from` cannot be the zero address.
886      * - `to` cannot be the zero address.
887      * - `tokenId` token must exist and be owned by `from`.
888      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
889      *
890      * Emits a {Transfer} event.
891      */
892     function _safeTransfer(
893         address from,
894         address to,
895         uint256 tokenId,
896         bytes memory _data
897     ) internal virtual {
898         _transfer(from, to, tokenId);
899         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
900     }
901 
902     /**
903      * @dev Returns whether `tokenId` exists.
904      *
905      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
906      *
907      * Tokens start existing when they are minted (`_mint`),
908      * and stop existing when they are burned (`_burn`).
909      */
910     function _exists(uint256 tokenId) internal view virtual returns (bool) {
911         return _owners[tokenId] != address(0);
912     }
913 
914     /**
915      * @dev Returns whether `spender` is allowed to manage `tokenId`.
916      *
917      * Requirements:
918      *
919      * - `tokenId` must exist.
920      */
921     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
922         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
923         address owner = ERC721.ownerOf(tokenId);
924         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
925     }
926 
927     /**
928      * @dev Safely mints `tokenId` and transfers it to `to`.
929      *
930      * Requirements:
931      *
932      * - `tokenId` must not exist.
933      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
934      *
935      * Emits a {Transfer} event.
936      */
937     function _safeMint(address to, uint256 tokenId) internal virtual {
938         _safeMint(to, tokenId, "");
939     }
940 
941     /**
942      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
943      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
944      */
945     function _safeMint(
946         address to,
947         uint256 tokenId,
948         bytes memory _data
949     ) internal virtual {
950         _mint(to, tokenId);
951         require(
952             _checkOnERC721Received(address(0), to, tokenId, _data),
953             "ERC721: transfer to non ERC721Receiver implementer"
954         );
955     }
956 
957     /**
958      * @dev Mints `tokenId` and transfers it to `to`.
959      *
960      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
961      *
962      * Requirements:
963      *
964      * - `tokenId` must not exist.
965      * - `to` cannot be the zero address.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _mint(address to, uint256 tokenId) internal virtual {
970         require(to != address(0), "ERC721: mint to the zero address");
971         require(!_exists(tokenId), "ERC721: token already minted");
972 
973         _beforeTokenTransfer(address(0), to, tokenId);
974 
975         _balances[to] += 1;
976         _owners[tokenId] = to;
977 
978         emit Transfer(address(0), to, tokenId);
979     }
980 
981     /**
982      * @dev Destroys `tokenId`.
983      * The approval is cleared when the token is burned.
984      *
985      * Requirements:
986      *
987      * - `tokenId` must exist.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _burn(uint256 tokenId) internal virtual {
992         address owner = ERC721.ownerOf(tokenId);
993 
994         _beforeTokenTransfer(owner, address(0), tokenId);
995 
996         // Clear approvals
997         _approve(address(0), tokenId);
998 
999         _balances[owner] -= 1;
1000         delete _owners[tokenId];
1001 
1002         emit Transfer(owner, address(0), tokenId);
1003     }
1004 
1005     /**
1006      * @dev Transfers `tokenId` from `from` to `to`.
1007      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1008      *
1009      * Requirements:
1010      *
1011      * - `to` cannot be the zero address.
1012      * - `tokenId` token must be owned by `from`.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function _transfer(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) internal virtual {
1021         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1022         require(to != address(0), "ERC721: transfer to the zero address");
1023 
1024         _beforeTokenTransfer(from, to, tokenId);
1025 
1026         // Clear approvals from the previous owner
1027         _approve(address(0), tokenId);
1028 
1029         _balances[from] -= 1;
1030         _balances[to] += 1;
1031         _owners[tokenId] = to;
1032 
1033         emit Transfer(from, to, tokenId);
1034     }
1035 
1036     /**
1037      * @dev Approve `to` to operate on `tokenId`
1038      *
1039      * Emits a {Approval} event.
1040      */
1041     function _approve(address to, uint256 tokenId) internal virtual {
1042         _tokenApprovals[tokenId] = to;
1043         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1044     }
1045 
1046     /**
1047      * @dev Approve `operator` to operate on all of `owner` tokens
1048      *
1049      * Emits a {ApprovalForAll} event.
1050      */
1051     function _setApprovalForAll(
1052         address owner,
1053         address operator,
1054         bool approved
1055     ) internal virtual {
1056         require(owner != operator, "ERC721: approve to caller");
1057         _operatorApprovals[owner][operator] = approved;
1058         emit ApprovalForAll(owner, operator, approved);
1059     }
1060 
1061     /**
1062      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1063      * The call is not executed if the target address is not a contract.
1064      *
1065      * @param from address representing the previous owner of the given token ID
1066      * @param to target address that will receive the tokens
1067      * @param tokenId uint256 ID of the token to be transferred
1068      * @param _data bytes optional data to send along with the call
1069      * @return bool whether the call correctly returned the expected magic value
1070      */
1071     function _checkOnERC721Received(
1072         address from,
1073         address to,
1074         uint256 tokenId,
1075         bytes memory _data
1076     ) private returns (bool) {
1077         if (to.isContract()) {
1078             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1079                 return retval == IERC721Receiver.onERC721Received.selector;
1080             } catch (bytes memory reason) {
1081                 if (reason.length == 0) {
1082                     revert("ERC721: transfer to non ERC721Receiver implementer");
1083                 } else {
1084                     assembly {
1085                         revert(add(32, reason), mload(reason))
1086                     }
1087                 }
1088             }
1089         } else {
1090             return true;
1091         }
1092     }
1093 
1094     /**
1095      * @dev Hook that is called before any token transfer. This includes minting
1096      * and burning.
1097      *
1098      * Calling conditions:
1099      *
1100      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1101      * transferred to `to`.
1102      * - When `from` is zero, `tokenId` will be minted for `to`.
1103      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1104      * - `from` and `to` are never both zero.
1105      *
1106      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1107      */
1108     function _beforeTokenTransfer(
1109         address from,
1110         address to,
1111         uint256 tokenId
1112     ) internal virtual {}
1113 }
1114 
1115 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1116 
1117 
1118 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1119 
1120 pragma solidity ^0.8.0;
1121 
1122 
1123 
1124 /**
1125  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1126  * enumerability of all the token ids in the contract as well as all token ids owned by each
1127  * account.
1128  */
1129 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1130     // Mapping from owner to list of owned token IDs
1131     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1132 
1133     // Mapping from token ID to index of the owner tokens list
1134     mapping(uint256 => uint256) private _ownedTokensIndex;
1135 
1136     // Array with all token ids, used for enumeration
1137     uint256[] private _allTokens;
1138 
1139     // Mapping from token id to position in the allTokens array
1140     mapping(uint256 => uint256) private _allTokensIndex;
1141 
1142     /**
1143      * @dev See {IERC165-supportsInterface}.
1144      */
1145     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1146         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1147     }
1148 
1149     /**
1150      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1151      */
1152     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1153         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1154         return _ownedTokens[owner][index];
1155     }
1156 
1157     /**
1158      * @dev See {IERC721Enumerable-totalSupply}.
1159      */
1160     function totalSupply() public view virtual override returns (uint256) {
1161         return _allTokens.length;
1162     }
1163 
1164     /**
1165      * @dev See {IERC721Enumerable-tokenByIndex}.
1166      */
1167     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1168         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1169         return _allTokens[index];
1170     }
1171 
1172     /**
1173      * @dev Hook that is called before any token transfer. This includes minting
1174      * and burning.
1175      *
1176      * Calling conditions:
1177      *
1178      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1179      * transferred to `to`.
1180      * - When `from` is zero, `tokenId` will be minted for `to`.
1181      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1182      * - `from` cannot be the zero address.
1183      * - `to` cannot be the zero address.
1184      *
1185      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1186      */
1187     function _beforeTokenTransfer(
1188         address from,
1189         address to,
1190         uint256 tokenId
1191     ) internal virtual override {
1192         super._beforeTokenTransfer(from, to, tokenId);
1193 
1194         if (from == address(0)) {
1195             _addTokenToAllTokensEnumeration(tokenId);
1196         } else if (from != to) {
1197             _removeTokenFromOwnerEnumeration(from, tokenId);
1198         }
1199         if (to == address(0)) {
1200             _removeTokenFromAllTokensEnumeration(tokenId);
1201         } else if (to != from) {
1202             _addTokenToOwnerEnumeration(to, tokenId);
1203         }
1204     }
1205 
1206     /**
1207      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1208      * @param to address representing the new owner of the given token ID
1209      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1210      */
1211     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1212         uint256 length = ERC721.balanceOf(to);
1213         _ownedTokens[to][length] = tokenId;
1214         _ownedTokensIndex[tokenId] = length;
1215     }
1216 
1217     /**
1218      * @dev Private function to add a token to this extension's token tracking data structures.
1219      * @param tokenId uint256 ID of the token to be added to the tokens list
1220      */
1221     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1222         _allTokensIndex[tokenId] = _allTokens.length;
1223         _allTokens.push(tokenId);
1224     }
1225 
1226     /**
1227      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1228      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1229      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1230      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1231      * @param from address representing the previous owner of the given token ID
1232      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1233      */
1234     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1235         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1236         // then delete the last slot (swap and pop).
1237 
1238         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1239         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1240 
1241         // When the token to delete is the last token, the swap operation is unnecessary
1242         if (tokenIndex != lastTokenIndex) {
1243             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1244 
1245             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1246             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1247         }
1248 
1249         // This also deletes the contents at the last position of the array
1250         delete _ownedTokensIndex[tokenId];
1251         delete _ownedTokens[from][lastTokenIndex];
1252     }
1253 
1254     /**
1255      * @dev Private function to remove a token from this extension's token tracking data structures.
1256      * This has O(1) time complexity, but alters the order of the _allTokens array.
1257      * @param tokenId uint256 ID of the token to be removed from the tokens list
1258      */
1259     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1260         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1261         // then delete the last slot (swap and pop).
1262 
1263         uint256 lastTokenIndex = _allTokens.length - 1;
1264         uint256 tokenIndex = _allTokensIndex[tokenId];
1265 
1266         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1267         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1268         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1269         uint256 lastTokenId = _allTokens[lastTokenIndex];
1270 
1271         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1272         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1273 
1274         // This also deletes the contents at the last position of the array
1275         delete _allTokensIndex[tokenId];
1276         _allTokens.pop();
1277     }
1278 }
1279 
1280 // File: contracts/MetaDoge.sol
1281 
1282 
1283 
1284 pragma solidity >=0.7.0 <0.9.0;
1285 
1286 
1287 
1288 contract MetaDoge is ERC721Enumerable, Ownable   {
1289   using Strings for uint256;
1290 
1291   string public baseURI;
1292   string public baseExtension = "";
1293   uint256 public cost = 0.03 ether;
1294   uint256 public maxSupply = 9999;
1295   uint256 public maxMintAmount = 20;
1296   uint256 public maxWhitelistMintAmount = 1;
1297   uint256 public presaleSupply = 249;
1298   uint256 public whitelistSupply = 9651;
1299   bool public paused = false;
1300   mapping(address => bool) public whitelisted;
1301   address payable public payments;
1302 
1303   constructor(
1304     string memory _name,
1305     string memory _symbol,
1306     string memory _initBaseURI,
1307     address _payments
1308   ) ERC721(_name, _symbol) {
1309     setBaseURI(_initBaseURI);
1310     payments = payable(_payments);
1311   }
1312 
1313   // internal
1314   function _baseURI() internal view virtual override returns (string memory) {
1315     return baseURI;
1316   }
1317 
1318   // public
1319   function mint(address _to, uint256 _mintAmount) public payable {
1320     uint256 supply = totalSupply();
1321     require(!paused);
1322     require(_mintAmount > 0);
1323 
1324     if (msg.sender != owner()) {
1325       if(whitelisted[msg.sender] != true) {
1326         require(supply + _mintAmount <= maxSupply - presaleSupply - whitelistSupply);
1327         require(_mintAmount <= maxMintAmount);
1328         require(msg.value >= cost * _mintAmount);
1329       } else {
1330         require(supply + _mintAmount <= maxSupply - presaleSupply);
1331         require(_mintAmount <= maxWhitelistMintAmount);
1332         whitelisted[msg.sender] = false;
1333       }
1334     }
1335     else {
1336       require(supply + _mintAmount <= maxSupply);
1337     }
1338     
1339     for (uint256 i = 1; i <= _mintAmount; i++) {
1340       _safeMint(_to, supply + i);
1341     }
1342   }
1343 
1344   function walletOfOwner(address _owner)
1345     public
1346     view
1347     returns (uint256[] memory)
1348   {
1349     uint256 ownerTokenCount = balanceOf(_owner);
1350     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1351     for (uint256 i; i < ownerTokenCount; i++) {
1352       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1353     }
1354     return tokenIds;
1355   }
1356 
1357   function tokenURI(uint256 tokenId)
1358     public
1359     view
1360     virtual
1361     override
1362     returns (string memory)
1363   {
1364     require(
1365       _exists(tokenId),
1366       "ERC721Metadata: URI query for nonexistent token"
1367     );
1368 
1369     string memory currentBaseURI = _baseURI();
1370     return bytes(currentBaseURI).length > 0
1371         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1372         : "";
1373   }
1374 
1375   //only owner
1376   function setPayments(address payable _newPayments) public onlyOwner {
1377     payments = _newPayments;
1378   }
1379 
1380   function setCost(uint256 _newCost) public onlyOwner {
1381     cost = _newCost;
1382   }
1383 
1384   function setPresaleSupply(uint256 _newPresaleSupply) public onlyOwner {
1385     presaleSupply = _newPresaleSupply;
1386   }
1387 
1388   function setWhitelistSupply(uint256 _newWhitelistSupply) public onlyOwner {
1389     whitelistSupply = _newWhitelistSupply;
1390   }
1391 
1392   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1393     maxMintAmount = _newmaxMintAmount;
1394   }
1395 
1396   function setmaxWhitelistMintAmount(uint256 _newmaxWhitelistMintAmount) public onlyOwner {
1397     maxWhitelistMintAmount = _newmaxWhitelistMintAmount;
1398   }
1399 
1400   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1401     baseURI = _newBaseURI;
1402   }
1403 
1404   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1405     baseExtension = _newBaseExtension;
1406   }
1407 
1408   function pause(bool _state) public onlyOwner {
1409     paused = _state;
1410   }
1411  
1412  function whitelistUser(address _user) public onlyOwner {
1413     whitelisted[_user] = true;
1414   }
1415  
1416   function removeWhitelistUser(address _user) public onlyOwner {
1417     whitelisted[_user] = false;
1418   }
1419 
1420   function withdraw() public payable onlyOwner {
1421     (bool success, ) = payable(payments).call{value: address(this).balance}("");
1422     require(success);
1423   }
1424 }