1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = _HEX_SYMBOLS[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/Context.sol
69 
70 
71 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev Provides information about the current execution context, including the
77  * sender of the transaction and its data. While these are generally available
78  * via msg.sender and msg.data, they should not be accessed in such a direct
79  * manner, since when dealing with meta-transactions the account sending and
80  * paying for execution may not be the actual sender (as far as an application
81  * is concerned).
82  *
83  * This contract is only required for intermediate, library-like contracts.
84  */
85 abstract contract Context {
86     function _msgSender() internal view virtual returns (address) {
87         return msg.sender;
88     }
89 
90     function _msgData() internal view virtual returns (bytes calldata) {
91         return msg.data;
92     }
93 }
94 
95 // File: @openzeppelin/contracts/access/Ownable.sol
96 
97 
98 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 
103 /**
104  * @dev Contract module which provides a basic access control mechanism, where
105  * there is an account (an owner) that can be granted exclusive access to
106  * specific functions.
107  *
108  * By default, the owner account will be the one that deploys the contract. This
109  * can later be changed with {transferOwnership}.
110  *
111  * This module is used through inheritance. It will make available the modifier
112  * `onlyOwner`, which can be applied to your functions to restrict their use to
113  * the owner.
114  */
115 abstract contract Ownable is Context {
116     address private _owner;
117 
118     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
119 
120     /**
121      * @dev Initializes the contract setting the deployer as the initial owner.
122      */
123     constructor() {
124         _transferOwnership(_msgSender());
125     }
126 
127     /**
128      * @dev Returns the address of the current owner.
129      */
130     function owner() public view virtual returns (address) {
131         return _owner;
132     }
133 
134     /**
135      * @dev Throws if called by any account other than the owner.
136      */
137     modifier onlyOwner() {
138         require(owner() == _msgSender(), "Ownable: caller is not the owner");
139         _;
140     }
141 
142     /**
143      * @dev Leaves the contract without owner. It will not be possible to call
144      * `onlyOwner` functions anymore. Can only be called by the current owner.
145      *
146      * NOTE: Renouncing ownership will leave the contract without an owner,
147      * thereby removing any functionality that is only available to the owner.
148      */
149     function renounceOwnership() public virtual onlyOwner {
150         _transferOwnership(address(0));
151     }
152 
153     /**
154      * @dev Transfers ownership of the contract to a new account (`newOwner`).
155      * Can only be called by the current owner.
156      */
157     function transferOwnership(address newOwner) public virtual onlyOwner {
158         require(newOwner != address(0), "Ownable: new owner is the zero address");
159         _transferOwnership(newOwner);
160     }
161 
162     /**
163      * @dev Transfers ownership of the contract to a new account (`newOwner`).
164      * Internal function without access restriction.
165      */
166     function _transferOwnership(address newOwner) internal virtual {
167         address oldOwner = _owner;
168         _owner = newOwner;
169         emit OwnershipTransferred(oldOwner, newOwner);
170     }
171 }
172 
173 // File: @openzeppelin/contracts/utils/Address.sol
174 
175 
176 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @dev Collection of functions related to the address type
182  */
183 library Address {
184     /**
185      * @dev Returns true if `account` is a contract.
186      *
187      * [IMPORTANT]
188      * ====
189      * It is unsafe to assume that an address for which this function returns
190      * false is an externally-owned account (EOA) and not a contract.
191      *
192      * Among others, `isContract` will return false for the following
193      * types of addresses:
194      *
195      *  - an externally-owned account
196      *  - a contract in construction
197      *  - an address where a contract will be created
198      *  - an address where a contract lived, but was destroyed
199      * ====
200      */
201     function isContract(address account) internal view returns (bool) {
202         // This method relies on extcodesize, which returns 0 for contracts in
203         // construction, since the code is only stored at the end of the
204         // constructor execution.
205 
206         uint256 size;
207         assembly {
208             size := extcodesize(account)
209         }
210         return size > 0;
211     }
212 
213     /**
214      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
215      * `recipient`, forwarding all available gas and reverting on errors.
216      *
217      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
218      * of certain opcodes, possibly making contracts go over the 2300 gas limit
219      * imposed by `transfer`, making them unable to receive funds via
220      * `transfer`. {sendValue} removes this limitation.
221      *
222      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
223      *
224      * IMPORTANT: because control is transferred to `recipient`, care must be
225      * taken to not create reentrancy vulnerabilities. Consider using
226      * {ReentrancyGuard} or the
227      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
228      */
229     function sendValue(address payable recipient, uint256 amount) internal {
230         require(address(this).balance >= amount, "Address: insufficient balance");
231 
232         (bool success, ) = recipient.call{value: amount}("");
233         require(success, "Address: unable to send value, recipient may have reverted");
234     }
235 
236     /**
237      * @dev Performs a Solidity function call using a low level `call`. A
238      * plain `call` is an unsafe replacement for a function call: use this
239      * function instead.
240      *
241      * If `target` reverts with a revert reason, it is bubbled up by this
242      * function (like regular Solidity function calls).
243      *
244      * Returns the raw returned data. To convert to the expected return value,
245      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
246      *
247      * Requirements:
248      *
249      * - `target` must be a contract.
250      * - calling `target` with `data` must not revert.
251      *
252      * _Available since v3.1._
253      */
254     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionCall(target, data, "Address: low-level call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
260      * `errorMessage` as a fallback revert reason when `target` reverts.
261      *
262      * _Available since v3.1._
263      */
264     function functionCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         return functionCallWithValue(target, data, 0, errorMessage);
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
274      * but also transferring `value` wei to `target`.
275      *
276      * Requirements:
277      *
278      * - the calling contract must have an ETH balance of at least `value`.
279      * - the called Solidity function must be `payable`.
280      *
281      * _Available since v3.1._
282      */
283     function functionCallWithValue(
284         address target,
285         bytes memory data,
286         uint256 value
287     ) internal returns (bytes memory) {
288         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
293      * with `errorMessage` as a fallback revert reason when `target` reverts.
294      *
295      * _Available since v3.1._
296      */
297     function functionCallWithValue(
298         address target,
299         bytes memory data,
300         uint256 value,
301         string memory errorMessage
302     ) internal returns (bytes memory) {
303         require(address(this).balance >= value, "Address: insufficient balance for call");
304         require(isContract(target), "Address: call to non-contract");
305 
306         (bool success, bytes memory returndata) = target.call{value: value}(data);
307         return verifyCallResult(success, returndata, errorMessage);
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
312      * but performing a static call.
313      *
314      * _Available since v3.3._
315      */
316     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
317         return functionStaticCall(target, data, "Address: low-level static call failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
322      * but performing a static call.
323      *
324      * _Available since v3.3._
325      */
326     function functionStaticCall(
327         address target,
328         bytes memory data,
329         string memory errorMessage
330     ) internal view returns (bytes memory) {
331         require(isContract(target), "Address: static call to non-contract");
332 
333         (bool success, bytes memory returndata) = target.staticcall(data);
334         return verifyCallResult(success, returndata, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but performing a delegate call.
340      *
341      * _Available since v3.4._
342      */
343     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
344         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
349      * but performing a delegate call.
350      *
351      * _Available since v3.4._
352      */
353     function functionDelegateCall(
354         address target,
355         bytes memory data,
356         string memory errorMessage
357     ) internal returns (bytes memory) {
358         require(isContract(target), "Address: delegate call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.delegatecall(data);
361         return verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
366      * revert reason using the provided one.
367      *
368      * _Available since v4.3._
369      */
370     function verifyCallResult(
371         bool success,
372         bytes memory returndata,
373         string memory errorMessage
374     ) internal pure returns (bytes memory) {
375         if (success) {
376             return returndata;
377         } else {
378             // Look for revert reason and bubble it up if present
379             if (returndata.length > 0) {
380                 // The easiest way to bubble the revert reason is using memory via assembly
381 
382                 assembly {
383                     let returndata_size := mload(returndata)
384                     revert(add(32, returndata), returndata_size)
385                 }
386             } else {
387                 revert(errorMessage);
388             }
389         }
390     }
391 }
392 
393 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
394 
395 
396 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
397 
398 pragma solidity ^0.8.0;
399 
400 /**
401  * @title ERC721 token receiver interface
402  * @dev Interface for any contract that wants to support safeTransfers
403  * from ERC721 asset contracts.
404  */
405 interface IERC721Receiver {
406     /**
407      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
408      * by `operator` from `from`, this function is called.
409      *
410      * It must return its Solidity selector to confirm the token transfer.
411      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
412      *
413      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
414      */
415     function onERC721Received(
416         address operator,
417         address from,
418         uint256 tokenId,
419         bytes calldata data
420     ) external returns (bytes4);
421 }
422 
423 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
424 
425 
426 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
427 
428 pragma solidity ^0.8.0;
429 
430 /**
431  * @dev Interface of the ERC165 standard, as defined in the
432  * https://eips.ethereum.org/EIPS/eip-165[EIP].
433  *
434  * Implementers can declare support of contract interfaces, which can then be
435  * queried by others ({ERC165Checker}).
436  *
437  * For an implementation, see {ERC165}.
438  */
439 interface IERC165 {
440     /**
441      * @dev Returns true if this contract implements the interface defined by
442      * `interfaceId`. See the corresponding
443      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
444      * to learn more about how these ids are created.
445      *
446      * This function call must use less than 30 000 gas.
447      */
448     function supportsInterface(bytes4 interfaceId) external view returns (bool);
449 }
450 
451 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
452 
453 
454 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
455 
456 pragma solidity ^0.8.0;
457 
458 
459 /**
460  * @dev Implementation of the {IERC165} interface.
461  *
462  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
463  * for the additional interface id that will be supported. For example:
464  *
465  * ```solidity
466  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
467  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
468  * }
469  * ```
470  *
471  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
472  */
473 abstract contract ERC165 is IERC165 {
474     /**
475      * @dev See {IERC165-supportsInterface}.
476      */
477     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
478         return interfaceId == type(IERC165).interfaceId;
479     }
480 }
481 
482 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
483 
484 
485 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
486 
487 pragma solidity ^0.8.0;
488 
489 
490 /**
491  * @dev Required interface of an ERC721 compliant contract.
492  */
493 interface IERC721 is IERC165 {
494     /**
495      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
496      */
497     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
498 
499     /**
500      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
501      */
502     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
503 
504     /**
505      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
506      */
507     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
508 
509     /**
510      * @dev Returns the number of tokens in ``owner``'s account.
511      */
512     function balanceOf(address owner) external view returns (uint256 balance);
513 
514     /**
515      * @dev Returns the owner of the `tokenId` token.
516      *
517      * Requirements:
518      *
519      * - `tokenId` must exist.
520      */
521     function ownerOf(uint256 tokenId) external view returns (address owner);
522 
523     /**
524      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
525      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
526      *
527      * Requirements:
528      *
529      * - `from` cannot be the zero address.
530      * - `to` cannot be the zero address.
531      * - `tokenId` token must exist and be owned by `from`.
532      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
533      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
534      *
535      * Emits a {Transfer} event.
536      */
537     function safeTransferFrom(
538         address from,
539         address to,
540         uint256 tokenId
541     ) external;
542 
543     /**
544      * @dev Transfers `tokenId` token from `from` to `to`.
545      *
546      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
547      *
548      * Requirements:
549      *
550      * - `from` cannot be the zero address.
551      * - `to` cannot be the zero address.
552      * - `tokenId` token must be owned by `from`.
553      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
554      *
555      * Emits a {Transfer} event.
556      */
557     function transferFrom(
558         address from,
559         address to,
560         uint256 tokenId
561     ) external;
562 
563     /**
564      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
565      * The approval is cleared when the token is transferred.
566      *
567      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
568      *
569      * Requirements:
570      *
571      * - The caller must own the token or be an approved operator.
572      * - `tokenId` must exist.
573      *
574      * Emits an {Approval} event.
575      */
576     function approve(address to, uint256 tokenId) external;
577 
578     /**
579      * @dev Returns the account approved for `tokenId` token.
580      *
581      * Requirements:
582      *
583      * - `tokenId` must exist.
584      */
585     function getApproved(uint256 tokenId) external view returns (address operator);
586 
587     /**
588      * @dev Approve or remove `operator` as an operator for the caller.
589      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
590      *
591      * Requirements:
592      *
593      * - The `operator` cannot be the caller.
594      *
595      * Emits an {ApprovalForAll} event.
596      */
597     function setApprovalForAll(address operator, bool _approved) external;
598 
599     /**
600      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
601      *
602      * See {setApprovalForAll}
603      */
604     function isApprovedForAll(address owner, address operator) external view returns (bool);
605 
606     /**
607      * @dev Safely transfers `tokenId` token from `from` to `to`.
608      *
609      * Requirements:
610      *
611      * - `from` cannot be the zero address.
612      * - `to` cannot be the zero address.
613      * - `tokenId` token must exist and be owned by `from`.
614      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
615      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
616      *
617      * Emits a {Transfer} event.
618      */
619     function safeTransferFrom(
620         address from,
621         address to,
622         uint256 tokenId,
623         bytes calldata data
624     ) external;
625 }
626 
627 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
628 
629 
630 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
631 
632 pragma solidity ^0.8.0;
633 
634 
635 /**
636  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
637  * @dev See https://eips.ethereum.org/EIPS/eip-721
638  */
639 interface IERC721Enumerable is IERC721 {
640     /**
641      * @dev Returns the total amount of tokens stored by the contract.
642      */
643     function totalSupply() external view returns (uint256);
644 
645     /**
646      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
647      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
648      */
649     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
650 
651     /**
652      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
653      * Use along with {totalSupply} to enumerate all tokens.
654      */
655     function tokenByIndex(uint256 index) external view returns (uint256);
656 }
657 
658 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
659 
660 
661 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
662 
663 pragma solidity ^0.8.0;
664 
665 
666 /**
667  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
668  * @dev See https://eips.ethereum.org/EIPS/eip-721
669  */
670 interface IERC721Metadata is IERC721 {
671     /**
672      * @dev Returns the token collection name.
673      */
674     function name() external view returns (string memory);
675 
676     /**
677      * @dev Returns the token collection symbol.
678      */
679     function symbol() external view returns (string memory);
680 
681     /**
682      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
683      */
684     function tokenURI(uint256 tokenId) external view returns (string memory);
685 }
686 
687 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
688 
689 
690 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
691 
692 pragma solidity ^0.8.0;
693 
694 
695 
696 
697 
698 
699 
700 
701 /**
702  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
703  * the Metadata extension, but not including the Enumerable extension, which is available separately as
704  * {ERC721Enumerable}.
705  */
706 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
707     using Address for address;
708     using Strings for uint256;
709 
710     // Token name
711     string private _name;
712 
713     // Token symbol
714     string private _symbol;
715 
716     // Mapping from token ID to owner address
717     mapping(uint256 => address) private _owners;
718 
719     // Mapping owner address to token count
720     mapping(address => uint256) private _balances;
721 
722     // Mapping from token ID to approved address
723     mapping(uint256 => address) private _tokenApprovals;
724 
725     // Mapping from owner to operator approvals
726     mapping(address => mapping(address => bool)) private _operatorApprovals;
727 
728     /**
729      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
730      */
731     constructor(string memory name_, string memory symbol_) {
732         _name = name_;
733         _symbol = symbol_;
734     }
735 
736     /**
737      * @dev See {IERC165-supportsInterface}.
738      */
739     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
740         return
741             interfaceId == type(IERC721).interfaceId ||
742             interfaceId == type(IERC721Metadata).interfaceId ||
743             super.supportsInterface(interfaceId);
744     }
745 
746     /**
747      * @dev See {IERC721-balanceOf}.
748      */
749     function balanceOf(address owner) public view virtual override returns (uint256) {
750         require(owner != address(0), "ERC721: balance query for the zero address");
751         return _balances[owner];
752     }
753 
754     /**
755      * @dev See {IERC721-ownerOf}.
756      */
757     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
758         address owner = _owners[tokenId];
759         require(owner != address(0), "ERC721: owner query for nonexistent token");
760         return owner;
761     }
762 
763     /**
764      * @dev See {IERC721Metadata-name}.
765      */
766     function name() public view virtual override returns (string memory) {
767         return _name;
768     }
769 
770     /**
771      * @dev See {IERC721Metadata-symbol}.
772      */
773     function symbol() public view virtual override returns (string memory) {
774         return _symbol;
775     }
776 
777     /**
778      * @dev See {IERC721Metadata-tokenURI}.
779      */
780     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
781         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
782 
783         string memory baseURI = _baseURI();
784         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
785     }
786 
787     /**
788      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
789      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
790      * by default, can be overriden in child contracts.
791      */
792     function _baseURI() internal view virtual returns (string memory) {
793         return "";
794     }
795 
796     /**
797      * @dev See {IERC721-approve}.
798      */
799     function approve(address to, uint256 tokenId) public virtual override {
800         address owner = ERC721.ownerOf(tokenId);
801         require(to != owner, "ERC721: approval to current owner");
802 
803         require(
804             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
805             "ERC721: approve caller is not owner nor approved for all"
806         );
807 
808         _approve(to, tokenId);
809     }
810 
811     /**
812      * @dev See {IERC721-getApproved}.
813      */
814     function getApproved(uint256 tokenId) public view virtual override returns (address) {
815         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
816 
817         return _tokenApprovals[tokenId];
818     }
819 
820     /**
821      * @dev See {IERC721-setApprovalForAll}.
822      */
823     function setApprovalForAll(address operator, bool approved) public virtual override {
824         _setApprovalForAll(_msgSender(), operator, approved);
825     }
826 
827     /**
828      * @dev See {IERC721-isApprovedForAll}.
829      */
830     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
831         return _operatorApprovals[owner][operator];
832     }
833 
834     /**
835      * @dev See {IERC721-transferFrom}.
836      */
837     function transferFrom(
838         address from,
839         address to,
840         uint256 tokenId
841     ) public virtual override {
842         //solhint-disable-next-line max-line-length
843         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
844 
845         _transfer(from, to, tokenId);
846     }
847 
848     /**
849      * @dev See {IERC721-safeTransferFrom}.
850      */
851     function safeTransferFrom(
852         address from,
853         address to,
854         uint256 tokenId
855     ) public virtual override {
856         safeTransferFrom(from, to, tokenId, "");
857     }
858 
859     /**
860      * @dev See {IERC721-safeTransferFrom}.
861      */
862     function safeTransferFrom(
863         address from,
864         address to,
865         uint256 tokenId,
866         bytes memory _data
867     ) public virtual override {
868         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
869         _safeTransfer(from, to, tokenId, _data);
870     }
871 
872     /**
873      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
874      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
875      *
876      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
877      *
878      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
879      * implement alternative mechanisms to perform token transfer, such as signature-based.
880      *
881      * Requirements:
882      *
883      * - `from` cannot be the zero address.
884      * - `to` cannot be the zero address.
885      * - `tokenId` token must exist and be owned by `from`.
886      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _safeTransfer(
891         address from,
892         address to,
893         uint256 tokenId,
894         bytes memory _data
895     ) internal virtual {
896         _transfer(from, to, tokenId);
897         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
898     }
899 
900     /**
901      * @dev Returns whether `tokenId` exists.
902      *
903      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
904      *
905      * Tokens start existing when they are minted (`_mint`),
906      * and stop existing when they are burned (`_burn`).
907      */
908     function _exists(uint256 tokenId) internal view virtual returns (bool) {
909         return _owners[tokenId] != address(0);
910     }
911 
912     /**
913      * @dev Returns whether `spender` is allowed to manage `tokenId`.
914      *
915      * Requirements:
916      *
917      * - `tokenId` must exist.
918      */
919     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
920         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
921         address owner = ERC721.ownerOf(tokenId);
922         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
923     }
924 
925     /**
926      * @dev Safely mints `tokenId` and transfers it to `to`.
927      *
928      * Requirements:
929      *
930      * - `tokenId` must not exist.
931      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
932      *
933      * Emits a {Transfer} event.
934      */
935     function _safeMint(address to, uint256 tokenId) internal virtual {
936         _safeMint(to, tokenId, "");
937     }
938 
939     /**
940      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
941      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
942      */
943     function _safeMint(
944         address to,
945         uint256 tokenId,
946         bytes memory _data
947     ) internal virtual {
948         _mint(to, tokenId);
949         require(
950             _checkOnERC721Received(address(0), to, tokenId, _data),
951             "ERC721: transfer to non ERC721Receiver implementer"
952         );
953     }
954 
955     /**
956      * @dev Mints `tokenId` and transfers it to `to`.
957      *
958      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
959      *
960      * Requirements:
961      *
962      * - `tokenId` must not exist.
963      * - `to` cannot be the zero address.
964      *
965      * Emits a {Transfer} event.
966      */
967     function _mint(address to, uint256 tokenId) internal virtual {
968         require(to != address(0), "ERC721: mint to the zero address");
969         require(!_exists(tokenId), "ERC721: token already minted");
970 
971         _beforeTokenTransfer(address(0), to, tokenId);
972 
973         _balances[to] += 1;
974         _owners[tokenId] = to;
975 
976         emit Transfer(address(0), to, tokenId);
977     }
978 
979     /**
980      * @dev Destroys `tokenId`.
981      * The approval is cleared when the token is burned.
982      *
983      * Requirements:
984      *
985      * - `tokenId` must exist.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _burn(uint256 tokenId) internal virtual {
990         address owner = ERC721.ownerOf(tokenId);
991 
992         _beforeTokenTransfer(owner, address(0), tokenId);
993 
994         // Clear approvals
995         _approve(address(0), tokenId);
996 
997         _balances[owner] -= 1;
998         delete _owners[tokenId];
999 
1000         emit Transfer(owner, address(0), tokenId);
1001     }
1002 
1003     /**
1004      * @dev Transfers `tokenId` from `from` to `to`.
1005      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1006      *
1007      * Requirements:
1008      *
1009      * - `to` cannot be the zero address.
1010      * - `tokenId` token must be owned by `from`.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _transfer(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) internal virtual {
1019         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1020         require(to != address(0), "ERC721: transfer to the zero address");
1021 
1022         _beforeTokenTransfer(from, to, tokenId);
1023 
1024         // Clear approvals from the previous owner
1025         _approve(address(0), tokenId);
1026 
1027         _balances[from] -= 1;
1028         _balances[to] += 1;
1029         _owners[tokenId] = to;
1030 
1031         emit Transfer(from, to, tokenId);
1032     }
1033 
1034     /**
1035      * @dev Approve `to` to operate on `tokenId`
1036      *
1037      * Emits a {Approval} event.
1038      */
1039     function _approve(address to, uint256 tokenId) internal virtual {
1040         _tokenApprovals[tokenId] = to;
1041         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1042     }
1043 
1044     /**
1045      * @dev Approve `operator` to operate on all of `owner` tokens
1046      *
1047      * Emits a {ApprovalForAll} event.
1048      */
1049     function _setApprovalForAll(
1050         address owner,
1051         address operator,
1052         bool approved
1053     ) internal virtual {
1054         require(owner != operator, "ERC721: approve to caller");
1055         _operatorApprovals[owner][operator] = approved;
1056         emit ApprovalForAll(owner, operator, approved);
1057     }
1058 
1059     /**
1060      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1061      * The call is not executed if the target address is not a contract.
1062      *
1063      * @param from address representing the previous owner of the given token ID
1064      * @param to target address that will receive the tokens
1065      * @param tokenId uint256 ID of the token to be transferred
1066      * @param _data bytes optional data to send along with the call
1067      * @return bool whether the call correctly returned the expected magic value
1068      */
1069     function _checkOnERC721Received(
1070         address from,
1071         address to,
1072         uint256 tokenId,
1073         bytes memory _data
1074     ) private returns (bool) {
1075         if (to.isContract()) {
1076             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1077                 return retval == IERC721Receiver.onERC721Received.selector;
1078             } catch (bytes memory reason) {
1079                 if (reason.length == 0) {
1080                     revert("ERC721: transfer to non ERC721Receiver implementer");
1081                 } else {
1082                     assembly {
1083                         revert(add(32, reason), mload(reason))
1084                     }
1085                 }
1086             }
1087         } else {
1088             return true;
1089         }
1090     }
1091 
1092     /**
1093      * @dev Hook that is called before any token transfer. This includes minting
1094      * and burning.
1095      *
1096      * Calling conditions:
1097      *
1098      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1099      * transferred to `to`.
1100      * - When `from` is zero, `tokenId` will be minted for `to`.
1101      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1102      * - `from` and `to` are never both zero.
1103      *
1104      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1105      */
1106     function _beforeTokenTransfer(
1107         address from,
1108         address to,
1109         uint256 tokenId
1110     ) internal virtual {}
1111 }
1112 
1113 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1114 
1115 
1116 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1117 
1118 pragma solidity ^0.8.0;
1119 
1120 
1121 
1122 /**
1123  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1124  * enumerability of all the token ids in the contract as well as all token ids owned by each
1125  * account.
1126  */
1127 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1128     // Mapping from owner to list of owned token IDs
1129     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1130 
1131     // Mapping from token ID to index of the owner tokens list
1132     mapping(uint256 => uint256) private _ownedTokensIndex;
1133 
1134     // Array with all token ids, used for enumeration
1135     uint256[] private _allTokens;
1136 
1137     // Mapping from token id to position in the allTokens array
1138     mapping(uint256 => uint256) private _allTokensIndex;
1139 
1140     /**
1141      * @dev See {IERC165-supportsInterface}.
1142      */
1143     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1144         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1145     }
1146 
1147     /**
1148      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1149      */
1150     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1151         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1152         return _ownedTokens[owner][index];
1153     }
1154 
1155     /**
1156      * @dev See {IERC721Enumerable-totalSupply}.
1157      */
1158     function totalSupply() public view virtual override returns (uint256) {
1159         return _allTokens.length;
1160     }
1161 
1162     /**
1163      * @dev See {IERC721Enumerable-tokenByIndex}.
1164      */
1165     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1166         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1167         return _allTokens[index];
1168     }
1169 
1170     /**
1171      * @dev Hook that is called before any token transfer. This includes minting
1172      * and burning.
1173      *
1174      * Calling conditions:
1175      *
1176      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1177      * transferred to `to`.
1178      * - When `from` is zero, `tokenId` will be minted for `to`.
1179      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1180      * - `from` cannot be the zero address.
1181      * - `to` cannot be the zero address.
1182      *
1183      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1184      */
1185     function _beforeTokenTransfer(
1186         address from,
1187         address to,
1188         uint256 tokenId
1189     ) internal virtual override {
1190         super._beforeTokenTransfer(from, to, tokenId);
1191 
1192         if (from == address(0)) {
1193             _addTokenToAllTokensEnumeration(tokenId);
1194         } else if (from != to) {
1195             _removeTokenFromOwnerEnumeration(from, tokenId);
1196         }
1197         if (to == address(0)) {
1198             _removeTokenFromAllTokensEnumeration(tokenId);
1199         } else if (to != from) {
1200             _addTokenToOwnerEnumeration(to, tokenId);
1201         }
1202     }
1203 
1204     /**
1205      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1206      * @param to address representing the new owner of the given token ID
1207      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1208      */
1209     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1210         uint256 length = ERC721.balanceOf(to);
1211         _ownedTokens[to][length] = tokenId;
1212         _ownedTokensIndex[tokenId] = length;
1213     }
1214 
1215     /**
1216      * @dev Private function to add a token to this extension's token tracking data structures.
1217      * @param tokenId uint256 ID of the token to be added to the tokens list
1218      */
1219     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1220         _allTokensIndex[tokenId] = _allTokens.length;
1221         _allTokens.push(tokenId);
1222     }
1223 
1224     /**
1225      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1226      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1227      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1228      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1229      * @param from address representing the previous owner of the given token ID
1230      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1231      */
1232     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1233         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1234         // then delete the last slot (swap and pop).
1235 
1236         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1237         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1238 
1239         // When the token to delete is the last token, the swap operation is unnecessary
1240         if (tokenIndex != lastTokenIndex) {
1241             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1242 
1243             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1244             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1245         }
1246 
1247         // This also deletes the contents at the last position of the array
1248         delete _ownedTokensIndex[tokenId];
1249         delete _ownedTokens[from][lastTokenIndex];
1250     }
1251 
1252     /**
1253      * @dev Private function to remove a token from this extension's token tracking data structures.
1254      * This has O(1) time complexity, but alters the order of the _allTokens array.
1255      * @param tokenId uint256 ID of the token to be removed from the tokens list
1256      */
1257     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1258         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1259         // then delete the last slot (swap and pop).
1260 
1261         uint256 lastTokenIndex = _allTokens.length - 1;
1262         uint256 tokenIndex = _allTokensIndex[tokenId];
1263 
1264         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1265         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1266         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1267         uint256 lastTokenId = _allTokens[lastTokenIndex];
1268 
1269         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1270         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1271 
1272         // This also deletes the contents at the last position of the array
1273         delete _allTokensIndex[tokenId];
1274         _allTokens.pop();
1275     }
1276 }
1277 
1278 // File: contract/CyberDoge.sol
1279 
1280 
1281 pragma solidity ^0.8.0;
1282 
1283 
1284 
1285 contract CyberDoge is ERC721Enumerable, Ownable {
1286     using Strings for uint256;
1287 
1288     string baseURI;
1289     string public baseExtension = ".json";
1290     uint256 public cost = 0.06 ether;
1291     uint256 public maxSupply = 5555;
1292     uint256 public discount = 0.01 ether;
1293     uint256 public maxMintAmount = 20;
1294     mapping(address=>bool) public whitelistedAdresses;
1295     bool public paused = true;
1296     bool public revealed;
1297     string public notRevealedUri;
1298 
1299     constructor(
1300         string memory _name,    
1301         string memory _symbol,
1302         string memory _initBaseURI,
1303         string memory _initNotRevealedUri
1304     ) ERC721(_name, _symbol) {
1305         setBaseURI(_initBaseURI);
1306         setNotRevealedURI(_initNotRevealedUri);
1307     }
1308 
1309     // internal
1310     function _baseURI() internal view virtual override returns (string memory) {
1311         return baseURI;
1312     }
1313 
1314     // public
1315     function mint(uint256 _mintAmount) public payable {
1316         require(!paused);
1317         uint256 supply = totalSupply();
1318         require(supply>=2);
1319         uint256 priceToPay = cost;
1320         if (msg.sender != owner()) {
1321             if(whitelistedAdresses[msg.sender] == true) {
1322                 priceToPay -= discount;
1323             }
1324             require(msg.value >= priceToPay * _mintAmount,"not enough value");
1325         }
1326         require(_mintAmount > 0);
1327         require(_mintAmount <= maxMintAmount);
1328         require(supply + _mintAmount <= maxSupply);
1329         for (uint256 i = 1; i <= _mintAmount; i++) {
1330             _safeMint(msg.sender,supply+i);
1331         }
1332     }
1333 
1334     function mintUniqueAddress(address _user) public onlyOwner{
1335         uint256 supply = totalSupply();
1336         require(supply<2);
1337         _safeMint(_user,supply+1);
1338     }
1339     
1340     function walletOfOwner(address _owner)
1341         public
1342         view
1343         returns (uint256[] memory)
1344     {
1345         uint256 ownerTokenCount = balanceOf(_owner);
1346         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1347         for (uint256 i; i < ownerTokenCount; i++) {
1348             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1349         }
1350         return tokenIds;
1351     }
1352 
1353     function tokenURI(uint256 tokenId)
1354         public
1355         view
1356         virtual
1357         override
1358         returns (string memory)
1359     {
1360         require(
1361             _exists(tokenId),
1362             "ERC721Metadata: URI query for nonexistent token"
1363         );
1364 
1365         if(!revealed) {
1366             return notRevealedUri;
1367         }
1368 
1369         string memory currentBaseURI = _baseURI();
1370         return bytes(currentBaseURI).length > 0
1371         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1372         : "";
1373     }
1374 
1375     //only owner
1376     function reveal() public onlyOwner() {
1377         revealed = true;
1378     }
1379 
1380     function setCost(uint256 _newCost) public onlyOwner() {
1381         cost = _newCost;
1382     }
1383 
1384     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1385         maxMintAmount = _newmaxMintAmount;
1386     }
1387 
1388     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner() {
1389         notRevealedUri = _notRevealedURI;
1390     }
1391 
1392     function setBaseURI(string memory _newBaseURI) public onlyOwner() {
1393         baseURI = _newBaseURI;
1394     }
1395 
1396     function setBaseExtension(string memory _newBaseExtension) public onlyOwner() {
1397         baseExtension = _newBaseExtension;
1398     }
1399 
1400     function pause(bool _state) public onlyOwner() {
1401         paused = _state;
1402     }
1403 
1404     function setDiscount(uint256 _percent) public onlyOwner() {
1405         discount = _percent;
1406     }
1407 
1408     function whitelistUsers(address[] memory _users,bool whitelisted) public onlyOwner() {
1409         for(uint256 i = 0; i< _users.length;i++){
1410             whitelistedAdresses[_users[i]]=whitelisted;
1411         }
1412     }
1413 
1414     function withdraw() public payable onlyOwner() {
1415         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1416         require(success);
1417     }
1418 }