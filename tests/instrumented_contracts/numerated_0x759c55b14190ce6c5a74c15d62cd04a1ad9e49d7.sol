1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity ^0.8.7;
4 
5 
6 /**
7  * @dev String operations.
8  */
9 library Strings {
10     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
11 
12     /**
13      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
14      */
15     function toString(uint256 value) internal pure returns (string memory) {
16         // Inspired by OraclizeAPI's implementation - MIT licence
17         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
18 
19         if (value == 0) {
20             return "0";
21         }
22         uint256 temp = value;
23         uint256 digits;
24         while (temp != 0) {
25             digits++;
26             temp /= 10;
27         }
28         bytes memory buffer = new bytes(digits);
29         while (value != 0) {
30             digits -= 1;
31             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
32             value /= 10;
33         }
34         return string(buffer);
35     }
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
39      */
40     function toHexString(uint256 value) internal pure returns (string memory) {
41         if (value == 0) {
42             return "0x00";
43         }
44         uint256 temp = value;
45         uint256 length = 0;
46         while (temp != 0) {
47             length++;
48             temp >>= 8;
49         }
50         return toHexString(value, length);
51     }
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
55      */
56     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
57         bytes memory buffer = new bytes(2 * length + 2);
58         buffer[0] = "0";
59         buffer[1] = "x";
60         for (uint256 i = 2 * length + 1; i > 1; --i) {
61             buffer[i] = _HEX_SYMBOLS[value & 0xf];
62             value >>= 4;
63         }
64         require(value == 0, "Strings: hex length insufficient");
65         return string(buffer);
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Context.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
73 
74 
75 
76 /**
77  * @dev Provides information about the current execution context, including the
78  * sender of the transaction and its data. While these are generally available
79  * via msg.sender and msg.data, they should not be accessed in such a direct
80  * manner, since when dealing with meta-transactions the account sending and
81  * paying for execution may not be the actual sender (as far as an application
82  * is concerned).
83  *
84  * This contract is only required for intermediate, library-like contracts.
85  */
86 abstract contract Context {
87     function _msgSender() internal view virtual returns (address) {
88         return msg.sender;
89     }
90 
91     function _msgData() internal view virtual returns (bytes calldata) {
92         return msg.data;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/access/Ownable.sol
97 
98 
99 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
100 
101 
102 
103 
104 /**
105  * @dev Contract module which provides a basic access control mechanism, where
106  * there is an account (an owner) that can be granted exclusive access to
107  * specific functions.
108  *
109  * By default, the owner account will be the one that deploys the contract. This
110  * can later be changed with {transferOwnership}.
111  *
112  * This module is used through inheritance. It will make available the modifier
113  * `onlyOwner`, which can be applied to your functions to restrict their use to
114  * the owner.
115  */
116 abstract contract Ownable is Context {
117     address private _owner;
118 
119     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
120 
121     /**
122      * @dev Initializes the contract setting the deployer as the initial owner.
123      */
124     constructor() {
125         _transferOwnership(_msgSender());
126     }
127 
128     /**
129      * @dev Returns the address of the current owner.
130      */
131     function owner() public view virtual returns (address) {
132         return _owner;
133     }
134 
135     /**
136      * @dev Throws if called by any account other than the owner.
137      */
138     modifier onlyOwner() {
139         require(owner() == _msgSender(), "Ownable: caller is not the owner");
140         _;
141     }
142 
143     /**
144      * @dev Leaves the contract without owner. It will not be possible to call
145      * `onlyOwner` functions anymore. Can only be called by the current owner.
146      *
147      * NOTE: Renouncing ownership will leave the contract without an owner,
148      * thereby removing any functionality that is only available to the owner.
149      */
150     function renounceOwnership() public virtual onlyOwner {
151         _transferOwnership(address(0));
152     }
153 
154     /**
155      * @dev Transfers ownership of the contract to a new account (`newOwner`).
156      * Can only be called by the current owner.
157      */
158     function transferOwnership(address newOwner) public virtual onlyOwner {
159         require(newOwner != address(0), "Ownable: new owner is the zero address");
160         _transferOwnership(newOwner);
161     }
162 
163     /**
164      * @dev Transfers ownership of the contract to a new account (`newOwner`).
165      * Internal function without access restriction.
166      */
167     function _transferOwnership(address newOwner) internal virtual {
168         address oldOwner = _owner;
169         _owner = newOwner;
170         emit OwnershipTransferred(oldOwner, newOwner);
171     }
172 }
173 
174 // File: @openzeppelin/contracts/utils/Address.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
178 
179 
180 
181 /**
182  * @dev Collection of functions related to the address type
183  */
184 library Address {
185     /**
186      * @dev Returns true if `account` is a contract.
187      *
188      * [IMPORTANT]
189      * ====
190      * It is unsafe to assume that an address for which this function returns
191      * false is an externally-owned account (EOA) and not a contract.
192      *
193      * Among others, `isContract` will return false for the following
194      * types of addresses:
195      *
196      *  - an externally-owned account
197      *  - a contract in construction
198      *  - an address where a contract will be created
199      *  - an address where a contract lived, but was destroyed
200      * ====
201      */
202     function isContract(address account) internal view returns (bool) {
203         // This method relies on extcodesize, which returns 0 for contracts in
204         // construction, since the code is only stored at the end of the
205         // constructor execution.
206 
207         uint256 size;
208         assembly {
209             size := extcodesize(account)
210         }
211         return size > 0;
212     }
213 
214     /**
215      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
216      * `recipient`, forwarding all available gas and reverting on errors.
217      *
218      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
219      * of certain opcodes, possibly making contracts go over the 2300 gas limit
220      * imposed by `transfer`, making them unable to receive funds via
221      * `transfer`. {sendValue} removes this limitation.
222      *
223      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
224      *
225      * IMPORTANT: because control is transferred to `recipient`, care must be
226      * taken to not create reentrancy vulnerabilities. Consider using
227      * {ReentrancyGuard} or the
228      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
229      */
230     function sendValue(address payable recipient, uint256 amount) internal {
231         require(address(this).balance >= amount, "Address: insufficient balance");
232 
233         (bool success, ) = recipient.call{value: amount}("");
234         require(success, "Address: unable to send value, recipient may have reverted");
235     }
236 
237     /**
238      * @dev Performs a Solidity function call using a low level `call`. A
239      * plain `call` is an unsafe replacement for a function call: use this
240      * function instead.
241      *
242      * If `target` reverts with a revert reason, it is bubbled up by this
243      * function (like regular Solidity function calls).
244      *
245      * Returns the raw returned data. To convert to the expected return value,
246      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
247      *
248      * Requirements:
249      *
250      * - `target` must be a contract.
251      * - calling `target` with `data` must not revert.
252      *
253      * _Available since v3.1._
254      */
255     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
256         return functionCall(target, data, "Address: low-level call failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
261      * `errorMessage` as a fallback revert reason when `target` reverts.
262      *
263      * _Available since v3.1._
264      */
265     function functionCall(
266         address target,
267         bytes memory data,
268         string memory errorMessage
269     ) internal returns (bytes memory) {
270         return functionCallWithValue(target, data, 0, errorMessage);
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
275      * but also transferring `value` wei to `target`.
276      *
277      * Requirements:
278      *
279      * - the calling contract must have an ETH balance of at least `value`.
280      * - the called Solidity function must be `payable`.
281      *
282      * _Available since v3.1._
283      */
284     function functionCallWithValue(
285         address target,
286         bytes memory data,
287         uint256 value
288     ) internal returns (bytes memory) {
289         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
294      * with `errorMessage` as a fallback revert reason when `target` reverts.
295      *
296      * _Available since v3.1._
297      */
298     function functionCallWithValue(
299         address target,
300         bytes memory data,
301         uint256 value,
302         string memory errorMessage
303     ) internal returns (bytes memory) {
304         require(address(this).balance >= value, "Address: insufficient balance for call");
305         require(isContract(target), "Address: call to non-contract");
306 
307         (bool success, bytes memory returndata) = target.call{value: value}(data);
308         return verifyCallResult(success, returndata, errorMessage);
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
313      * but performing a static call.
314      *
315      * _Available since v3.3._
316      */
317     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
318         return functionStaticCall(target, data, "Address: low-level static call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
323      * but performing a static call.
324      *
325      * _Available since v3.3._
326      */
327     function functionStaticCall(
328         address target,
329         bytes memory data,
330         string memory errorMessage
331     ) internal view returns (bytes memory) {
332         require(isContract(target), "Address: static call to non-contract");
333 
334         (bool success, bytes memory returndata) = target.staticcall(data);
335         return verifyCallResult(success, returndata, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but performing a delegate call.
341      *
342      * _Available since v3.4._
343      */
344     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
345         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
350      * but performing a delegate call.
351      *
352      * _Available since v3.4._
353      */
354     function functionDelegateCall(
355         address target,
356         bytes memory data,
357         string memory errorMessage
358     ) internal returns (bytes memory) {
359         require(isContract(target), "Address: delegate call to non-contract");
360 
361         (bool success, bytes memory returndata) = target.delegatecall(data);
362         return verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
367      * revert reason using the provided one.
368      *
369      * _Available since v4.3._
370      */
371     function verifyCallResult(
372         bool success,
373         bytes memory returndata,
374         string memory errorMessage
375     ) internal pure returns (bytes memory) {
376         if (success) {
377             return returndata;
378         } else {
379             // Look for revert reason and bubble it up if present
380             if (returndata.length > 0) {
381                 // The easiest way to bubble the revert reason is using memory via assembly
382 
383                 assembly {
384                     let returndata_size := mload(returndata)
385                     revert(add(32, returndata), returndata_size)
386                 }
387             } else {
388                 revert(errorMessage);
389             }
390         }
391     }
392 }
393 
394 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
395 
396 
397 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
398 
399 
400 
401 /**
402  * @title ERC721 token receiver interface
403  * @dev Interface for any contract that wants to support safeTransfers
404  * from ERC721 asset contracts.
405  */
406 interface IERC721Receiver {
407     /**
408      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
409      * by `operator` from `from`, this function is called.
410      *
411      * It must return its Solidity selector to confirm the token transfer.
412      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
413      *
414      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
415      */
416     function onERC721Received(
417         address operator,
418         address from,
419         uint256 tokenId,
420         bytes calldata data
421     ) external returns (bytes4);
422 }
423 
424 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
425 
426 
427 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
428 
429 
430 
431 /**
432  * @dev Interface of the ERC165 standard, as defined in the
433  * https://eips.ethereum.org/EIPS/eip-165[EIP].
434  *
435  * Implementers can declare support of contract interfaces, which can then be
436  * queried by others ({ERC165Checker}).
437  *
438  * For an implementation, see {ERC165}.
439  */
440 interface IERC165 {
441     /**
442      * @dev Returns true if this contract implements the interface defined by
443      * `interfaceId`. See the corresponding
444      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
445      * to learn more about how these ids are created.
446      *
447      * This function call must use less than 30 000 gas.
448      */
449     function supportsInterface(bytes4 interfaceId) external view returns (bool);
450 }
451 
452 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
453 
454 
455 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
456 
457 
458 
459 
460 /**
461  * @dev Implementation of the {IERC165} interface.
462  *
463  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
464  * for the additional interface id that will be supported. For example:
465  *
466  * ```solidity
467  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
468  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
469  * }
470  * ```
471  *
472  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
473  */
474 abstract contract ERC165 is IERC165 {
475     /**
476      * @dev See {IERC165-supportsInterface}.
477      */
478     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
479         return interfaceId == type(IERC165).interfaceId;
480     }
481 }
482 
483 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
484 
485 
486 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
487 
488 
489 
490 
491 /**
492  * @dev Required interface of an ERC721 compliant contract.
493  */
494 interface IERC721 is IERC165 {
495     /**
496      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
497      */
498     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
499 
500     /**
501      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
502      */
503     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
504 
505     /**
506      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
507      */
508     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
509 
510     /**
511      * @dev Returns the number of tokens in ``owner``'s account.
512      */
513     function balanceOf(address owner) external view returns (uint256 balance);
514 
515     /**
516      * @dev Returns the owner of the `tokenId` token.
517      *
518      * Requirements:
519      *
520      * - `tokenId` must exist.
521      */
522     function ownerOf(uint256 tokenId) external view returns (address owner);
523 
524     /**
525      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
526      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
527      *
528      * Requirements:
529      *
530      * - `from` cannot be the zero address.
531      * - `to` cannot be the zero address.
532      * - `tokenId` token must exist and be owned by `from`.
533      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
534      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
535      *
536      * Emits a {Transfer} event.
537      */
538     function safeTransferFrom(
539         address from,
540         address to,
541         uint256 tokenId
542     ) external;
543 
544     /**
545      * @dev Transfers `tokenId` token from `from` to `to`.
546      *
547      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
548      *
549      * Requirements:
550      *
551      * - `from` cannot be the zero address.
552      * - `to` cannot be the zero address.
553      * - `tokenId` token must be owned by `from`.
554      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
555      *
556      * Emits a {Transfer} event.
557      */
558     function transferFrom(
559         address from,
560         address to,
561         uint256 tokenId
562     ) external;
563 
564     /**
565      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
566      * The approval is cleared when the token is transferred.
567      *
568      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
569      *
570      * Requirements:
571      *
572      * - The caller must own the token or be an approved operator.
573      * - `tokenId` must exist.
574      *
575      * Emits an {Approval} event.
576      */
577     function approve(address to, uint256 tokenId) external;
578 
579     /**
580      * @dev Returns the account approved for `tokenId` token.
581      *
582      * Requirements:
583      *
584      * - `tokenId` must exist.
585      */
586     function getApproved(uint256 tokenId) external view returns (address operator);
587 
588     /**
589      * @dev Approve or remove `operator` as an operator for the caller.
590      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
591      *
592      * Requirements:
593      *
594      * - The `operator` cannot be the caller.
595      *
596      * Emits an {ApprovalForAll} event.
597      */
598     function setApprovalForAll(address operator, bool _approved) external;
599 
600     /**
601      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
602      *
603      * See {setApprovalForAll}
604      */
605     function isApprovedForAll(address owner, address operator) external view returns (bool);
606 
607     /**
608      * @dev Safely transfers `tokenId` token from `from` to `to`.
609      *
610      * Requirements:
611      *
612      * - `from` cannot be the zero address.
613      * - `to` cannot be the zero address.
614      * - `tokenId` token must exist and be owned by `from`.
615      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
616      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
617      *
618      * Emits a {Transfer} event.
619      */
620     function safeTransferFrom(
621         address from,
622         address to,
623         uint256 tokenId,
624         bytes calldata data
625     ) external;
626 }
627 
628 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
629 
630 
631 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
632 
633 
634 
635 
636 /**
637  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
638  * @dev See https://eips.ethereum.org/EIPS/eip-721
639  */
640 interface IERC721Enumerable is IERC721 {
641     /**
642      * @dev Returns the total amount of tokens stored by the contract.
643      */
644     function totalSupply() external view returns (uint256);
645 
646     /**
647      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
648      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
649      */
650     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
651 
652     /**
653      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
654      * Use along with {totalSupply} to enumerate all tokens.
655      */
656     function tokenByIndex(uint256 index) external view returns (uint256);
657 }
658 
659 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
660 
661 
662 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
663 
664 
665 
666 
667 /**
668  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
669  * @dev See https://eips.ethereum.org/EIPS/eip-721
670  */
671 interface IERC721Metadata is IERC721 {
672     /**
673      * @dev Returns the token collection name.
674      */
675     function name() external view returns (string memory);
676 
677     /**
678      * @dev Returns the token collection symbol.
679      */
680     function symbol() external view returns (string memory);
681 
682     /**
683      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
684      */
685     function tokenURI(uint256 tokenId) external view returns (string memory);
686 }
687 
688 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
689 
690 
691 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
692 
693 
694 
695 
696 
697 
698 
699 
700 
701 
702 /**
703  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
704  * the Metadata extension, but not including the Enumerable extension, which is available separately as
705  * {ERC721Enumerable}.
706  */
707 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
708     using Address for address;
709     using Strings for uint256;
710 
711     // Token name
712     string private _name;
713 
714     // Token symbol
715     string private _symbol;
716 
717     // Mapping from token ID to owner address
718     mapping(uint256 => address) private _owners;
719 
720     // Mapping owner address to token count
721     mapping(address => uint256) private _balances;
722 
723     // Mapping from token ID to approved address
724     mapping(uint256 => address) private _tokenApprovals;
725 
726     // Mapping from owner to operator approvals
727     mapping(address => mapping(address => bool)) private _operatorApprovals;
728 
729     /**
730      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
731      */
732     constructor(string memory name_, string memory symbol_) {
733         _name = name_;
734         _symbol = symbol_;
735     }
736 
737     /**
738      * @dev See {IERC165-supportsInterface}.
739      */
740     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
741         return
742             interfaceId == type(IERC721).interfaceId ||
743             interfaceId == type(IERC721Metadata).interfaceId ||
744             super.supportsInterface(interfaceId);
745     }
746 
747     /**
748      * @dev See {IERC721-balanceOf}.
749      */
750     function balanceOf(address owner) public view virtual override returns (uint256) {
751         require(owner != address(0), "ERC721: balance query for the zero address");
752         return _balances[owner];
753     }
754 
755     /**
756      * @dev See {IERC721-ownerOf}.
757      */
758     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
759         address owner = _owners[tokenId];
760         require(owner != address(0), "ERC721: owner query for nonexistent token");
761         return owner;
762     }
763 
764     /**
765      * @dev See {IERC721Metadata-name}.
766      */
767     function name() public view virtual override returns (string memory) {
768         return _name;
769     }
770 
771     /**
772      * @dev See {IERC721Metadata-symbol}.
773      */
774     function symbol() public view virtual override returns (string memory) {
775         return _symbol;
776     }
777 
778     /**
779      * @dev See {IERC721Metadata-tokenURI}.
780      */
781     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
782         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
783 
784         string memory baseURI = _baseURI();
785         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
786     }
787 
788     /**
789      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
790      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
791      * by default, can be overriden in child contracts.
792      */
793     function _baseURI() internal view virtual returns (string memory) {
794         return "";
795     }
796 
797     /**
798      * @dev See {IERC721-approve}.
799      */
800     function approve(address to, uint256 tokenId) public virtual override {
801         address owner = ERC721.ownerOf(tokenId);
802         require(to != owner, "ERC721: approval to current owner");
803 
804         require(
805             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
806             "ERC721: approve caller is not owner nor approved for all"
807         );
808 
809         _approve(to, tokenId);
810     }
811 
812     /**
813      * @dev See {IERC721-getApproved}.
814      */
815     function getApproved(uint256 tokenId) public view virtual override returns (address) {
816         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
817 
818         return _tokenApprovals[tokenId];
819     }
820 
821     /**
822      * @dev See {IERC721-setApprovalForAll}.
823      */
824     function setApprovalForAll(address operator, bool approved) public virtual override {
825         _setApprovalForAll(_msgSender(), operator, approved);
826     }
827 
828     /**
829      * @dev See {IERC721-isApprovedForAll}.
830      */
831     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
832         return _operatorApprovals[owner][operator];
833     }
834 
835     /**
836      * @dev See {IERC721-transferFrom}.
837      */
838     function transferFrom(
839         address from,
840         address to,
841         uint256 tokenId
842     ) public virtual override {
843         //solhint-disable-next-line max-line-length
844         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
845 
846         _transfer(from, to, tokenId);
847     }
848 
849     /**
850      * @dev See {IERC721-safeTransferFrom}.
851      */
852     function safeTransferFrom(
853         address from,
854         address to,
855         uint256 tokenId
856     ) public virtual override {
857         safeTransferFrom(from, to, tokenId, "");
858     }
859 
860     /**
861      * @dev See {IERC721-safeTransferFrom}.
862      */
863     function safeTransferFrom(
864         address from,
865         address to,
866         uint256 tokenId,
867         bytes memory _data
868     ) public virtual override {
869         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
870         _safeTransfer(from, to, tokenId, _data);
871     }
872 
873     /**
874      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
875      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
876      *
877      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
878      *
879      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
880      * implement alternative mechanisms to perform token transfer, such as signature-based.
881      *
882      * Requirements:
883      *
884      * - `from` cannot be the zero address.
885      * - `to` cannot be the zero address.
886      * - `tokenId` token must exist and be owned by `from`.
887      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
888      *
889      * Emits a {Transfer} event.
890      */
891     function _safeTransfer(
892         address from,
893         address to,
894         uint256 tokenId,
895         bytes memory _data
896     ) internal virtual {
897         _transfer(from, to, tokenId);
898         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
899     }
900 
901     /**
902      * @dev Returns whether `tokenId` exists.
903      *
904      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
905      *
906      * Tokens start existing when they are minted (`_mint`),
907      * and stop existing when they are burned (`_burn`).
908      */
909     function _exists(uint256 tokenId) internal view virtual returns (bool) {
910         return _owners[tokenId] != address(0);
911     }
912 
913     /**
914      * @dev Returns whether `spender` is allowed to manage `tokenId`.
915      *
916      * Requirements:
917      *
918      * - `tokenId` must exist.
919      */
920     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
921         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
922         address owner = ERC721.ownerOf(tokenId);
923         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
924     }
925 
926     /**
927      * @dev Safely mints `tokenId` and transfers it to `to`.
928      *
929      * Requirements:
930      *
931      * - `tokenId` must not exist.
932      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _safeMint(address to, uint256 tokenId) internal virtual {
937         _safeMint(to, tokenId, "");
938     }
939 
940     /**
941      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
942      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
943      */
944     function _safeMint(
945         address to,
946         uint256 tokenId,
947         bytes memory _data
948     ) internal virtual {
949         _mint(to, tokenId);
950         require(
951             _checkOnERC721Received(address(0), to, tokenId, _data),
952             "ERC721: transfer to non ERC721Receiver implementer"
953         );
954     }
955 
956     /**
957      * @dev Mints `tokenId` and transfers it to `to`.
958      *
959      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
960      *
961      * Requirements:
962      *
963      * - `tokenId` must not exist.
964      * - `to` cannot be the zero address.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _mint(address to, uint256 tokenId) internal virtual {
969         require(to != address(0), "ERC721: mint to the zero address");
970         require(!_exists(tokenId), "ERC721: token already minted");
971 
972         _beforeTokenTransfer(address(0), to, tokenId);
973 
974         _balances[to] += 1;
975         _owners[tokenId] = to;
976 
977         emit Transfer(address(0), to, tokenId);
978     }
979 
980     /**
981      * @dev Destroys `tokenId`.
982      * The approval is cleared when the token is burned.
983      *
984      * Requirements:
985      *
986      * - `tokenId` must exist.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _burn(uint256 tokenId) internal virtual {
991         address owner = ERC721.ownerOf(tokenId);
992 
993         _beforeTokenTransfer(owner, address(0), tokenId);
994 
995         // Clear approvals
996         _approve(address(0), tokenId);
997 
998         _balances[owner] -= 1;
999         delete _owners[tokenId];
1000 
1001         emit Transfer(owner, address(0), tokenId);
1002     }
1003 
1004     /**
1005      * @dev Transfers `tokenId` from `from` to `to`.
1006      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1007      *
1008      * Requirements:
1009      *
1010      * - `to` cannot be the zero address.
1011      * - `tokenId` token must be owned by `from`.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function _transfer(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) internal virtual {
1020         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1021         require(to != address(0), "ERC721: transfer to the zero address");
1022 
1023         _beforeTokenTransfer(from, to, tokenId);
1024 
1025         // Clear approvals from the previous owner
1026         _approve(address(0), tokenId);
1027 
1028         _balances[from] -= 1;
1029         _balances[to] += 1;
1030         _owners[tokenId] = to;
1031 
1032         emit Transfer(from, to, tokenId);
1033     }
1034 
1035     /**
1036      * @dev Approve `to` to operate on `tokenId`
1037      *
1038      * Emits a {Approval} event.
1039      */
1040     function _approve(address to, uint256 tokenId) internal virtual {
1041         _tokenApprovals[tokenId] = to;
1042         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev Approve `operator` to operate on all of `owner` tokens
1047      *
1048      * Emits a {ApprovalForAll} event.
1049      */
1050     function _setApprovalForAll(
1051         address owner,
1052         address operator,
1053         bool approved
1054     ) internal virtual {
1055         require(owner != operator, "ERC721: approve to caller");
1056         _operatorApprovals[owner][operator] = approved;
1057         emit ApprovalForAll(owner, operator, approved);
1058     }
1059 
1060     /**
1061      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1062      * The call is not executed if the target address is not a contract.
1063      *
1064      * @param from address representing the previous owner of the given token ID
1065      * @param to target address that will receive the tokens
1066      * @param tokenId uint256 ID of the token to be transferred
1067      * @param _data bytes optional data to send along with the call
1068      * @return bool whether the call correctly returned the expected magic value
1069      */
1070     function _checkOnERC721Received(
1071         address from,
1072         address to,
1073         uint256 tokenId,
1074         bytes memory _data
1075     ) private returns (bool) {
1076         if (to.isContract()) {
1077             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1078                 return retval == IERC721Receiver.onERC721Received.selector;
1079             } catch (bytes memory reason) {
1080                 if (reason.length == 0) {
1081                     revert("ERC721: transfer to non ERC721Receiver implementer");
1082                 } else {
1083                     assembly {
1084                         revert(add(32, reason), mload(reason))
1085                     }
1086                 }
1087             }
1088         } else {
1089             return true;
1090         }
1091     }
1092 
1093     /**
1094      * @dev Hook that is called before any token transfer. This includes minting
1095      * and burning.
1096      *
1097      * Calling conditions:
1098      *
1099      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1100      * transferred to `to`.
1101      * - When `from` is zero, `tokenId` will be minted for `to`.
1102      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1103      * - `from` and `to` are never both zero.
1104      *
1105      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1106      */
1107     function _beforeTokenTransfer(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) internal virtual {}
1112 }
1113 
1114 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1115 
1116 
1117 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1118 
1119 
1120 
1121 
1122 
1123 /**
1124  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1125  * enumerability of all the token ids in the contract as well as all token ids owned by each
1126  * account.
1127  */
1128 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1129     // Mapping from owner to list of owned token IDs
1130     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1131 
1132     // Mapping from token ID to index of the owner tokens list
1133     mapping(uint256 => uint256) private _ownedTokensIndex;
1134 
1135     // Array with all token ids, used for enumeration
1136     uint256[] private _allTokens;
1137 
1138     // Mapping from token id to position in the allTokens array
1139     mapping(uint256 => uint256) private _allTokensIndex;
1140 
1141     /**
1142      * @dev See {IERC165-supportsInterface}.
1143      */
1144     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1145         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1146     }
1147 
1148     /**
1149      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1150      */
1151     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1152         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1153         return _ownedTokens[owner][index];
1154     }
1155 
1156     /**
1157      * @dev See {IERC721Enumerable-totalSupply}.
1158      */
1159     function totalSupply() public view virtual override returns (uint256) {
1160         return _allTokens.length;
1161     }
1162 
1163     /**
1164      * @dev See {IERC721Enumerable-tokenByIndex}.
1165      */
1166     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1167         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1168         return _allTokens[index];
1169     }
1170 
1171     /**
1172      * @dev Hook that is called before any token transfer. This includes minting
1173      * and burning.
1174      *
1175      * Calling conditions:
1176      *
1177      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1178      * transferred to `to`.
1179      * - When `from` is zero, `tokenId` will be minted for `to`.
1180      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1181      * - `from` cannot be the zero address.
1182      * - `to` cannot be the zero address.
1183      *
1184      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1185      */
1186     function _beforeTokenTransfer(
1187         address from,
1188         address to,
1189         uint256 tokenId
1190     ) internal virtual override {
1191         super._beforeTokenTransfer(from, to, tokenId);
1192 
1193         if (from == address(0)) {
1194             _addTokenToAllTokensEnumeration(tokenId);
1195         } else if (from != to) {
1196             _removeTokenFromOwnerEnumeration(from, tokenId);
1197         }
1198         if (to == address(0)) {
1199             _removeTokenFromAllTokensEnumeration(tokenId);
1200         } else if (to != from) {
1201             _addTokenToOwnerEnumeration(to, tokenId);
1202         }
1203     }
1204 
1205     /**
1206      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1207      * @param to address representing the new owner of the given token ID
1208      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1209      */
1210     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1211         uint256 length = ERC721.balanceOf(to);
1212         _ownedTokens[to][length] = tokenId;
1213         _ownedTokensIndex[tokenId] = length;
1214     }
1215 
1216     /**
1217      * @dev Private function to add a token to this extension's token tracking data structures.
1218      * @param tokenId uint256 ID of the token to be added to the tokens list
1219      */
1220     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1221         _allTokensIndex[tokenId] = _allTokens.length;
1222         _allTokens.push(tokenId);
1223     }
1224 
1225     /**
1226      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1227      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1228      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1229      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1230      * @param from address representing the previous owner of the given token ID
1231      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1232      */
1233     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1234         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1235         // then delete the last slot (swap and pop).
1236 
1237         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1238         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1239 
1240         // When the token to delete is the last token, the swap operation is unnecessary
1241         if (tokenIndex != lastTokenIndex) {
1242             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1243 
1244             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1245             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1246         }
1247 
1248         // This also deletes the contents at the last position of the array
1249         delete _ownedTokensIndex[tokenId];
1250         delete _ownedTokens[from][lastTokenIndex];
1251     }
1252 
1253     /**
1254      * @dev Private function to remove a token from this extension's token tracking data structures.
1255      * This has O(1) time complexity, but alters the order of the _allTokens array.
1256      * @param tokenId uint256 ID of the token to be removed from the tokens list
1257      */
1258     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1259         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1260         // then delete the last slot (swap and pop).
1261 
1262         uint256 lastTokenIndex = _allTokens.length - 1;
1263         uint256 tokenIndex = _allTokensIndex[tokenId];
1264 
1265         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1266         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1267         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1268         uint256 lastTokenId = _allTokens[lastTokenIndex];
1269 
1270         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1271         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1272 
1273         // This also deletes the contents at the last position of the array
1274         delete _allTokensIndex[tokenId];
1275         _allTokens.pop();
1276     }
1277 }
1278 
1279 // File: contracts/nft.sol
1280 
1281 
1282 contract SHARKBOYFIGHTCLUB is ERC721Enumerable, Ownable
1283 {
1284     using Strings for string;
1285 
1286     uint public constant MAX_TOKENS = 8888;
1287     uint public constant NUMBER_RESERVED_TOKENS = 188;
1288     uint256 public constant PRICE = 5*10**16; //0.05
1289     uint256 public constant PRE_SALE_PRICE = 3*10**16; //0.03
1290 
1291     bool public saleIsActive = false;
1292     bool public preSaleIsActive = false;
1293 
1294     uint public reservedTokensMinted = 0;
1295     string private _baseTokenURI;
1296 
1297     constructor() ERC721("Shark Boy Fight Club", "SBFC") {}
1298 
1299     function mintToken(uint256 amount) external payable
1300     {
1301         require(msg.sender == tx.origin, "No transaction from smart contracts!");
1302         require(saleIsActive, "Sale must be active to mint");
1303         require(amount > 0 && amount <= 20, "Max 20 Sharks per transaction");
1304         require(totalSupply() + amount <= MAX_TOKENS - (NUMBER_RESERVED_TOKENS - reservedTokensMinted), "Purchase would exceed max supply");
1305         require(msg.value >= PRICE * amount, "Not enough ETH for transaction");
1306 
1307         for (uint i = 0; i < amount; i++)
1308         {
1309             _safeMint(msg.sender, totalSupply() + 1);
1310         }
1311     }
1312 
1313     function mintTokenPreSale(uint256 amount) external payable
1314     {
1315         require(msg.sender == tx.origin, "No transaction from smart contracts!");
1316         require(preSaleIsActive, "Pre-sale must be active to mint");
1317         require(amount > 0 && amount <= 20, "Max 20 NFTs per transaction");
1318         require(totalSupply() + amount <= MAX_TOKENS - (NUMBER_RESERVED_TOKENS - reservedTokensMinted), "Purchase would exceed max supply");
1319         require(msg.value >= PRE_SALE_PRICE * amount, "Not enough ETH for transaction");
1320 
1321         for (uint i = 0; i < amount; i++)
1322         {
1323             _safeMint(msg.sender, totalSupply() + 1);
1324         }
1325     }
1326 
1327 
1328     function flipSaleState() external onlyOwner
1329     {
1330         saleIsActive = !saleIsActive;
1331     }
1332 
1333     function flipPreSaleState() external onlyOwner
1334     {
1335         preSaleIsActive = !preSaleIsActive;
1336     }
1337 
1338     function mintReservedTokens(address to, uint256 amount) external onlyOwner
1339     {
1340         require(reservedTokensMinted + amount <= NUMBER_RESERVED_TOKENS, "This amount is more than max allowed");
1341 
1342         for (uint i = 0; i < amount; i++)
1343         {
1344             _safeMint(to, totalSupply() + 1);
1345             reservedTokensMinted++;
1346         }
1347     }
1348 
1349     function withdraw() external onlyOwner
1350      {
1351         uint balance = address(this).balance;
1352         payable(msg.sender).transfer(balance);
1353     }
1354 
1355     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1356         internal
1357         override(ERC721Enumerable)
1358     {
1359         super._beforeTokenTransfer(from, to, tokenId);
1360     }
1361 
1362     function supportsInterface(bytes4 interfaceId) public view
1363         override(ERC721Enumerable) returns (bool)
1364     {
1365         return super.supportsInterface(interfaceId);
1366     }
1367 
1368     ////
1369     //URI management part
1370     ////
1371 
1372     function _setBaseURI(string memory baseURI) internal virtual {
1373         _baseTokenURI = baseURI;
1374     }
1375 
1376     function _baseURI() internal view override returns (string memory) {
1377         return _baseTokenURI;
1378     }
1379 
1380     function setBaseURI(string memory baseURI) external onlyOwner {
1381         _setBaseURI(baseURI);
1382     }
1383 
1384     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1385         string memory _tokenURI = super.tokenURI(tokenId);
1386         return bytes(_tokenURI).length > 0 ? string(abi.encodePacked(_tokenURI, ".json")) : "";
1387     }
1388 }