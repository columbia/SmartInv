1 // File: Bees/beeFlat.sol
2 
3 
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Context.sol
75 
76 
77 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Provides information about the current execution context, including the
83  * sender of the transaction and its data. While these are generally available
84  * via msg.sender and msg.data, they should not be accessed in such a direct
85  * manner, since when dealing with meta-transactions the account sending and
86  * paying for execution may not be the actual sender (as far as an application
87  * is concerned).
88  *
89  * This contract is only required for intermediate, library-like contracts.
90  */
91 abstract contract Context {
92     function _msgSender() internal view virtual returns (address) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view virtual returns (bytes calldata) {
97         return msg.data;
98     }
99 }
100 
101 // File: @openzeppelin/contracts/access/Ownable.sol
102 
103 
104 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 
109 /**
110  * @dev Contract module which provides a basic access control mechanism, where
111  * there is an account (an owner) that can be granted exclusive access to
112  * specific functions.
113  *
114  * By default, the owner account will be the one that deploys the contract. This
115  * can later be changed with {transferOwnership}.
116  *
117  * This module is used through inheritance. It will make available the modifier
118  * `onlyOwner`, which can be applied to your functions to restrict their use to
119  * the owner.
120  */
121 abstract contract Ownable is Context {
122     address private _owner;
123 
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126     /**
127      * @dev Initializes the contract setting the deployer as the initial owner.
128      */
129     constructor() {
130         _transferOwnership(_msgSender());
131     }
132 
133     /**
134      * @dev Returns the address of the current owner.
135      */
136     function owner() public view virtual returns (address) {
137         return _owner;
138     }
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         require(owner() == _msgSender(), "Ownable: caller is not the owner");
145         _;
146     }
147 
148     /**
149      * @dev Leaves the contract without owner. It will not be possible to call
150      * `onlyOwner` functions anymore. Can only be called by the current owner.
151      *
152      * NOTE: Renouncing ownership will leave the contract without an owner,
153      * thereby removing any functionality that is only available to the owner.
154      */
155     function renounceOwnership() public virtual onlyOwner {
156         _transferOwnership(address(0));
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      * Can only be called by the current owner.
162      */
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(newOwner != address(0), "Ownable: new owner is the zero address");
165         _transferOwnership(newOwner);
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Internal function without access restriction.
171      */
172     function _transferOwnership(address newOwner) internal virtual {
173         address oldOwner = _owner;
174         _owner = newOwner;
175         emit OwnershipTransferred(oldOwner, newOwner);
176     }
177 }
178 
179 // File: Bees/WithSuperOperators.sol
180 
181 
182    
183 //SPDX-License-Identifier: MIT
184 // solhint-disable-next-line compiler-version
185 pragma solidity ^0.8.0;
186 
187 
188 contract WithSuperOperators is Ownable {
189     mapping(address => bool) internal _superOperators;
190 
191     event SuperOperator(address superOperator, bool enabled);
192 
193     /// @notice Enable or disable the ability of `superOperator` to transfer tokens of all (superOperator rights).
194     /// @param superOperator address that will be given/removed superOperator right.
195     /// @param enabled set whether the superOperator is enabled or disabled.
196     function setSuperOperator(address superOperator, bool enabled) external onlyOwner {
197         _superOperators[superOperator] = enabled;
198         emit SuperOperator(superOperator, enabled);
199     }
200 
201     /// @notice check whether address `who` is given superOperator rights.
202     /// @param who The address to query.
203     /// @return whether the address has superOperator rights.
204     function isSuperOperator(address who) public view returns (bool) {
205         return _superOperators[who];
206     }
207 }
208 // File: @openzeppelin/contracts/utils/Address.sol
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @dev Collection of functions related to the address type
217  */
218 library Address {
219     /**
220      * @dev Returns true if `account` is a contract.
221      *
222      * [IMPORTANT]
223      * ====
224      * It is unsafe to assume that an address for which this function returns
225      * false is an externally-owned account (EOA) and not a contract.
226      *
227      * Among others, `isContract` will return false for the following
228      * types of addresses:
229      *
230      *  - an externally-owned account
231      *  - a contract in construction
232      *  - an address where a contract will be created
233      *  - an address where a contract lived, but was destroyed
234      * ====
235      */
236     function isContract(address account) internal view returns (bool) {
237         // This method relies on extcodesize, which returns 0 for contracts in
238         // construction, since the code is only stored at the end of the
239         // constructor execution.
240 
241         uint256 size;
242         assembly {
243             size := extcodesize(account)
244         }
245         return size > 0;
246     }
247 
248     /**
249      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
250      * `recipient`, forwarding all available gas and reverting on errors.
251      *
252      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
253      * of certain opcodes, possibly making contracts go over the 2300 gas limit
254      * imposed by `transfer`, making them unable to receive funds via
255      * `transfer`. {sendValue} removes this limitation.
256      *
257      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
258      *
259      * IMPORTANT: because control is transferred to `recipient`, care must be
260      * taken to not create reentrancy vulnerabilities. Consider using
261      * {ReentrancyGuard} or the
262      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
263      */
264     function sendValue(address payable recipient, uint256 amount) internal {
265         require(address(this).balance >= amount, "Address: insufficient balance");
266 
267         (bool success, ) = recipient.call{value: amount}("");
268         require(success, "Address: unable to send value, recipient may have reverted");
269     }
270 
271     /**
272      * @dev Performs a Solidity function call using a low level `call`. A
273      * plain `call` is an unsafe replacement for a function call: use this
274      * function instead.
275      *
276      * If `target` reverts with a revert reason, it is bubbled up by this
277      * function (like regular Solidity function calls).
278      *
279      * Returns the raw returned data. To convert to the expected return value,
280      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
281      *
282      * Requirements:
283      *
284      * - `target` must be a contract.
285      * - calling `target` with `data` must not revert.
286      *
287      * _Available since v3.1._
288      */
289     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
290         return functionCall(target, data, "Address: low-level call failed");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
295      * `errorMessage` as a fallback revert reason when `target` reverts.
296      *
297      * _Available since v3.1._
298      */
299     function functionCall(
300         address target,
301         bytes memory data,
302         string memory errorMessage
303     ) internal returns (bytes memory) {
304         return functionCallWithValue(target, data, 0, errorMessage);
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
309      * but also transferring `value` wei to `target`.
310      *
311      * Requirements:
312      *
313      * - the calling contract must have an ETH balance of at least `value`.
314      * - the called Solidity function must be `payable`.
315      *
316      * _Available since v3.1._
317      */
318     function functionCallWithValue(
319         address target,
320         bytes memory data,
321         uint256 value
322     ) internal returns (bytes memory) {
323         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
328      * with `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(
333         address target,
334         bytes memory data,
335         uint256 value,
336         string memory errorMessage
337     ) internal returns (bytes memory) {
338         require(address(this).balance >= value, "Address: insufficient balance for call");
339         require(isContract(target), "Address: call to non-contract");
340 
341         (bool success, bytes memory returndata) = target.call{value: value}(data);
342         return verifyCallResult(success, returndata, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but performing a static call.
348      *
349      * _Available since v3.3._
350      */
351     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
352         return functionStaticCall(target, data, "Address: low-level static call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
357      * but performing a static call.
358      *
359      * _Available since v3.3._
360      */
361     function functionStaticCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal view returns (bytes memory) {
366         require(isContract(target), "Address: static call to non-contract");
367 
368         (bool success, bytes memory returndata) = target.staticcall(data);
369         return verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but performing a delegate call.
375      *
376      * _Available since v3.4._
377      */
378     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
379         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
384      * but performing a delegate call.
385      *
386      * _Available since v3.4._
387      */
388     function functionDelegateCall(
389         address target,
390         bytes memory data,
391         string memory errorMessage
392     ) internal returns (bytes memory) {
393         require(isContract(target), "Address: delegate call to non-contract");
394 
395         (bool success, bytes memory returndata) = target.delegatecall(data);
396         return verifyCallResult(success, returndata, errorMessage);
397     }
398 
399     /**
400      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
401      * revert reason using the provided one.
402      *
403      * _Available since v4.3._
404      */
405     function verifyCallResult(
406         bool success,
407         bytes memory returndata,
408         string memory errorMessage
409     ) internal pure returns (bytes memory) {
410         if (success) {
411             return returndata;
412         } else {
413             // Look for revert reason and bubble it up if present
414             if (returndata.length > 0) {
415                 // The easiest way to bubble the revert reason is using memory via assembly
416 
417                 assembly {
418                     let returndata_size := mload(returndata)
419                     revert(add(32, returndata), returndata_size)
420                 }
421             } else {
422                 revert(errorMessage);
423             }
424         }
425     }
426 }
427 
428 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
429 
430 
431 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
432 
433 pragma solidity ^0.8.0;
434 
435 /**
436  * @title ERC721 token receiver interface
437  * @dev Interface for any contract that wants to support safeTransfers
438  * from ERC721 asset contracts.
439  */
440 interface IERC721Receiver {
441     /**
442      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
443      * by `operator` from `from`, this function is called.
444      *
445      * It must return its Solidity selector to confirm the token transfer.
446      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
447      *
448      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
449      */
450     function onERC721Received(
451         address operator,
452         address from,
453         uint256 tokenId,
454         bytes calldata data
455     ) external returns (bytes4);
456 }
457 
458 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
459 
460 
461 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @dev Interface of the ERC165 standard, as defined in the
467  * https://eips.ethereum.org/EIPS/eip-165[EIP].
468  *
469  * Implementers can declare support of contract interfaces, which can then be
470  * queried by others ({ERC165Checker}).
471  *
472  * For an implementation, see {ERC165}.
473  */
474 interface IERC165 {
475     /**
476      * @dev Returns true if this contract implements the interface defined by
477      * `interfaceId`. See the corresponding
478      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
479      * to learn more about how these ids are created.
480      *
481      * This function call must use less than 30 000 gas.
482      */
483     function supportsInterface(bytes4 interfaceId) external view returns (bool);
484 }
485 
486 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 
494 /**
495  * @dev Implementation of the {IERC165} interface.
496  *
497  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
498  * for the additional interface id that will be supported. For example:
499  *
500  * ```solidity
501  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
502  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
503  * }
504  * ```
505  *
506  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
507  */
508 abstract contract ERC165 is IERC165 {
509     /**
510      * @dev See {IERC165-supportsInterface}.
511      */
512     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
513         return interfaceId == type(IERC165).interfaceId;
514     }
515 }
516 
517 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
518 
519 
520 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 
525 /**
526  * @dev Required interface of an ERC721 compliant contract.
527  */
528 interface IERC721 is IERC165 {
529     /**
530      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
531      */
532     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
533 
534     /**
535      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
536      */
537     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
538 
539     /**
540      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
541      */
542     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
543 
544     /**
545      * @dev Returns the number of tokens in ``owner``'s account.
546      */
547     function balanceOf(address owner) external view returns (uint256 balance);
548 
549     /**
550      * @dev Returns the owner of the `tokenId` token.
551      *
552      * Requirements:
553      *
554      * - `tokenId` must exist.
555      */
556     function ownerOf(uint256 tokenId) external view returns (address owner);
557 
558     /**
559      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
560      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
561      *
562      * Requirements:
563      *
564      * - `from` cannot be the zero address.
565      * - `to` cannot be the zero address.
566      * - `tokenId` token must exist and be owned by `from`.
567      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
568      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
569      *
570      * Emits a {Transfer} event.
571      */
572     function safeTransferFrom(
573         address from,
574         address to,
575         uint256 tokenId
576     ) external;
577 
578     /**
579      * @dev Transfers `tokenId` token from `from` to `to`.
580      *
581      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
582      *
583      * Requirements:
584      *
585      * - `from` cannot be the zero address.
586      * - `to` cannot be the zero address.
587      * - `tokenId` token must be owned by `from`.
588      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
589      *
590      * Emits a {Transfer} event.
591      */
592     function transferFrom(
593         address from,
594         address to,
595         uint256 tokenId
596     ) external;
597 
598     /**
599      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
600      * The approval is cleared when the token is transferred.
601      *
602      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
603      *
604      * Requirements:
605      *
606      * - The caller must own the token or be an approved operator.
607      * - `tokenId` must exist.
608      *
609      * Emits an {Approval} event.
610      */
611     function approve(address to, uint256 tokenId) external;
612 
613     /**
614      * @dev Returns the account approved for `tokenId` token.
615      *
616      * Requirements:
617      *
618      * - `tokenId` must exist.
619      */
620     function getApproved(uint256 tokenId) external view returns (address operator);
621 
622     /**
623      * @dev Approve or remove `operator` as an operator for the caller.
624      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
625      *
626      * Requirements:
627      *
628      * - The `operator` cannot be the caller.
629      *
630      * Emits an {ApprovalForAll} event.
631      */
632     function setApprovalForAll(address operator, bool _approved) external;
633 
634     /**
635      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
636      *
637      * See {setApprovalForAll}
638      */
639     function isApprovedForAll(address owner, address operator) external view returns (bool);
640 
641     /**
642      * @dev Safely transfers `tokenId` token from `from` to `to`.
643      *
644      * Requirements:
645      *
646      * - `from` cannot be the zero address.
647      * - `to` cannot be the zero address.
648      * - `tokenId` token must exist and be owned by `from`.
649      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
650      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
651      *
652      * Emits a {Transfer} event.
653      */
654     function safeTransferFrom(
655         address from,
656         address to,
657         uint256 tokenId,
658         bytes calldata data
659     ) external;
660 }
661 
662 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
663 
664 
665 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
666 
667 pragma solidity ^0.8.0;
668 
669 
670 /**
671  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
672  * @dev See https://eips.ethereum.org/EIPS/eip-721
673  */
674 interface IERC721Enumerable is IERC721 {
675     /**
676      * @dev Returns the total amount of tokens stored by the contract.
677      */
678     function totalSupply() external view returns (uint256);
679 
680     /**
681      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
682      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
683      */
684     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
685 
686     /**
687      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
688      * Use along with {totalSupply} to enumerate all tokens.
689      */
690     function tokenByIndex(uint256 index) external view returns (uint256);
691 }
692 
693 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
694 
695 
696 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 
701 /**
702  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
703  * @dev See https://eips.ethereum.org/EIPS/eip-721
704  */
705 interface IERC721Metadata is IERC721 {
706     /**
707      * @dev Returns the token collection name.
708      */
709     function name() external view returns (string memory);
710 
711     /**
712      * @dev Returns the token collection symbol.
713      */
714     function symbol() external view returns (string memory);
715 
716     /**
717      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
718      */
719     function tokenURI(uint256 tokenId) external view returns (string memory);
720 }
721 
722 // File: Bees/ERC721C_2.sol
723 
724 
725 
726 pragma solidity ^0.8.0;
727 
728 
729 
730 
731 
732 
733 
734 
735 
736 abstract contract ERC721C is Context, ERC165, IERC721, IERC721Metadata, WithSuperOperators {
737     using Address for address;
738     using Strings for uint256;
739 
740     // Token name
741     string private _name;
742 
743     // Token symbol
744     string private _symbol;
745 
746     //uint256 internal _supply;
747 
748     uint256[] internal _tokenIds;
749 
750     // Mapping from token ID to owner address
751     mapping(uint256 => address) internal _owners;
752 
753     // Mapping owner address to token count
754     mapping(address => uint256) private _balances;
755 
756     // Mapping from token ID to approved address
757     mapping(uint256 => address) private _tokenApprovals;
758 
759     // Mapping from owner to operator approvals
760     mapping(address => mapping(address => bool)) private _operatorApprovals;
761 
762     /**
763      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
764      */
765     constructor(string memory name_, string memory symbol_) {
766         _name = name_;
767         _symbol = symbol_;
768     }
769 
770     /**
771      * @dev See {IERC165-supportsInterface}.
772      */
773     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
774         return
775             interfaceId == type(IERC721).interfaceId ||
776             interfaceId == type(IERC721Metadata).interfaceId ||
777             super.supportsInterface(interfaceId);
778     }
779 
780     /**
781      * @dev See {IERC721-balanceOf}.
782      */
783     function balanceOf(address owner) public view virtual override returns (uint256) {
784         require(owner != address(0), "ERC721: balance query for the zero address");
785 
786         return _balances[owner];
787     }
788 
789     /**
790      * @dev See {IERC721-ownerOf}.
791      */
792     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
793         address owner = _owners[tokenId];
794         require(owner != address(0), "ERC721: owner query for nonexistent token");
795         return owner;
796     }
797 
798     /**
799      * @dev See {IERC721Metadata-name}.
800      */
801     function name() public view virtual override returns (string memory) {
802         return _name;
803     }
804 
805     /**
806      * @dev See {IERC721Metadata-symbol}.
807      */
808     function symbol() public view virtual override returns (string memory) {
809         return _symbol;
810     }
811     /**
812      * @dev See {IERC721Metadata-tokenURI}.
813      */
814     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
815         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
816 
817         string memory baseURI = _baseURI();
818         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
819     }
820 
821     /**
822      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
823      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
824      * by default, can be overriden in child contracts.
825      */
826     function _baseURI() internal view virtual returns (string memory) {
827         return "";
828     }
829     /**
830      * @dev See {IERC721-approve}.
831      */
832     function approve(address to, uint256 tokenId) public virtual override {
833         address owner = ERC721C.ownerOf(tokenId);
834         require(to != owner, "ERC721: approval to current owner");
835 
836         require(
837             _msgSender() == owner || _superOperators[_msgSender()] || isApprovedForAll(owner, _msgSender()),
838             "ERC721: approve caller is not owner nor approved for all"
839         );
840 
841         _approve(to, tokenId);
842     }
843 
844     /**
845      * @dev See {IERC721-getApproved}.
846      */
847     function getApproved(uint256 tokenId) public view virtual override returns (address) {
848         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
849 
850         return _tokenApprovals[tokenId];
851     }
852 
853     /**
854      * @dev See {IERC721-setApprovalForAll}.
855      */
856     function setApprovalForAll(address operator, bool approved) public virtual override {
857         require(operator != _msgSender(), "ERC721: approve to caller");
858 
859         _operatorApprovals[_msgSender()][operator] = approved;
860         emit ApprovalForAll(_msgSender(), operator, approved);
861     }
862 
863     /**
864      * @dev See {IERC721-isApprovedForAll}.
865      */
866     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
867         return _operatorApprovals[owner][operator];
868     }
869 
870 
871     /**
872      * @dev See {IERC721-transferFrom}.
873      */
874     function transferFrom(
875         address from,
876         address to,
877         uint256 tokenId
878     ) public virtual override {
879         //solhint-disable-next-line max-line-length
880         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
881 
882         _transfer(from, to, tokenId);
883     }
884 
885     /**
886      * @dev See {IERC721-safeTransferFrom}.
887      */
888     function safeTransferFrom(
889         address from,
890         address to,
891         uint256 tokenId
892     ) public virtual override {
893         safeTransferFrom(from, to, tokenId, "");
894     }
895 
896     /**
897      * @dev See {IERC721-safeTransferFrom}.
898      */
899     function safeTransferFrom(
900         address from,
901         address to,
902         uint256 tokenId,
903         bytes memory _data
904     ) public virtual override {
905         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
906         _safeTransfer(from, to, tokenId, _data);
907     }
908 
909     /**
910      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
911      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
912      *
913      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
914      *
915      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
916      * implement alternative mechanisms to perform token transfer, such as signature-based.
917      *
918      * Requirements:
919      *
920      * - `from` cannot be the zero address.
921      * - `to` cannot be the zero address.
922      * - `tokenId` token must exist and be owned by `from`.
923      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _safeTransfer(
928         address from,
929         address to,
930         uint256 tokenId,
931         bytes memory _data
932     ) internal virtual {
933         _transfer(from, to, tokenId);
934         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
935     }
936 
937     /**
938      * @dev Returns whether `tokenId` exists.
939      *
940      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
941      *
942      * Tokens start existing when they are minted (`_mint`),
943      * and stop existing when they are burned (`_burn`).
944      */
945     function _exists(uint256 tokenId) internal view virtual returns (bool) {
946         return _owners[tokenId] != address(0);
947     }
948 
949     /**
950      * @dev Returns whether `spender` is allowed to manage `tokenId`.
951      *
952      * Requirements:
953      *
954      * - `tokenId` must exist.
955      */
956     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
957         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
958         address owner = ERC721C.ownerOf(tokenId);
959         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender) || _superOperators[_msgSender()]);
960     }
961 
962     /**
963      * @dev Safely mints `tokenId` and transfers it to `to`.
964      *
965      * Requirements:
966      *
967      * - `tokenId` must not exist.
968      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
969      *
970      * Emits a {Transfer} event.
971      */
972     function _safeMint(address to, uint256 tokenId) internal virtual {
973         _safeMint(to, tokenId, "");
974     }
975 
976 
977     /**
978      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
979      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
980      */
981     function _safeMint(
982         address to,
983         uint256 tokenId,
984         bytes memory _data
985     ) internal virtual {
986         _mint(to, tokenId);
987         require(
988             _checkOnERC721Received(address(0), to, tokenId, _data),
989             "ERC721: transfer to non ERC721Receiver implementer"
990         );
991     }
992 
993     /**
994      * @dev Mints `tokenId` and transfers it to `to`.
995      *
996      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
997      *
998      * Requirements:
999      *
1000      * - `tokenId` must not exist.
1001      * - `to` cannot be the zero address.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _mint(address to, uint256 tokenId) internal virtual {
1006         require(to != address(0), "ERC721: mint to the zero address");
1007         require(!_exists(tokenId), "ERC721: token already minted");
1008 
1009         _beforeTokenTransfer(address(0), to, tokenId);
1010         _balances[to] += 1;
1011         //_supply += 1;
1012         _tokenIds.push(tokenId);
1013         _owners[tokenId] = to;
1014 
1015         emit Transfer(address(0), to, tokenId);
1016     }
1017 
1018     /**
1019      * @dev Destroys `tokenId`.
1020      * The approval is cleared when the token is burned.
1021      *
1022      * Requirements:
1023      *
1024      * - `tokenId` must exist.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _burn(uint256 tokenId) internal virtual {
1029         address owner = ERC721C.ownerOf(tokenId);
1030 
1031         _beforeTokenTransfer(owner, address(0), tokenId);
1032 
1033         // Clear approvals
1034         _approve(address(0), tokenId);
1035         _owners[tokenId] = address(0);
1036 
1037         emit Transfer(owner, address(0), tokenId);
1038     }
1039 
1040     /**
1041      * @dev Transfers `tokenId` from `from` to `to`.
1042      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1043      *
1044      * Requirements:
1045      *
1046      * - `to` cannot be the zero address.
1047      * - `tokenId` token must be owned by `from`.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _transfer(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) internal virtual {
1056         require(ERC721C.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1057         require(to != address(0), "ERC721: transfer to the zero address");
1058 
1059         _beforeTokenTransfer(from, to, tokenId);
1060 
1061         // Clear approvals from the previous owner
1062         _approve(address(0), tokenId);
1063         _balances[from] -= 1;
1064         _balances[to] += 1;
1065         _owners[tokenId] = to;
1066 
1067         emit Transfer(from, to, tokenId);
1068     }
1069 
1070     /**
1071      * @dev Approve `to` to operate on `tokenId`
1072      *
1073      * Emits a {Approval} event.
1074      */
1075     function _approve(address to, uint256 tokenId) internal virtual {
1076         _tokenApprovals[tokenId] = to;
1077         emit Approval(ERC721C.ownerOf(tokenId), to, tokenId);
1078     }
1079 
1080 
1081     /**
1082      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1083      * The call is not executed if the target address is not a contract.
1084      *
1085      * @param from address representing the previous owner of the given token ID
1086      * @param to target address that will receive the tokens
1087      * @param tokenId uint256 ID of the token to be transferred
1088      * @param _data bytes optional data to send along with the call
1089      * @return bool whether the call correctly returned the expected magic value
1090      */
1091     function _checkOnERC721Received(
1092         address from,
1093         address to,
1094         uint256 tokenId,
1095         bytes memory _data
1096     ) private returns (bool) {
1097         if (to.isContract()) {
1098             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1099                 return retval == IERC721Receiver.onERC721Received.selector;
1100             } catch (bytes memory reason) {
1101                 if (reason.length == 0) {
1102                     revert("ERC721: transfer to non ERC721Receiver implementer");
1103                 } else {
1104                     assembly {
1105                         revert(add(32, reason), mload(reason))
1106                     }
1107                 }
1108             }
1109         } else {
1110             return true;
1111         }
1112     }
1113 
1114     /**
1115      * @dev Hook that is called before any token transfer. This includes minting
1116      * and burning.
1117      *
1118      * Calling conditions:
1119      *
1120      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1121      * transferred to `to`.
1122      * - When `from` is zero, `tokenId` will be minted for `to`.
1123      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1124      * - `from` and `to` are never both zero.
1125      *
1126      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1127      */
1128     function _beforeTokenTransfer(
1129         address from,
1130         address to,
1131         uint256 tokenId
1132     ) internal virtual {}
1133 }
1134 // File: Bees/ERC721EnumLiteC.sol
1135 
1136 
1137 
1138 pragma solidity ^0.8.0;
1139 
1140 
1141 
1142 /**
1143  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1144  * enumerability of all the token ids in the contract as well as all token ids owned by each
1145  * account.
1146  */
1147 abstract contract ERC721EnumerableLiteC is ERC721C, IERC721Enumerable {
1148     /**
1149      * @dev See {IERC165-supportsInterface}.
1150      */
1151     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721C) returns (bool) {
1152         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1153     }
1154 
1155     /**
1156      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1157      */
1158     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
1159         require(index < ERC721C.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1160 
1161         uint count;
1162         for( uint i; i < _tokenIds.length; ++i ){
1163             if( owner == _owners[_tokenIds[i]] ){
1164                 if( count == index )
1165                     return _tokenIds[i];
1166                 else
1167                     ++count;
1168             }
1169         }
1170 
1171         require(false, "ERC721Enumerable: owner index out of bounds");
1172     }
1173 
1174     /**
1175      * @dev See {IERC721Enumerable-totalSupply}.
1176      */
1177     function totalSupply() public view virtual override returns (uint256) {
1178         return _tokenIds.length;
1179     }
1180 
1181     /**
1182      * @dev See {IERC721Enumerable-tokenByIndex}.
1183      */
1184     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1185         require(index < ERC721EnumerableLiteC.totalSupply(), "ERC721Enumerable: global index out of bounds");
1186         return index;
1187     }
1188 }
1189 // File: Bees/BeeNFT.sol
1190 
1191 
1192 
1193 
1194 pragma solidity >=0.7.0 <0.9.0;
1195 
1196 
1197 
1198 
1199 contract BeeNFT is Ownable, ERC721EnumerableLiteC {
1200 
1201     using Strings for uint256;
1202 
1203     string private baseTokenURI = "https:///";
1204 
1205     mapping(address => bool) public enabledMinter;  
1206 
1207     uint256 public maxSupply =  13838;  
1208     bool public paused = false;
1209 
1210     mapping(uint256 => uint256) public QueenRegistry; //ID to Int Status
1211     mapping(uint256 => uint256) public miscSetting;
1212 
1213 
1214     constructor(
1215         string memory _name,
1216         string memory _symbol,
1217         string memory _initBaseURI
1218     ) ERC721C(_name, _symbol){
1219         setBaseURI(_initBaseURI);
1220     }
1221 
1222     // public
1223     function mint(address _to, uint256 _mintNumber) public {
1224         require(enabledMinter[msg.sender] , "!minter");
1225         uint256 supply = totalSupply();
1226         require(!paused, "paused" );
1227         require(supply + 1 <= maxSupply, "OverMaxSupply" );
1228 
1229         _safeMint(_to, _mintNumber, "");
1230     }
1231 
1232     // function gift(uint[] calldata quantity, address[] calldata recipient) external onlyOwner{
1233     //     require(quantity.length == recipient.length, "Must provide equal quantities and recipients" );
1234     //     uint totalQuantity = 0;
1235     //     uint256 supply = totalSupply();
1236     //     for(uint i = 0; i < quantity.length; ++i){
1237     //       totalQuantity += quantity[i];
1238     //     }
1239     //     require( supply + totalQuantity <= maxSupply, "Mint/order exceeds supply" );
1240     //     delete totalQuantity;
1241 
1242     //     for(uint i = 0; i < recipient.length; ++i){
1243     //       for(uint j = 0; j < quantity[i]; ++j){
1244     //           _safeMint( recipient[i], supply++, "" );
1245     //       } 
1246     //     }
1247     // }
1248 
1249     function _baseURI() internal view virtual override returns (string memory) {
1250       return baseTokenURI;
1251     }
1252     function setBaseURI(string memory _value) public onlyOwner{
1253       baseTokenURI = _value;
1254     }
1255         
1256     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1257       maxSupply = _maxSupply;
1258     }
1259 
1260     function setMinter(address _minter, bool _option) public onlyOwner {
1261       enabledMinter[_minter] = _option;
1262     }
1263     function setMisc(uint256[] calldata  _ids, uint256[] calldata  _values) public onlyOwner {
1264       require(_ids.length == _values.length, "Must provide equal ids and values" );
1265       for(uint256 i = 0; i < _ids.length; i++){
1266         miscSetting[_ids[i]] = _values[i];
1267       }
1268     }
1269     function setQueenRegistry(uint256[] calldata  _ids, uint256[] calldata  _values) public onlyOwner {
1270       require(_ids.length == _values.length, "Must provide equal ids and values" );
1271       for(uint256 i = 0; i < _ids.length; i++){
1272         QueenRegistry[_ids[i]] = _values[i];
1273       }
1274     }
1275     function pause(bool _state) public onlyOwner {
1276       paused = _state;
1277     }
1278 }