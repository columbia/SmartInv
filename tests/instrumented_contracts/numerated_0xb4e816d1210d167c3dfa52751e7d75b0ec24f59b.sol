1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Address.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
7 
8 pragma solidity ^0.8.1;
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library Address {
14     /**
15      * @dev Returns true if `account` is a contract.
16      *
17      * [IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, `isContract` will return false for the following
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      * ====
30      *
31      * [IMPORTANT]
32      * ====
33      * You shouldn't rely on `isContract` to protect against flash loan attacks!
34      *
35      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
36      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
37      * constructor.
38      * ====
39      */
40     function isContract(address account) internal view returns (bool) {
41         // This method relies on extcodesize/address.code.length, which returns 0
42         // for contracts in construction, since the code is only stored at the end
43         // of the constructor execution.
44 
45         return account.code.length > 0;
46     }
47 
48     /**
49      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
50      * `recipient`, forwarding all available gas and reverting on errors.
51      *
52      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
53      * of certain opcodes, possibly making contracts go over the 2300 gas limit
54      * imposed by `transfer`, making them unable to receive funds via
55      * `transfer`. {sendValue} removes this limitation.
56      *
57      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
58      *
59      * IMPORTANT: because control is transferred to `recipient`, care must be
60      * taken to not create reentrancy vulnerabilities. Consider using
61      * {ReentrancyGuard} or the
62      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
63      */
64     function sendValue(address payable recipient, uint256 amount) internal {
65         require(address(this).balance >= amount, "Address: insufficient balance");
66 
67         (bool success, ) = recipient.call{value: amount}("");
68         require(success, "Address: unable to send value, recipient may have reverted");
69     }
70 
71     /**
72      * @dev Performs a Solidity function call using a low level `call`. A
73      * plain `call` is an unsafe replacement for a function call: use this
74      * function instead.
75      *
76      * If `target` reverts with a revert reason, it is bubbled up by this
77      * function (like regular Solidity function calls).
78      *
79      * Returns the raw returned data. To convert to the expected return value,
80      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
81      *
82      * Requirements:
83      *
84      * - `target` must be a contract.
85      * - calling `target` with `data` must not revert.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
90         return functionCall(target, data, "Address: low-level call failed");
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
95      * `errorMessage` as a fallback revert reason when `target` reverts.
96      *
97      * _Available since v3.1._
98      */
99     function functionCall(
100         address target,
101         bytes memory data,
102         string memory errorMessage
103     ) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, 0, errorMessage);
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
109      * but also transferring `value` wei to `target`.
110      *
111      * Requirements:
112      *
113      * - the calling contract must have an ETH balance of at least `value`.
114      * - the called Solidity function must be `payable`.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(
119         address target,
120         bytes memory data,
121         uint256 value
122     ) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
124     }
125 
126     /**
127      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
128      * with `errorMessage` as a fallback revert reason when `target` reverts.
129      *
130      * _Available since v3.1._
131      */
132     function functionCallWithValue(
133         address target,
134         bytes memory data,
135         uint256 value,
136         string memory errorMessage
137     ) internal returns (bytes memory) {
138         require(address(this).balance >= value, "Address: insufficient balance for call");
139         require(isContract(target), "Address: call to non-contract");
140 
141         (bool success, bytes memory returndata) = target.call{value: value}(data);
142         return verifyCallResult(success, returndata, errorMessage);
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
147      * but performing a static call.
148      *
149      * _Available since v3.3._
150      */
151     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
152         return functionStaticCall(target, data, "Address: low-level static call failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
157      * but performing a static call.
158      *
159      * _Available since v3.3._
160      */
161     function functionStaticCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal view returns (bytes memory) {
166         require(isContract(target), "Address: static call to non-contract");
167 
168         (bool success, bytes memory returndata) = target.staticcall(data);
169         return verifyCallResult(success, returndata, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but performing a delegate call.
175      *
176      * _Available since v3.4._
177      */
178     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
179         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
184      * but performing a delegate call.
185      *
186      * _Available since v3.4._
187      */
188     function functionDelegateCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         require(isContract(target), "Address: delegate call to non-contract");
194 
195         (bool success, bytes memory returndata) = target.delegatecall(data);
196         return verifyCallResult(success, returndata, errorMessage);
197     }
198 
199     /**
200      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
201      * revert reason using the provided one.
202      *
203      * _Available since v4.3._
204      */
205     function verifyCallResult(
206         bool success,
207         bytes memory returndata,
208         string memory errorMessage
209     ) internal pure returns (bytes memory) {
210         if (success) {
211             return returndata;
212         } else {
213             // Look for revert reason and bubble it up if present
214             if (returndata.length > 0) {
215                 // The easiest way to bubble the revert reason is using memory via assembly
216                 /// @solidity memory-safe-assembly
217                 assembly {
218                     let returndata_size := mload(returndata)
219                     revert(add(32, returndata), returndata_size)
220                 }
221             } else {
222                 revert(errorMessage);
223             }
224         }
225     }
226 }
227 
228 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
229 
230 
231 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @title ERC721 token receiver interface
237  * @dev Interface for any contract that wants to support safeTransfers
238  * from ERC721 asset contracts.
239  */
240 interface IERC721Receiver {
241     /**
242      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
243      * by `operator` from `from`, this function is called.
244      *
245      * It must return its Solidity selector to confirm the token transfer.
246      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
247      *
248      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
249      */
250     function onERC721Received(
251         address operator,
252         address from,
253         uint256 tokenId,
254         bytes calldata data
255     ) external returns (bytes4);
256 }
257 
258 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
259 
260 
261 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
262 
263 pragma solidity ^0.8.0;
264 
265 /**
266  * @dev Interface of the ERC165 standard, as defined in the
267  * https://eips.ethereum.org/EIPS/eip-165[EIP].
268  *
269  * Implementers can declare support of contract interfaces, which can then be
270  * queried by others ({ERC165Checker}).
271  *
272  * For an implementation, see {ERC165}.
273  */
274 interface IERC165 {
275     /**
276      * @dev Returns true if this contract implements the interface defined by
277      * `interfaceId`. See the corresponding
278      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
279      * to learn more about how these ids are created.
280      *
281      * This function call must use less than 30 000 gas.
282      */
283     function supportsInterface(bytes4 interfaceId) external view returns (bool);
284 }
285 
286 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
287 
288 
289 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 
294 /**
295  * @dev Implementation of the {IERC165} interface.
296  *
297  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
298  * for the additional interface id that will be supported. For example:
299  *
300  * ```solidity
301  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
302  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
303  * }
304  * ```
305  *
306  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
307  */
308 abstract contract ERC165 is IERC165 {
309     /**
310      * @dev See {IERC165-supportsInterface}.
311      */
312     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
313         return interfaceId == type(IERC165).interfaceId;
314     }
315 }
316 
317 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
318 
319 
320 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
321 
322 pragma solidity ^0.8.0;
323 
324 
325 /**
326  * @dev Required interface of an ERC721 compliant contract.
327  */
328 interface IERC721 is IERC165 {
329     /**
330      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
331      */
332     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
333 
334     /**
335      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
336      */
337     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
338 
339     /**
340      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
341      */
342     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
343 
344     /**
345      * @dev Returns the number of tokens in ``owner``'s account.
346      */
347     function balanceOf(address owner) external view returns (uint256 balance);
348 
349     /**
350      * @dev Returns the owner of the `tokenId` token.
351      *
352      * Requirements:
353      *
354      * - `tokenId` must exist.
355      */
356     function ownerOf(uint256 tokenId) external view returns (address owner);
357 
358     /**
359      * @dev Safely transfers `tokenId` token from `from` to `to`.
360      *
361      * Requirements:
362      *
363      * - `from` cannot be the zero address.
364      * - `to` cannot be the zero address.
365      * - `tokenId` token must exist and be owned by `from`.
366      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
367      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
368      *
369      * Emits a {Transfer} event.
370      */
371     function safeTransferFrom(
372         address from,
373         address to,
374         uint256 tokenId,
375         bytes calldata data
376     ) external;
377 
378     /**
379      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
380      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
381      *
382      * Requirements:
383      *
384      * - `from` cannot be the zero address.
385      * - `to` cannot be the zero address.
386      * - `tokenId` token must exist and be owned by `from`.
387      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
388      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
389      *
390      * Emits a {Transfer} event.
391      */
392     function safeTransferFrom(
393         address from,
394         address to,
395         uint256 tokenId
396     ) external;
397 
398     /**
399      * @dev Transfers `tokenId` token from `from` to `to`.
400      *
401      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
402      *
403      * Requirements:
404      *
405      * - `from` cannot be the zero address.
406      * - `to` cannot be the zero address.
407      * - `tokenId` token must be owned by `from`.
408      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
409      *
410      * Emits a {Transfer} event.
411      */
412     function transferFrom(
413         address from,
414         address to,
415         uint256 tokenId
416     ) external;
417 
418     /**
419      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
420      * The approval is cleared when the token is transferred.
421      *
422      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
423      *
424      * Requirements:
425      *
426      * - The caller must own the token or be an approved operator.
427      * - `tokenId` must exist.
428      *
429      * Emits an {Approval} event.
430      */
431     function approve(address to, uint256 tokenId) external;
432 
433     /**
434      * @dev Approve or remove `operator` as an operator for the caller.
435      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
436      *
437      * Requirements:
438      *
439      * - The `operator` cannot be the caller.
440      *
441      * Emits an {ApprovalForAll} event.
442      */
443     function setApprovalForAll(address operator, bool _approved) external;
444 
445     /**
446      * @dev Returns the account approved for `tokenId` token.
447      *
448      * Requirements:
449      *
450      * - `tokenId` must exist.
451      */
452     function getApproved(uint256 tokenId) external view returns (address operator);
453 
454     /**
455      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
456      *
457      * See {setApprovalForAll}
458      */
459     function isApprovedForAll(address owner, address operator) external view returns (bool);
460 }
461 
462 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
463 
464 
465 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 
470 /**
471  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
472  * @dev See https://eips.ethereum.org/EIPS/eip-721
473  */
474 interface IERC721Enumerable is IERC721 {
475     /**
476      * @dev Returns the total amount of tokens stored by the contract.
477      */
478     function totalSupply() external view returns (uint256);
479 
480     /**
481      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
482      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
483      */
484     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
485 
486     /**
487      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
488      * Use along with {totalSupply} to enumerate all tokens.
489      */
490     function tokenByIndex(uint256 index) external view returns (uint256);
491 }
492 
493 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 
501 /**
502  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
503  * @dev See https://eips.ethereum.org/EIPS/eip-721
504  */
505 interface IERC721Metadata is IERC721 {
506     /**
507      * @dev Returns the token collection name.
508      */
509     function name() external view returns (string memory);
510 
511     /**
512      * @dev Returns the token collection symbol.
513      */
514     function symbol() external view returns (string memory);
515 
516     /**
517      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
518      */
519     function tokenURI(uint256 tokenId) external view returns (string memory);
520 }
521 
522 // File: @openzeppelin/contracts/utils/Context.sol
523 
524 
525 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @dev Provides information about the current execution context, including the
531  * sender of the transaction and its data. While these are generally available
532  * via msg.sender and msg.data, they should not be accessed in such a direct
533  * manner, since when dealing with meta-transactions the account sending and
534  * paying for execution may not be the actual sender (as far as an application
535  * is concerned).
536  *
537  * This contract is only required for intermediate, library-like contracts.
538  */
539 abstract contract Context {
540     function _msgSender() internal view virtual returns (address) {
541         return msg.sender;
542     }
543 
544     function _msgData() internal view virtual returns (bytes calldata) {
545         return msg.data;
546     }
547 }
548 
549 // File: @openzeppelin/contracts/access/Ownable.sol
550 
551 
552 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
553 
554 pragma solidity ^0.8.0;
555 
556 
557 /**
558  * @dev Contract module which provides a basic access control mechanism, where
559  * there is an account (an owner) that can be granted exclusive access to
560  * specific functions.
561  *
562  * By default, the owner account will be the one that deploys the contract. This
563  * can later be changed with {transferOwnership}.
564  *
565  * This module is used through inheritance. It will make available the modifier
566  * `onlyOwner`, which can be applied to your functions to restrict their use to
567  * the owner.
568  */
569 abstract contract Ownable is Context {
570     address private _owner;
571 
572     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
573 
574     /**
575      * @dev Initializes the contract setting the deployer as the initial owner.
576      */
577     constructor() {
578         _transferOwnership(_msgSender());
579     }
580 
581     /**
582      * @dev Throws if called by any account other than the owner.
583      */
584     modifier onlyOwner() {
585         _checkOwner();
586         _;
587     }
588 
589     /**
590      * @dev Returns the address of the current owner.
591      */
592     function owner() public view virtual returns (address) {
593         return _owner;
594     }
595 
596     /**
597      * @dev Throws if the sender is not the owner.
598      */
599     function _checkOwner() internal view virtual {
600         require(owner() == _msgSender(), "Ownable: caller is not the owner");
601     }
602 
603     /**
604      * @dev Leaves the contract without owner. It will not be possible to call
605      * `onlyOwner` functions anymore. Can only be called by the current owner.
606      *
607      * NOTE: Renouncing ownership will leave the contract without an owner,
608      * thereby removing any functionality that is only available to the owner.
609      */
610     function renounceOwnership() public virtual onlyOwner {
611         _transferOwnership(address(0));
612     }
613 
614     /**
615      * @dev Transfers ownership of the contract to a new account (`newOwner`).
616      * Can only be called by the current owner.
617      */
618     function transferOwnership(address newOwner) public virtual onlyOwner {
619         require(newOwner != address(0), "Ownable: new owner is the zero address");
620         _transferOwnership(newOwner);
621     }
622 
623     /**
624      * @dev Transfers ownership of the contract to a new account (`newOwner`).
625      * Internal function without access restriction.
626      */
627     function _transferOwnership(address newOwner) internal virtual {
628         address oldOwner = _owner;
629         _owner = newOwner;
630         emit OwnershipTransferred(oldOwner, newOwner);
631     }
632 }
633 
634 // File: @openzeppelin/contracts/utils/Strings.sol
635 
636 
637 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 /**
642  * @dev String operations.
643  */
644 library Strings {
645     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
646     uint8 private constant _ADDRESS_LENGTH = 20;
647 
648     /**
649      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
650      */
651     function toString(uint256 value) internal pure returns (string memory) {
652         // Inspired by OraclizeAPI's implementation - MIT licence
653         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
654 
655         if (value == 0) {
656             return "0";
657         }
658         uint256 temp = value;
659         uint256 digits;
660         while (temp != 0) {
661             digits++;
662             temp /= 10;
663         }
664         bytes memory buffer = new bytes(digits);
665         while (value != 0) {
666             digits -= 1;
667             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
668             value /= 10;
669         }
670         return string(buffer);
671     }
672 
673     /**
674      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
675      */
676     function toHexString(uint256 value) internal pure returns (string memory) {
677         if (value == 0) {
678             return "0x00";
679         }
680         uint256 temp = value;
681         uint256 length = 0;
682         while (temp != 0) {
683             length++;
684             temp >>= 8;
685         }
686         return toHexString(value, length);
687     }
688 
689     /**
690      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
691      */
692     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
693         bytes memory buffer = new bytes(2 * length + 2);
694         buffer[0] = "0";
695         buffer[1] = "x";
696         for (uint256 i = 2 * length + 1; i > 1; --i) {
697             buffer[i] = _HEX_SYMBOLS[value & 0xf];
698             value >>= 4;
699         }
700         require(value == 0, "Strings: hex length insufficient");
701         return string(buffer);
702     }
703 
704     /**
705      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
706      */
707     function toHexString(address addr) internal pure returns (string memory) {
708         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
709     }
710 }
711 
712 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
713 
714 
715 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
716 
717 pragma solidity ^0.8.0;
718 
719 
720 
721 
722 
723 
724 
725 
726 /**
727  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
728  * the Metadata extension, but not including the Enumerable extension, which is available separately as
729  * {ERC721Enumerable}.
730  */
731 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
732     using Address for address;
733     using Strings for uint256;
734 
735     // Token name
736     string private _name;
737 
738     // Token symbol
739     string private _symbol;
740 
741     // Mapping from token ID to owner address
742     mapping(uint256 => address) private _owners;
743 
744     // Mapping owner address to token count
745     mapping(address => uint256) private _balances;
746 
747     // Mapping from token ID to approved address
748     mapping(uint256 => address) private _tokenApprovals;
749 
750     // Mapping from owner to operator approvals
751     mapping(address => mapping(address => bool)) private _operatorApprovals;
752 
753     /**
754      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
755      */
756     constructor(string memory name_, string memory symbol_) {
757         _name = name_;
758         _symbol = symbol_;
759     }
760 
761     /**
762      * @dev See {IERC165-supportsInterface}.
763      */
764     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
765         return
766             interfaceId == type(IERC721).interfaceId ||
767             interfaceId == type(IERC721Metadata).interfaceId ||
768             super.supportsInterface(interfaceId);
769     }
770 
771     /**
772      * @dev See {IERC721-balanceOf}.
773      */
774     function balanceOf(address owner) public view virtual override returns (uint256) {
775         require(owner != address(0), "ERC721: address zero is not a valid owner");
776         return _balances[owner];
777     }
778 
779     /**
780      * @dev See {IERC721-ownerOf}.
781      */
782     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
783         address owner = _owners[tokenId];
784         require(owner != address(0), "ERC721: invalid token ID");
785         return owner;
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-name}.
790      */
791     function name() public view virtual override returns (string memory) {
792         return _name;
793     }
794 
795     /**
796      * @dev See {IERC721Metadata-symbol}.
797      */
798     function symbol() public view virtual override returns (string memory) {
799         return _symbol;
800     }
801 
802     /**
803      * @dev See {IERC721Metadata-tokenURI}.
804      */
805     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
806         _requireMinted(tokenId);
807 
808         string memory baseURI = _baseURI();
809         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
810     }
811 
812     /**
813      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
814      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
815      * by default, can be overridden in child contracts.
816      */
817     function _baseURI() internal view virtual returns (string memory) {
818         return "";
819     }
820 
821     /**
822      * @dev See {IERC721-approve}.
823      */
824     function approve(address to, uint256 tokenId) public virtual override {
825         address owner = ERC721.ownerOf(tokenId);
826         require(to != owner, "ERC721: approval to current owner");
827 
828         require(
829             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
830             "ERC721: approve caller is not token owner nor approved for all"
831         );
832 
833         _approve(to, tokenId);
834     }
835 
836     /**
837      * @dev See {IERC721-getApproved}.
838      */
839     function getApproved(uint256 tokenId) public view virtual override returns (address) {
840         _requireMinted(tokenId);
841 
842         return _tokenApprovals[tokenId];
843     }
844 
845     /**
846      * @dev See {IERC721-setApprovalForAll}.
847      */
848     function setApprovalForAll(address operator, bool approved) public virtual override {
849         _setApprovalForAll(_msgSender(), operator, approved);
850     }
851 
852     /**
853      * @dev See {IERC721-isApprovedForAll}.
854      */
855     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
856         return _operatorApprovals[owner][operator];
857     }
858 
859     /**
860      * @dev See {IERC721-transferFrom}.
861      */
862     function transferFrom(
863         address from,
864         address to,
865         uint256 tokenId
866     ) public virtual override {
867         //solhint-disable-next-line max-line-length
868         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
869 
870         _transfer(from, to, tokenId);
871     }
872 
873     /**
874      * @dev See {IERC721-safeTransferFrom}.
875      */
876     function safeTransferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) public virtual override {
881         safeTransferFrom(from, to, tokenId, "");
882     }
883 
884     /**
885      * @dev See {IERC721-safeTransferFrom}.
886      */
887     function safeTransferFrom(
888         address from,
889         address to,
890         uint256 tokenId,
891         bytes memory data
892     ) public virtual override {
893         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
894         _safeTransfer(from, to, tokenId, data);
895     }
896 
897     /**
898      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
899      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
900      *
901      * `data` is additional data, it has no specified format and it is sent in call to `to`.
902      *
903      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
904      * implement alternative mechanisms to perform token transfer, such as signature-based.
905      *
906      * Requirements:
907      *
908      * - `from` cannot be the zero address.
909      * - `to` cannot be the zero address.
910      * - `tokenId` token must exist and be owned by `from`.
911      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
912      *
913      * Emits a {Transfer} event.
914      */
915     function _safeTransfer(
916         address from,
917         address to,
918         uint256 tokenId,
919         bytes memory data
920     ) internal virtual {
921         _transfer(from, to, tokenId);
922         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
923     }
924 
925     /**
926      * @dev Returns whether `tokenId` exists.
927      *
928      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
929      *
930      * Tokens start existing when they are minted (`_mint`),
931      * and stop existing when they are burned (`_burn`).
932      */
933     function _exists(uint256 tokenId) internal view virtual returns (bool) {
934         return _owners[tokenId] != address(0);
935     }
936 
937     /**
938      * @dev Returns whether `spender` is allowed to manage `tokenId`.
939      *
940      * Requirements:
941      *
942      * - `tokenId` must exist.
943      */
944     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
945         address owner = ERC721.ownerOf(tokenId);
946         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
947     }
948 
949     /**
950      * @dev Safely mints `tokenId` and transfers it to `to`.
951      *
952      * Requirements:
953      *
954      * - `tokenId` must not exist.
955      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
956      *
957      * Emits a {Transfer} event.
958      */
959     function _safeMint(address to, uint256 tokenId) internal virtual {
960         _safeMint(to, tokenId, "");
961     }
962 
963     /**
964      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
965      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
966      */
967     function _safeMint(
968         address to,
969         uint256 tokenId,
970         bytes memory data
971     ) internal virtual {
972         _mint(to, tokenId);
973         require(
974             _checkOnERC721Received(address(0), to, tokenId, data),
975             "ERC721: transfer to non ERC721Receiver implementer"
976         );
977     }
978 
979     /**
980      * @dev Mints `tokenId` and transfers it to `to`.
981      *
982      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
983      *
984      * Requirements:
985      *
986      * - `tokenId` must not exist.
987      * - `to` cannot be the zero address.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _mint(address to, uint256 tokenId) internal virtual {
992         require(to != address(0), "ERC721: mint to the zero address");
993         require(!_exists(tokenId), "ERC721: token already minted");
994 
995         _beforeTokenTransfer(address(0), to, tokenId);
996 
997         _balances[to] += 1;
998         _owners[tokenId] = to;
999 
1000         emit Transfer(address(0), to, tokenId);
1001 
1002         _afterTokenTransfer(address(0), to, tokenId);
1003     }
1004 
1005     /**
1006      * @dev Destroys `tokenId`.
1007      * The approval is cleared when the token is burned.
1008      *
1009      * Requirements:
1010      *
1011      * - `tokenId` must exist.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function _burn(uint256 tokenId) internal virtual {
1016         address owner = ERC721.ownerOf(tokenId);
1017 
1018         _beforeTokenTransfer(owner, address(0), tokenId);
1019 
1020         // Clear approvals
1021         _approve(address(0), tokenId);
1022 
1023         _balances[owner] -= 1;
1024         delete _owners[tokenId];
1025 
1026         emit Transfer(owner, address(0), tokenId);
1027 
1028         _afterTokenTransfer(owner, address(0), tokenId);
1029     }
1030 
1031     /**
1032      * @dev Transfers `tokenId` from `from` to `to`.
1033      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1034      *
1035      * Requirements:
1036      *
1037      * - `to` cannot be the zero address.
1038      * - `tokenId` token must be owned by `from`.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function _transfer(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) internal virtual {
1047         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1048         require(to != address(0), "ERC721: transfer to the zero address");
1049 
1050         _beforeTokenTransfer(from, to, tokenId);
1051 
1052         // Clear approvals from the previous owner
1053         _approve(address(0), tokenId);
1054 
1055         _balances[from] -= 1;
1056         _balances[to] += 1;
1057         _owners[tokenId] = to;
1058 
1059         emit Transfer(from, to, tokenId);
1060 
1061         _afterTokenTransfer(from, to, tokenId);
1062     }
1063 
1064     /**
1065      * @dev Approve `to` to operate on `tokenId`
1066      *
1067      * Emits an {Approval} event.
1068      */
1069     function _approve(address to, uint256 tokenId) internal virtual {
1070         _tokenApprovals[tokenId] = to;
1071         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1072     }
1073 
1074     /**
1075      * @dev Approve `operator` to operate on all of `owner` tokens
1076      *
1077      * Emits an {ApprovalForAll} event.
1078      */
1079     function _setApprovalForAll(
1080         address owner,
1081         address operator,
1082         bool approved
1083     ) internal virtual {
1084         require(owner != operator, "ERC721: approve to caller");
1085         _operatorApprovals[owner][operator] = approved;
1086         emit ApprovalForAll(owner, operator, approved);
1087     }
1088 
1089     /**
1090      * @dev Reverts if the `tokenId` has not been minted yet.
1091      */
1092     function _requireMinted(uint256 tokenId) internal view virtual {
1093         require(_exists(tokenId), "ERC721: invalid token ID");
1094     }
1095 
1096     /**
1097      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1098      * The call is not executed if the target address is not a contract.
1099      *
1100      * @param from address representing the previous owner of the given token ID
1101      * @param to target address that will receive the tokens
1102      * @param tokenId uint256 ID of the token to be transferred
1103      * @param data bytes optional data to send along with the call
1104      * @return bool whether the call correctly returned the expected magic value
1105      */
1106     function _checkOnERC721Received(
1107         address from,
1108         address to,
1109         uint256 tokenId,
1110         bytes memory data
1111     ) private returns (bool) {
1112         if (to.isContract()) {
1113             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1114                 return retval == IERC721Receiver.onERC721Received.selector;
1115             } catch (bytes memory reason) {
1116                 if (reason.length == 0) {
1117                     revert("ERC721: transfer to non ERC721Receiver implementer");
1118                 } else {
1119                     /// @solidity memory-safe-assembly
1120                     assembly {
1121                         revert(add(32, reason), mload(reason))
1122                     }
1123                 }
1124             }
1125         } else {
1126             return true;
1127         }
1128     }
1129 
1130     /**
1131      * @dev Hook that is called before any token transfer. This includes minting
1132      * and burning.
1133      *
1134      * Calling conditions:
1135      *
1136      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1137      * transferred to `to`.
1138      * - When `from` is zero, `tokenId` will be minted for `to`.
1139      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1140      * - `from` and `to` are never both zero.
1141      *
1142      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1143      */
1144     function _beforeTokenTransfer(
1145         address from,
1146         address to,
1147         uint256 tokenId
1148     ) internal virtual {}
1149 
1150     /**
1151      * @dev Hook that is called after any transfer of tokens. This includes
1152      * minting and burning.
1153      *
1154      * Calling conditions:
1155      *
1156      * - when `from` and `to` are both non-zero.
1157      * - `from` and `to` are never both zero.
1158      *
1159      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1160      */
1161     function _afterTokenTransfer(
1162         address from,
1163         address to,
1164         uint256 tokenId
1165     ) internal virtual {}
1166 }
1167 
1168 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1169 
1170 
1171 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1172 
1173 pragma solidity ^0.8.0;
1174 
1175 
1176 
1177 /**
1178  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1179  * enumerability of all the token ids in the contract as well as all token ids owned by each
1180  * account.
1181  */
1182 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1183     // Mapping from owner to list of owned token IDs
1184     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1185 
1186     // Mapping from token ID to index of the owner tokens list
1187     mapping(uint256 => uint256) private _ownedTokensIndex;
1188 
1189     // Array with all token ids, used for enumeration
1190     uint256[] private _allTokens;
1191 
1192     // Mapping from token id to position in the allTokens array
1193     mapping(uint256 => uint256) private _allTokensIndex;
1194 
1195     /**
1196      * @dev See {IERC165-supportsInterface}.
1197      */
1198     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1199         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1200     }
1201 
1202     /**
1203      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1204      */
1205     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1206         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1207         return _ownedTokens[owner][index];
1208     }
1209 
1210     /**
1211      * @dev See {IERC721Enumerable-totalSupply}.
1212      */
1213     function totalSupply() public view virtual override returns (uint256) {
1214         return _allTokens.length;
1215     }
1216 
1217     /**
1218      * @dev See {IERC721Enumerable-tokenByIndex}.
1219      */
1220     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1221         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1222         return _allTokens[index];
1223     }
1224 
1225     /**
1226      * @dev Hook that is called before any token transfer. This includes minting
1227      * and burning.
1228      *
1229      * Calling conditions:
1230      *
1231      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1232      * transferred to `to`.
1233      * - When `from` is zero, `tokenId` will be minted for `to`.
1234      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1235      * - `from` cannot be the zero address.
1236      * - `to` cannot be the zero address.
1237      *
1238      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1239      */
1240     function _beforeTokenTransfer(
1241         address from,
1242         address to,
1243         uint256 tokenId
1244     ) internal virtual override {
1245         super._beforeTokenTransfer(from, to, tokenId);
1246 
1247         if (from == address(0)) {
1248             _addTokenToAllTokensEnumeration(tokenId);
1249         } else if (from != to) {
1250             _removeTokenFromOwnerEnumeration(from, tokenId);
1251         }
1252         if (to == address(0)) {
1253             _removeTokenFromAllTokensEnumeration(tokenId);
1254         } else if (to != from) {
1255             _addTokenToOwnerEnumeration(to, tokenId);
1256         }
1257     }
1258 
1259     /**
1260      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1261      * @param to address representing the new owner of the given token ID
1262      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1263      */
1264     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1265         uint256 length = ERC721.balanceOf(to);
1266         _ownedTokens[to][length] = tokenId;
1267         _ownedTokensIndex[tokenId] = length;
1268     }
1269 
1270     /**
1271      * @dev Private function to add a token to this extension's token tracking data structures.
1272      * @param tokenId uint256 ID of the token to be added to the tokens list
1273      */
1274     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1275         _allTokensIndex[tokenId] = _allTokens.length;
1276         _allTokens.push(tokenId);
1277     }
1278 
1279     /**
1280      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1281      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1282      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1283      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1284      * @param from address representing the previous owner of the given token ID
1285      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1286      */
1287     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1288         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1289         // then delete the last slot (swap and pop).
1290 
1291         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1292         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1293 
1294         // When the token to delete is the last token, the swap operation is unnecessary
1295         if (tokenIndex != lastTokenIndex) {
1296             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1297 
1298             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1299             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1300         }
1301 
1302         // This also deletes the contents at the last position of the array
1303         delete _ownedTokensIndex[tokenId];
1304         delete _ownedTokens[from][lastTokenIndex];
1305     }
1306 
1307     /**
1308      * @dev Private function to remove a token from this extension's token tracking data structures.
1309      * This has O(1) time complexity, but alters the order of the _allTokens array.
1310      * @param tokenId uint256 ID of the token to be removed from the tokens list
1311      */
1312     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1313         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1314         // then delete the last slot (swap and pop).
1315 
1316         uint256 lastTokenIndex = _allTokens.length - 1;
1317         uint256 tokenIndex = _allTokensIndex[tokenId];
1318 
1319         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1320         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1321         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1322         uint256 lastTokenId = _allTokens[lastTokenIndex];
1323 
1324         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1325         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1326 
1327         // This also deletes the contents at the last position of the array
1328         delete _allTokensIndex[tokenId];
1329         _allTokens.pop();
1330     }
1331 }
1332 
1333 // File: TheGala.sol
1334 
1335 
1336 
1337 /*
1338 
1339                     ..',;::::::::;,'...             .'.
1340                 ..;codxxdoc;,,,,,,;::cccc,..        .cOl.
1341             .,lxO00Od:'..           ...,:lc,.     .cOKd.
1342           .'lx0KK0kd:.                    .,ll,.  .cOKKx.
1343         .,oOKK00Okl'                        .,lc..cO0KKx.
1344       .lk00000OOl.                           .:lok00KXk'
1345     .,dO000000Od'                              'lddk0KO;
1346     .;xOO000000k;                                .;cokKO:
1347     ;xkkOO000O0o.                                 .;cd00:
1348     dkkkkO0000O:.                                  .,lk0c
1349     xxxxkO0000k,                                    .'oOl.
1350     ddxxk00000x'                                     .,ol.
1351     ddodk00O00o.                                       ..
1352     ooodk00000o.
1353     llldkO0000o.               .......................................
1354     cclok00000o.              .';;;:::cccloodxxkkkkkxkkkxxddolcc:::;;'
1355     ccclk00000o.                  ........',coxO0KXXKXK0Oko:'......
1356     :::cd00000d'                            .,:cox0KK0OOxc.
1357     ;;::lk0000k,                             'ccccokOOOOd'
1358     ;;;;:d0000O:                             .clc::oO00Ol.
1359     ';;;;ck0000l.                            .cl:,,cx00O:
1360     .',,,;lk0KKx'                            'ol,,;:dO0k,
1361     ..,,,,lk0K0l.                          .:d;..;:ok0x'
1362       ..',''ck0KO:.                         'oc. .,;cx0d.
1363         ..'',:d0KO:.                       ,l:.   .,cdOl.
1364           ...',cx00o.                    .:l;.     .;okc.
1365             ....,cxOkl'.             ...;c:.        'lx:
1366               ....,cddoc;'.......',;:::,.          .;o,
1367                     ...,;::::;;;;;,'...              .;.
1368 
1369 */
1370 
1371 pragma solidity >=0.7.0 <0.9.0;
1372 
1373 contract TheGalaNFT is ERC721Enumerable, Ownable {
1374   // State Variables
1375     using Strings for uint256;
1376     address paymentContractAddress;
1377     // URI
1378     string baseURI;
1379     string baseExtension = ".json";
1380     string notRevealedURI;
1381     // Cost
1382     uint256 public cost = 0.03 ether;
1383     // Transactional Limits
1384     uint256 public maxWhitelistSupplyPlusOne = 775;
1385     uint256 public maxSupply = 999;
1386     uint256 public maxPerSessionPlusOne;
1387     uint256 public maxPerAddressPlusOne;
1388     // Boolean Operators
1389     bool public paused = true;
1390     bool public rsvpSale = false;
1391     bool public whitelistSale = false;
1392     bool public publicSale = false;
1393     bool public revealed = false;
1394     // RSVP Addresses
1395     address[] private rsvpAddresses;
1396     // Whitelist Addresses
1397     address[] private whitelistAddressesPhase1;
1398     address[] private whitelistAddressesPhase2;
1399     address[] private whitelistAddressesPhase3;
1400     address[] private whitelistAddressesPhase4;
1401     // Mapping of mints
1402     mapping(address => uint256) private mintedPerAddress;
1403     mapping(address => uint256) private whitelistPerAddress;
1404     mapping(address => uint256) private rsvpPerAddress;
1405 
1406     constructor(string memory _name, string memory _symbol,
1407                 string memory _initBaseURI,
1408                 string memory _initNotRevealedUri)
1409         ERC721(_name, _symbol) payable {
1410             setBaseURI(_initBaseURI);
1411             setNotRevealedURI(_initNotRevealedUri);
1412     }
1413 
1414   // Internal
1415     function _baseURI() internal view virtual override returns (string memory) {
1416       return baseURI;
1417     }
1418 
1419   // External
1420     // Mint
1421     function mint(uint256 _mintAmount) public payable {
1422       uint256 supply = totalSupply();
1423       require(!paused, "MINT IS CURRENTLY INACTIVE");
1424       // Whitelist Phase
1425       if
1426       (whitelistSale == true) {
1427         require(isWhitelisted(msg.sender), "WALLET IS NOT WHITELISTED; DOUBLE-CHECK WALLET, OR AWAIT PUBLIC MINT");
1428         require(supply + _mintAmount < maxWhitelistSupplyPlusOne, "MAX WHITELIST SUPPLY EXCEEDED");
1429         require(0 < _mintAmount && _mintAmount < maxPerSessionPlusOne, "MAX WHITELIST ASSETS PER SESSION EXCEEDED");
1430         uint256 whitelistMintCount = whitelistPerAddress[msg.sender];
1431         require(whitelistMintCount + _mintAmount < maxPerAddressPlusOne, "MAX WHITELIST ASSETS PER WALLET EXCEEDED");
1432         require(msg.value >= cost * _mintAmount, "INSUFFICIENT FUNDS");
1433         for (uint256 i = 1; i <= _mintAmount; i++) {
1434             whitelistPerAddress[msg.sender]++;
1435             _safeMint(msg.sender, supply + i);
1436         }
1437       }
1438       // RSVP Phase
1439       else if
1440       (rsvpSale == true) {
1441         require(isRsvp(msg.sender), "YOU DID NOT RSVP; DOUBLE-CHECK WALLET, OR AWAIT PUBLIC MINT");
1442         require(supply + _mintAmount <= maxSupply, "MAX SUPPLY EXCEEDED");
1443         require(0 < _mintAmount && _mintAmount < maxPerSessionPlusOne, "MAX RSVP ASSETS PER SESSION EXCEEDED");
1444         uint256 rsvpMintCount = rsvpPerAddress[msg.sender];
1445         require(rsvpMintCount + _mintAmount < maxPerAddressPlusOne, "MAX RSVP ASSETS PER WALLET EXCEEDED");
1446         require(msg.value >= cost * _mintAmount, "INSUFFICIENT FUNDS");
1447         for (uint256 i = 1; i <= _mintAmount; i++) {
1448             rsvpPerAddress[msg.sender]++;
1449             _safeMint(msg.sender, supply + i);
1450         }
1451       }
1452       // Public Phase
1453       else {
1454         require(publicSale, "MINT CLOSED TO PUBLIC");
1455         require(supply + _mintAmount <= maxSupply, "MAX SUPPLY EXCEEDED");
1456         require(0 < _mintAmount && _mintAmount < maxPerSessionPlusOne, "MAX ASSETS PER SESSION EXCEEDED");
1457         uint256 addressMintCount = mintedPerAddress[msg.sender];
1458         require(addressMintCount + _mintAmount < maxPerAddressPlusOne, "MAX ASSETS PER WALLET EXCEEDED");
1459         require(msg.value >= cost * _mintAmount, "INSUFFICIENT FUNDS");
1460         for (uint256 i = 1; i <= _mintAmount; i++) {
1461             mintedPerAddress[msg.sender]++;
1462             _safeMint(msg.sender, supply + i);
1463         }
1464       }
1465     }
1466 
1467     // RSVP Verification
1468     function isRsvp(address _user) public view returns (bool) {
1469       for (uint i = 0; i < rsvpAddresses.length; i++) {
1470         if (rsvpAddresses[i] == _user) {
1471           return true;
1472         }
1473       }
1474       return false;
1475     }
1476 
1477     // Whitelist Verification
1478     function isWhitelisted(address _user) public view returns (bool) {
1479       for (uint i = 0; i < whitelistAddressesPhase1.length; i++) {
1480         if (whitelistAddressesPhase1[i] == _user) {
1481           return true;
1482         }
1483       }
1484       for (uint j = 0; j < whitelistAddressesPhase2.length; j++) {
1485         if (whitelistAddressesPhase2[j] == _user) {
1486           return true;
1487         }
1488       }
1489       for (uint k = 0; k < whitelistAddressesPhase3.length; k++) {
1490         if (whitelistAddressesPhase3[k] == _user) {
1491           return true;
1492         }
1493       }
1494       for (uint n = 0; n < whitelistAddressesPhase4.length; n++) {
1495         if (whitelistAddressesPhase4[n] == _user) {
1496           return true;
1497         }
1498       }
1499       return false;
1500     }
1501 
1502     function walletOfOwner(address _owner)
1503       public
1504       view
1505       returns (uint256[] memory)
1506       {
1507       uint256 ownerTokenCount = balanceOf(_owner);
1508       uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1509       for (uint256 i; i < ownerTokenCount; i++) {
1510         tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1511       }
1512       return tokenIds;
1513     }
1514 
1515     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1516       require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1517       if(revealed == false) {
1518           return notRevealedURI;
1519       }
1520       string memory currentBaseURI = _baseURI();
1521       return bytes(currentBaseURI).length > 0
1522           ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1523           : "";
1524     }
1525 
1526   // Only Owner
1527     // Reveal URI
1528     function reveal() public onlyOwner {
1529       revealed = true;
1530     }
1531     // Transactional Setters
1532     function setCost(uint256 _newCost) public onlyOwner {
1533       cost = _newCost;
1534     }
1535     function setPerAddressLimitPlusOne(uint256 _limitPlusOne) public onlyOwner {
1536       maxPerAddressPlusOne = _limitPlusOne;
1537     }
1538     function setPerSessionLimitPlusOne(uint256 _newMintAmountLimitPlusOne) public onlyOwner {
1539       maxPerSessionPlusOne = _newMintAmountLimitPlusOne;
1540     }
1541     function setMaxSupply(uint256 _newMaxSupply) public onlyOwner {
1542       maxSupply = _newMaxSupply;
1543     }
1544     function setPaymentContractAddress(address _newPaymentContractAddress) public onlyOwner {
1545       paymentContractAddress = _newPaymentContractAddress;
1546     }
1547 
1548     // URI Setters
1549     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1550       baseURI = _newBaseURI;
1551     }
1552     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1553       baseExtension = _newBaseExtension;
1554     }
1555     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1556       notRevealedURI = _notRevealedURI;
1557     }
1558 
1559     // Toggle Paused State
1560     function togglePause() external onlyOwner {
1561       paused = !paused;
1562     }
1563 
1564     // Toggle Whitelist Sale
1565     function toggleWhitelistSale() external onlyOwner {
1566       paused = false;
1567       rsvpSale = false;
1568       publicSale = false;
1569       if (whitelistSale == false) {
1570         setPerSessionLimitPlusOne(3);
1571         setPerAddressLimitPlusOne(3);
1572       }
1573       whitelistSale = !whitelistSale;
1574     }
1575 
1576     // Toggle RSVP Sale
1577     function toggleRsvpSale() external onlyOwner {
1578       paused = false;
1579       whitelistSale = false;
1580       publicSale = false;
1581       if (rsvpSale == false) {
1582         setPerSessionLimitPlusOne(2);
1583         setPerAddressLimitPlusOne(2);
1584       }
1585       rsvpSale = !rsvpSale;
1586     }
1587 
1588     // Toggle Public Sale
1589     function togglePublicSale() external onlyOwner {
1590       paused = false;
1591       whitelistSale = false;
1592       rsvpSale = false;
1593       if (publicSale == false) {
1594         setPerSessionLimitPlusOne(11);
1595         setPerAddressLimitPlusOne(11);
1596       }
1597       publicSale = !publicSale;
1598     }
1599 
1600     // Unique Address Setters
1601         // Verified RSVP Addresses
1602         function setRsvpUsers(address[] calldata _rsvpAddresses) external onlyOwner {
1603             delete rsvpAddresses;
1604             rsvpAddresses = _rsvpAddresses;
1605         }
1606 
1607         // Verified Whitelist Addresses
1608         function setWhitelistUsersPhase1(address[] calldata _whitelistAddressesPhase1) external onlyOwner {
1609             delete whitelistAddressesPhase1;
1610             whitelistAddressesPhase1 = _whitelistAddressesPhase1;
1611         }
1612         function setWhitelistUsersPhase2(address[] calldata _whitelistAddressesPhase2) external onlyOwner {
1613             delete whitelistAddressesPhase2;
1614             whitelistAddressesPhase2 = _whitelistAddressesPhase2;
1615         }
1616         function setWhitelistUsersPhase3(address[] calldata _whitelistAddressesPhase3) external onlyOwner {
1617             delete whitelistAddressesPhase3;
1618             whitelistAddressesPhase3 = _whitelistAddressesPhase3;
1619         }
1620         function setWhitelistUsersPhase4(address[] calldata _whitelistAddressesPhase4) external onlyOwner {
1621             delete whitelistAddressesPhase4;
1622             whitelistAddressesPhase4 = _whitelistAddressesPhase4;
1623         }
1624 
1625     // Team Mint Execution
1626     function teamMint(uint256[] calldata _teamMintAmount, address[] calldata _wallet) external onlyOwner {
1627       require(_teamMintAmount.length == _wallet.length);
1628       for (uint256 j = 0; j < _teamMintAmount.length; j++) {
1629         uint256 supply = totalSupply();
1630         uint256 _amount = _teamMintAmount[j];
1631         address _to = _wallet[j];
1632         for (uint256 i = 1; i <= _amount; i++) {
1633             _safeMint(_to, supply + i);
1634         }
1635       }
1636     }
1637     
1638     // Team Withdrawal
1639     function withdraw() external payable onlyOwner {
1640       (bool xs, ) = payable(paymentContractAddress).call{value: address(this).balance}("");
1641       require(xs);
1642     }
1643 }