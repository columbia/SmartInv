1 // SPDX-License-Identifier: MIT
2 // File: contracts\openzeppelin-contracts\contracts\utils\Context.sol
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: contracts\openzeppelin-contracts\contracts\access\Ownable.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // File: contracts\openzeppelin-contracts\contracts\utils\introspection\IERC165.sol
107 
108 
109 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev Interface of the ERC165 standard, as defined in the
115  * https://eips.ethereum.org/EIPS/eip-165[EIP].
116  *
117  * Implementers can declare support of contract interfaces, which can then be
118  * queried by others ({ERC165Checker}).
119  *
120  * For an implementation, see {ERC165}.
121  */
122 interface IERC165 {
123     /**
124      * @dev Returns true if this contract implements the interface defined by
125      * `interfaceId`. See the corresponding
126      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
127      * to learn more about how these ids are created.
128      *
129      * This function call must use less than 30 000 gas.
130      */
131     function supportsInterface(bytes4 interfaceId) external view returns (bool);
132 }
133 
134 // File: contracts\openzeppelin-contracts\contracts\token\ERC721\IERC721.sol
135 
136 
137 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
138 
139 pragma solidity ^0.8.0;
140 
141 
142 /**
143  * @dev Required interface of an ERC721 compliant contract.
144  */
145 interface IERC721 is IERC165 {
146     /**
147      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
148      */
149     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
150 
151     /**
152      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
153      */
154     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
155 
156     /**
157      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
158      */
159     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
160 
161     /**
162      * @dev Returns the number of tokens in ``owner``'s account.
163      */
164     function balanceOf(address owner) external view returns (uint256 balance);
165 
166     /**
167      * @dev Returns the owner of the `tokenId` token.
168      *
169      * Requirements:
170      *
171      * - `tokenId` must exist.
172      */
173     function ownerOf(uint256 tokenId) external view returns (address owner);
174 
175     /**
176      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
177      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
178      *
179      * Requirements:
180      *
181      * - `from` cannot be the zero address.
182      * - `to` cannot be the zero address.
183      * - `tokenId` token must exist and be owned by `from`.
184      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
185      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
186      *
187      * Emits a {Transfer} event.
188      */
189     function safeTransferFrom(
190         address from,
191         address to,
192         uint256 tokenId
193     ) external;
194 
195     /**
196      * @dev Transfers `tokenId` token from `from` to `to`.
197      *
198      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
199      *
200      * Requirements:
201      *
202      * - `from` cannot be the zero address.
203      * - `to` cannot be the zero address.
204      * - `tokenId` token must be owned by `from`.
205      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transferFrom(
210         address from,
211         address to,
212         uint256 tokenId
213     ) external;
214 
215     /**
216      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
217      * The approval is cleared when the token is transferred.
218      *
219      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
220      *
221      * Requirements:
222      *
223      * - The caller must own the token or be an approved operator.
224      * - `tokenId` must exist.
225      *
226      * Emits an {Approval} event.
227      */
228     function approve(address to, uint256 tokenId) external;
229 
230     /**
231      * @dev Returns the account approved for `tokenId` token.
232      *
233      * Requirements:
234      *
235      * - `tokenId` must exist.
236      */
237     function getApproved(uint256 tokenId) external view returns (address operator);
238 
239     /**
240      * @dev Approve or remove `operator` as an operator for the caller.
241      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
242      *
243      * Requirements:
244      *
245      * - The `operator` cannot be the caller.
246      *
247      * Emits an {ApprovalForAll} event.
248      */
249     function setApprovalForAll(address operator, bool _approved) external;
250 
251     /**
252      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
253      *
254      * See {setApprovalForAll}
255      */
256     function isApprovedForAll(address owner, address operator) external view returns (bool);
257 
258     /**
259      * @dev Safely transfers `tokenId` token from `from` to `to`.
260      *
261      * Requirements:
262      *
263      * - `from` cannot be the zero address.
264      * - `to` cannot be the zero address.
265      * - `tokenId` token must exist and be owned by `from`.
266      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
267      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
268      *
269      * Emits a {Transfer} event.
270      */
271     function safeTransferFrom(
272         address from,
273         address to,
274         uint256 tokenId,
275         bytes calldata data
276     ) external;
277 }
278 
279 // File: contracts\openzeppelin-contracts\contracts\token\ERC721\IERC721Receiver.sol
280 
281 
282 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
283 
284 pragma solidity ^0.8.0;
285 
286 /**
287  * @title ERC721 token receiver interface
288  * @dev Interface for any contract that wants to support safeTransfers
289  * from ERC721 asset contracts.
290  */
291 interface IERC721Receiver {
292     /**
293      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
294      * by `operator` from `from`, this function is called.
295      *
296      * It must return its Solidity selector to confirm the token transfer.
297      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
298      *
299      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
300      */
301     function onERC721Received(
302         address operator,
303         address from,
304         uint256 tokenId,
305         bytes calldata data
306     ) external returns (bytes4);
307 }
308 
309 // File: contracts\openzeppelin-contracts\contracts\token\ERC721\extensions\IERC721Metadata.sol
310 
311 
312 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
313 
314 pragma solidity ^0.8.0;
315 
316 
317 /**
318  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
319  * @dev See https://eips.ethereum.org/EIPS/eip-721
320  */
321 interface IERC721Metadata is IERC721 {
322     /**
323      * @dev Returns the token collection name.
324      */
325     function name() external view returns (string memory);
326 
327     /**
328      * @dev Returns the token collection symbol.
329      */
330     function symbol() external view returns (string memory);
331 
332     /**
333      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
334      */
335     function tokenURI(uint256 tokenId) external view returns (string memory);
336 }
337 
338 // File: contracts\openzeppelin-contracts\contracts\utils\Address.sol
339 
340 
341 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
342 
343 pragma solidity ^0.8.1;
344 
345 /**
346  * @dev Collection of functions related to the address type
347  */
348 library Address {
349     /**
350      * @dev Returns true if `account` is a contract.
351      *
352      * [IMPORTANT]
353      * ====
354      * It is unsafe to assume that an address for which this function returns
355      * false is an externally-owned account (EOA) and not a contract.
356      *
357      * Among others, `isContract` will return false for the following
358      * types of addresses:
359      *
360      *  - an externally-owned account
361      *  - a contract in construction
362      *  - an address where a contract will be created
363      *  - an address where a contract lived, but was destroyed
364      * ====
365      *
366      * [IMPORTANT]
367      * ====
368      * You shouldn't rely on `isContract` to protect against flash loan attacks!
369      *
370      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
371      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
372      * constructor.
373      * ====
374      */
375     function isContract(address account) internal view returns (bool) {
376         // This method relies on extcodesize/address.code.length, which returns 0
377         // for contracts in construction, since the code is only stored at the end
378         // of the constructor execution.
379 
380         return account.code.length > 0;
381     }
382 
383     /**
384      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
385      * `recipient`, forwarding all available gas and reverting on errors.
386      *
387      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
388      * of certain opcodes, possibly making contracts go over the 2300 gas limit
389      * imposed by `transfer`, making them unable to receive funds via
390      * `transfer`. {sendValue} removes this limitation.
391      *
392      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
393      *
394      * IMPORTANT: because control is transferred to `recipient`, care must be
395      * taken to not create reentrancy vulnerabilities. Consider using
396      * {ReentrancyGuard} or the
397      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
398      */
399     function sendValue(address payable recipient, uint256 amount) internal {
400         require(address(this).balance >= amount, "Address: insufficient balance");
401 
402         (bool success, ) = recipient.call{value: amount}("");
403         require(success, "Address: unable to send value, recipient may have reverted");
404     }
405 
406     /**
407      * @dev Performs a Solidity function call using a low level `call`. A
408      * plain `call` is an unsafe replacement for a function call: use this
409      * function instead.
410      *
411      * If `target` reverts with a revert reason, it is bubbled up by this
412      * function (like regular Solidity function calls).
413      *
414      * Returns the raw returned data. To convert to the expected return value,
415      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
416      *
417      * Requirements:
418      *
419      * - `target` must be a contract.
420      * - calling `target` with `data` must not revert.
421      *
422      * _Available since v3.1._
423      */
424     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
425         return functionCall(target, data, "Address: low-level call failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
430      * `errorMessage` as a fallback revert reason when `target` reverts.
431      *
432      * _Available since v3.1._
433      */
434     function functionCall(
435         address target,
436         bytes memory data,
437         string memory errorMessage
438     ) internal returns (bytes memory) {
439         return functionCallWithValue(target, data, 0, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but also transferring `value` wei to `target`.
445      *
446      * Requirements:
447      *
448      * - the calling contract must have an ETH balance of at least `value`.
449      * - the called Solidity function must be `payable`.
450      *
451      * _Available since v3.1._
452      */
453     function functionCallWithValue(
454         address target,
455         bytes memory data,
456         uint256 value
457     ) internal returns (bytes memory) {
458         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
463      * with `errorMessage` as a fallback revert reason when `target` reverts.
464      *
465      * _Available since v3.1._
466      */
467     function functionCallWithValue(
468         address target,
469         bytes memory data,
470         uint256 value,
471         string memory errorMessage
472     ) internal returns (bytes memory) {
473         require(address(this).balance >= value, "Address: insufficient balance for call");
474         require(isContract(target), "Address: call to non-contract");
475 
476         (bool success, bytes memory returndata) = target.call{value: value}(data);
477         return verifyCallResult(success, returndata, errorMessage);
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
482      * but performing a static call.
483      *
484      * _Available since v3.3._
485      */
486     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
487         return functionStaticCall(target, data, "Address: low-level static call failed");
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
492      * but performing a static call.
493      *
494      * _Available since v3.3._
495      */
496     function functionStaticCall(
497         address target,
498         bytes memory data,
499         string memory errorMessage
500     ) internal view returns (bytes memory) {
501         require(isContract(target), "Address: static call to non-contract");
502 
503         (bool success, bytes memory returndata) = target.staticcall(data);
504         return verifyCallResult(success, returndata, errorMessage);
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
509      * but performing a delegate call.
510      *
511      * _Available since v3.4._
512      */
513     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
514         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
519      * but performing a delegate call.
520      *
521      * _Available since v3.4._
522      */
523     function functionDelegateCall(
524         address target,
525         bytes memory data,
526         string memory errorMessage
527     ) internal returns (bytes memory) {
528         require(isContract(target), "Address: delegate call to non-contract");
529 
530         (bool success, bytes memory returndata) = target.delegatecall(data);
531         return verifyCallResult(success, returndata, errorMessage);
532     }
533 
534     /**
535      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
536      * revert reason using the provided one.
537      *
538      * _Available since v4.3._
539      */
540     function verifyCallResult(
541         bool success,
542         bytes memory returndata,
543         string memory errorMessage
544     ) internal pure returns (bytes memory) {
545         if (success) {
546             return returndata;
547         } else {
548             // Look for revert reason and bubble it up if present
549             if (returndata.length > 0) {
550                 // The easiest way to bubble the revert reason is using memory via assembly
551 
552                 assembly {
553                     let returndata_size := mload(returndata)
554                     revert(add(32, returndata), returndata_size)
555                 }
556             } else {
557                 revert(errorMessage);
558             }
559         }
560     }
561 }
562 
563 // File: contracts\openzeppelin-contracts\contracts\utils\Strings.sol
564 
565 
566 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
567 
568 pragma solidity ^0.8.0;
569 
570 /**
571  * @dev String operations.
572  */
573 library Strings {
574     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
575 
576     /**
577      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
578      */
579     function toString(uint256 value) internal pure returns (string memory) {
580         // Inspired by OraclizeAPI's implementation - MIT licence
581         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
582 
583         if (value == 0) {
584             return "0";
585         }
586         uint256 temp = value;
587         uint256 digits;
588         while (temp != 0) {
589             digits++;
590             temp /= 10;
591         }
592         bytes memory buffer = new bytes(digits);
593         while (value != 0) {
594             digits -= 1;
595             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
596             value /= 10;
597         }
598         return string(buffer);
599     }
600 
601     /**
602      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
603      */
604     function toHexString(uint256 value) internal pure returns (string memory) {
605         if (value == 0) {
606             return "0x00";
607         }
608         uint256 temp = value;
609         uint256 length = 0;
610         while (temp != 0) {
611             length++;
612             temp >>= 8;
613         }
614         return toHexString(value, length);
615     }
616 
617     /**
618      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
619      */
620     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
621         bytes memory buffer = new bytes(2 * length + 2);
622         buffer[0] = "0";
623         buffer[1] = "x";
624         for (uint256 i = 2 * length + 1; i > 1; --i) {
625             buffer[i] = _HEX_SYMBOLS[value & 0xf];
626             value >>= 4;
627         }
628         require(value == 0, "Strings: hex length insufficient");
629         return string(buffer);
630     }
631 }
632 
633 // File: contracts\openzeppelin-contracts\contracts\utils\introspection\ERC165.sol
634 
635 
636 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 
641 /**
642  * @dev Implementation of the {IERC165} interface.
643  *
644  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
645  * for the additional interface id that will be supported. For example:
646  *
647  * ```solidity
648  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
649  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
650  * }
651  * ```
652  *
653  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
654  */
655 abstract contract ERC165 is IERC165 {
656     /**
657      * @dev See {IERC165-supportsInterface}.
658      */
659     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
660         return interfaceId == type(IERC165).interfaceId;
661     }
662 }
663 
664 // File: contracts\openzeppelin-contracts\contracts\token\ERC721\ERC721.sol
665 
666 
667 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
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
1113 // File: contracts\openzeppelin-contracts\contracts\token\ERC721\extensions\IERC721Enumerable.sol
1114 
1115 
1116 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1117 
1118 pragma solidity ^0.8.0;
1119 
1120 
1121 /**
1122  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1123  * @dev See https://eips.ethereum.org/EIPS/eip-721
1124  */
1125 interface IERC721Enumerable is IERC721 {
1126     /**
1127      * @dev Returns the total amount of tokens stored by the contract.
1128      */
1129     function totalSupply() external view returns (uint256);
1130 
1131     /**
1132      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1133      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1134      */
1135     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1136 
1137     /**
1138      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1139      * Use along with {totalSupply} to enumerate all tokens.
1140      */
1141     function tokenByIndex(uint256 index) external view returns (uint256);
1142 }
1143 
1144 // File: contracts\openzeppelin-contracts\contracts\token\ERC721\extensions\ERC721Enumerable.sol
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
1309 // File: contracts\openzeppelin-contracts\contracts\security\ReentrancyGuard.sol
1310 
1311 
1312 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1313 
1314 pragma solidity ^0.8.0;
1315 
1316 /**
1317  * @dev Contract module that helps prevent reentrant calls to a function.
1318  *
1319  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1320  * available, which can be applied to functions to make sure there are no nested
1321  * (reentrant) calls to them.
1322  *
1323  * Note that because there is a single `nonReentrant` guard, functions marked as
1324  * `nonReentrant` may not call one another. This can be worked around by making
1325  * those functions `private`, and then adding `external` `nonReentrant` entry
1326  * points to them.
1327  *
1328  * TIP: If you would like to learn more about reentrancy and alternative ways
1329  * to protect against it, check out our blog post
1330  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1331  */
1332 abstract contract ReentrancyGuard {
1333     // Booleans are more expensive than uint256 or any type that takes up a full
1334     // word because each write operation emits an extra SLOAD to first read the
1335     // slot's contents, replace the bits taken up by the boolean, and then write
1336     // back. This is the compiler's defense against contract upgrades and
1337     // pointer aliasing, and it cannot be disabled.
1338 
1339     // The values being non-zero value makes deployment a bit more expensive,
1340     // but in exchange the refund on every call to nonReentrant will be lower in
1341     // amount. Since refunds are capped to a percentage of the total
1342     // transaction's gas, it is best to keep them low in cases like this one, to
1343     // increase the likelihood of the full refund coming into effect.
1344     uint256 private constant _NOT_ENTERED = 1;
1345     uint256 private constant _ENTERED = 2;
1346 
1347     uint256 private _status;
1348 
1349     constructor() {
1350         _status = _NOT_ENTERED;
1351     }
1352 
1353     /**
1354      * @dev Prevents a contract from calling itself, directly or indirectly.
1355      * Calling a `nonReentrant` function from another `nonReentrant`
1356      * function is not supported. It is possible to prevent this from happening
1357      * by making the `nonReentrant` function external, and making it call a
1358      * `private` function that does the actual work.
1359      */
1360     modifier nonReentrant() {
1361         // On the first call to nonReentrant, _notEntered will be true
1362         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1363 
1364         // Any calls to nonReentrant after this point will fail
1365         _status = _ENTERED;
1366 
1367         _;
1368 
1369         // By storing the original value once again, a refund is triggered (see
1370         // https://eips.ethereum.org/EIPS/eip-2200)
1371         _status = _NOT_ENTERED;
1372     }
1373 }
1374 
1375 // File: contracts\openzeppelin-contracts\contracts\utils\cryptography\ECDSA.sol
1376 
1377 
1378 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
1379 
1380 pragma solidity ^0.8.0;
1381 
1382 
1383 /**
1384  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1385  *
1386  * These functions can be used to verify that a message was signed by the holder
1387  * of the private keys of a given address.
1388  */
1389 library ECDSA {
1390     enum RecoverError {
1391         NoError,
1392         InvalidSignature,
1393         InvalidSignatureLength,
1394         InvalidSignatureS,
1395         InvalidSignatureV
1396     }
1397 
1398     function _throwError(RecoverError error) private pure {
1399         if (error == RecoverError.NoError) {
1400             return; // no error: do nothing
1401         } else if (error == RecoverError.InvalidSignature) {
1402             revert("ECDSA: invalid signature");
1403         } else if (error == RecoverError.InvalidSignatureLength) {
1404             revert("ECDSA: invalid signature length");
1405         } else if (error == RecoverError.InvalidSignatureS) {
1406             revert("ECDSA: invalid signature 's' value");
1407         } else if (error == RecoverError.InvalidSignatureV) {
1408             revert("ECDSA: invalid signature 'v' value");
1409         }
1410     }
1411 
1412     /**
1413      * @dev Returns the address that signed a hashed message (`hash`) with
1414      * `signature` or error string. This address can then be used for verification purposes.
1415      *
1416      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1417      * this function rejects them by requiring the `s` value to be in the lower
1418      * half order, and the `v` value to be either 27 or 28.
1419      *
1420      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1421      * verification to be secure: it is possible to craft signatures that
1422      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1423      * this is by receiving a hash of the original message (which may otherwise
1424      * be too long), and then calling {toEthSignedMessageHash} on it.
1425      *
1426      * Documentation for signature generation:
1427      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1428      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1429      *
1430      * _Available since v4.3._
1431      */
1432     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1433         // Check the signature length
1434         // - case 65: r,s,v signature (standard)
1435         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1436         if (signature.length == 65) {
1437             bytes32 r;
1438             bytes32 s;
1439             uint8 v;
1440             // ecrecover takes the signature parameters, and the only way to get them
1441             // currently is to use assembly.
1442             assembly {
1443                 r := mload(add(signature, 0x20))
1444                 s := mload(add(signature, 0x40))
1445                 v := byte(0, mload(add(signature, 0x60)))
1446             }
1447             return tryRecover(hash, v, r, s);
1448         } else if (signature.length == 64) {
1449             bytes32 r;
1450             bytes32 vs;
1451             // ecrecover takes the signature parameters, and the only way to get them
1452             // currently is to use assembly.
1453             assembly {
1454                 r := mload(add(signature, 0x20))
1455                 vs := mload(add(signature, 0x40))
1456             }
1457             return tryRecover(hash, r, vs);
1458         } else {
1459             return (address(0), RecoverError.InvalidSignatureLength);
1460         }
1461     }
1462 
1463     /**
1464      * @dev Returns the address that signed a hashed message (`hash`) with
1465      * `signature`. This address can then be used for verification purposes.
1466      *
1467      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1468      * this function rejects them by requiring the `s` value to be in the lower
1469      * half order, and the `v` value to be either 27 or 28.
1470      *
1471      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1472      * verification to be secure: it is possible to craft signatures that
1473      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1474      * this is by receiving a hash of the original message (which may otherwise
1475      * be too long), and then calling {toEthSignedMessageHash} on it.
1476      */
1477     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1478         (address recovered, RecoverError error) = tryRecover(hash, signature);
1479         _throwError(error);
1480         return recovered;
1481     }
1482 
1483     /**
1484      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1485      *
1486      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1487      *
1488      * _Available since v4.3._
1489      */
1490     function tryRecover(
1491         bytes32 hash,
1492         bytes32 r,
1493         bytes32 vs
1494     ) internal pure returns (address, RecoverError) {
1495         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1496         uint8 v = uint8((uint256(vs) >> 255) + 27);
1497         return tryRecover(hash, v, r, s);
1498     }
1499 
1500     /**
1501      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1502      *
1503      * _Available since v4.2._
1504      */
1505     function recover(
1506         bytes32 hash,
1507         bytes32 r,
1508         bytes32 vs
1509     ) internal pure returns (address) {
1510         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1511         _throwError(error);
1512         return recovered;
1513     }
1514 
1515     /**
1516      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1517      * `r` and `s` signature fields separately.
1518      *
1519      * _Available since v4.3._
1520      */
1521     function tryRecover(
1522         bytes32 hash,
1523         uint8 v,
1524         bytes32 r,
1525         bytes32 s
1526     ) internal pure returns (address, RecoverError) {
1527         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1528         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1529         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1530         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1531         //
1532         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1533         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1534         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1535         // these malleable signatures as well.
1536         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1537             return (address(0), RecoverError.InvalidSignatureS);
1538         }
1539         if (v != 27 && v != 28) {
1540             return (address(0), RecoverError.InvalidSignatureV);
1541         }
1542 
1543         // If the signature is valid (and not malleable), return the signer address
1544         address signer = ecrecover(hash, v, r, s);
1545         if (signer == address(0)) {
1546             return (address(0), RecoverError.InvalidSignature);
1547         }
1548 
1549         return (signer, RecoverError.NoError);
1550     }
1551 
1552     /**
1553      * @dev Overload of {ECDSA-recover} that receives the `v`,
1554      * `r` and `s` signature fields separately.
1555      */
1556     function recover(
1557         bytes32 hash,
1558         uint8 v,
1559         bytes32 r,
1560         bytes32 s
1561     ) internal pure returns (address) {
1562         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1563         _throwError(error);
1564         return recovered;
1565     }
1566 
1567     /**
1568      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1569      * produces hash corresponding to the one signed with the
1570      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1571      * JSON-RPC method as part of EIP-191.
1572      *
1573      * See {recover}.
1574      */
1575     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1576         // 32 is the length in bytes of hash,
1577         // enforced by the type signature above
1578         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1579     }
1580 
1581     /**
1582      * @dev Returns an Ethereum Signed Message, created from `s`. This
1583      * produces hash corresponding to the one signed with the
1584      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1585      * JSON-RPC method as part of EIP-191.
1586      *
1587      * See {recover}.
1588      */
1589     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1590         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1591     }
1592 
1593     /**
1594      * @dev Returns an Ethereum Signed Typed Data, created from a
1595      * `domainSeparator` and a `structHash`. This produces hash corresponding
1596      * to the one signed with the
1597      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1598      * JSON-RPC method as part of EIP-712.
1599      *
1600      * See {recover}.
1601      */
1602     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1603         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1604     }
1605 }
1606 
1607 // File: contracts\openzeppelin-contracts\contracts\utils\cryptography\draft-EIP712.sol
1608 
1609 
1610 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
1611 
1612 pragma solidity ^0.8.0;
1613 
1614 
1615 /**
1616  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1617  *
1618  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1619  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1620  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1621  *
1622  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1623  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1624  * ({_hashTypedDataV4}).
1625  *
1626  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1627  * the chain id to protect against replay attacks on an eventual fork of the chain.
1628  *
1629  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1630  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1631  *
1632  * _Available since v3.4._
1633  */
1634 abstract contract EIP712 {
1635     /* solhint-disable var-name-mixedcase */
1636     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1637     // invalidate the cached domain separator if the chain id changes.
1638     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1639     uint256 private immutable _CACHED_CHAIN_ID;
1640     address private immutable _CACHED_THIS;
1641 
1642     bytes32 private immutable _HASHED_NAME;
1643     bytes32 private immutable _HASHED_VERSION;
1644     bytes32 private immutable _TYPE_HASH;
1645 
1646     /* solhint-enable var-name-mixedcase */
1647 
1648     /**
1649      * @dev Initializes the domain separator and parameter caches.
1650      *
1651      * The meaning of `name` and `version` is specified in
1652      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1653      *
1654      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1655      * - `version`: the current major version of the signing domain.
1656      *
1657      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1658      * contract upgrade].
1659      */
1660     constructor(string memory name, string memory version) {
1661         bytes32 hashedName = keccak256(bytes(name));
1662         bytes32 hashedVersion = keccak256(bytes(version));
1663         bytes32 typeHash = keccak256(
1664             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1665         );
1666         _HASHED_NAME = hashedName;
1667         _HASHED_VERSION = hashedVersion;
1668         _CACHED_CHAIN_ID = block.chainid;
1669         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1670         _CACHED_THIS = address(this);
1671         _TYPE_HASH = typeHash;
1672     }
1673 
1674     /**
1675      * @dev Returns the domain separator for the current chain.
1676      */
1677     function _domainSeparatorV4() internal view returns (bytes32) {
1678         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1679             return _CACHED_DOMAIN_SEPARATOR;
1680         } else {
1681             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1682         }
1683     }
1684 
1685     function _buildDomainSeparator(
1686         bytes32 typeHash,
1687         bytes32 nameHash,
1688         bytes32 versionHash
1689     ) private view returns (bytes32) {
1690         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1691     }
1692 
1693     /**
1694      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1695      * function returns the hash of the fully encoded EIP712 message for this domain.
1696      *
1697      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1698      *
1699      * ```solidity
1700      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1701      *     keccak256("Mail(address to,string contents)"),
1702      *     mailTo,
1703      *     keccak256(bytes(mailContents))
1704      * )));
1705      * address signer = ECDSA.recover(digest, signature);
1706      * ```
1707      */
1708     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1709         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1710     }
1711 }
1712 
1713 // File: contracts\NFT.sol
1714 
1715 pragma solidity ^0.8.0;
1716 
1717 
1718 
1719 
1720 
1721 contract NFT is Ownable, ERC721Enumerable, ReentrancyGuard, EIP712("NFT", "1") {
1722     using Strings for uint256;
1723     
1724     uint256 public cap = 10000;
1725     uint256 public price = 4e16;
1726     uint256 public deltaPrice = 1e16;
1727     uint256 public batchNumber = 1000;
1728     string private _uri;
1729     mapping(uint256 => uint256) public avatarToToken;
1730     mapping(uint256 => uint256) public tokenToAvatar;
1731     address public operator;
1732     bytes32 public constant TYPEHASH = keccak256("Mint(uint256 avatarId)");
1733     
1734     constructor(string memory name, string memory symbol, string memory uri) ERC721(name, symbol){
1735         _uri = uri;
1736         operator = msg.sender;
1737     }
1738     
1739     function setOperator(address _operator) public onlyOwner {
1740         operator = _operator;
1741     }
1742     
1743     function domainSeparatorV4() view public returns (bytes32) {
1744         return _domainSeparatorV4();
1745     }
1746     
1747     function setURI(string memory uri) public onlyOwner {
1748         _uri = uri;
1749     }
1750     
1751     function _baseURI() internal view override returns (string memory) {
1752         return _uri;
1753     }
1754     
1755     function exists(uint256 tokenId) public view returns (bool) {
1756         return _exists(tokenId);
1757     }
1758     
1759     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1760         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1761         string memory baseURI = _baseURI();
1762         uint256 avatarId = tokenToAvatar[tokenId];
1763         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, avatarId.toString())) : "";
1764     }
1765     
1766     function mint(uint256 avatarId,uint8 v,bytes32 r,bytes32 s) payable public nonReentrant() {
1767         require(!Address.isContract(msg.sender), "NFT:not allowed for contract");
1768         require(msg.value == price, "NFT:invalid value");
1769         uint256 tokenId = totalSupply() + 1;
1770         require(avatarToToken[avatarId] == 0, "NFT:used avatarId");
1771         require(tokenId <= cap, "NFT:over than max supply");
1772         bytes32 structHash = keccak256(abi.encode(TYPEHASH, avatarId));
1773         bytes32 hash = _hashTypedDataV4(structHash);
1774         address signer = ECDSA.recover(hash, v, r, s);
1775         require(signer == operator, "NFT:invalid signer");
1776         _safeMint(msg.sender, tokenId);
1777         avatarToToken[avatarId] = tokenId;
1778         tokenToAvatar[tokenId] = avatarId;
1779         if(tokenId % batchNumber == 0){
1780             price += deltaPrice;
1781         }
1782     }
1783     
1784     function claim(address payable to) public onlyOwner{
1785         to.transfer(address(this).balance);
1786     }
1787 }