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
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      */
99     function isContract(address account) internal view returns (bool) {
100         // This method relies on extcodesize, which returns 0 for contracts in
101         // construction, since the code is only stored at the end of the
102         // constructor execution.
103 
104         uint256 size;
105         assembly {
106             size := extcodesize(account)
107         }
108         return size > 0;
109     }
110 
111     /**
112      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
113      * `recipient`, forwarding all available gas and reverting on errors.
114      *
115      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
116      * of certain opcodes, possibly making contracts go over the 2300 gas limit
117      * imposed by `transfer`, making them unable to receive funds via
118      * `transfer`. {sendValue} removes this limitation.
119      *
120      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
121      *
122      * IMPORTANT: because control is transferred to `recipient`, care must be
123      * taken to not create reentrancy vulnerabilities. Consider using
124      * {ReentrancyGuard} or the
125      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
126      */
127     function sendValue(address payable recipient, uint256 amount) internal {
128         require(address(this).balance >= amount, "Address: insufficient balance");
129 
130         (bool success, ) = recipient.call{value: amount}("");
131         require(success, "Address: unable to send value, recipient may have reverted");
132     }
133 
134     /**
135      * @dev Performs a Solidity function call using a low level `call`. A
136      * plain `call` is an unsafe replacement for a function call: use this
137      * function instead.
138      *
139      * If `target` reverts with a revert reason, it is bubbled up by this
140      * function (like regular Solidity function calls).
141      *
142      * Returns the raw returned data. To convert to the expected return value,
143      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
144      *
145      * Requirements:
146      *
147      * - `target` must be a contract.
148      * - calling `target` with `data` must not revert.
149      *
150      * _Available since v3.1._
151      */
152     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
153         return functionCall(target, data, "Address: low-level call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
158      * `errorMessage` as a fallback revert reason when `target` reverts.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal returns (bytes memory) {
167         return functionCallWithValue(target, data, 0, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but also transferring `value` wei to `target`.
173      *
174      * Requirements:
175      *
176      * - the calling contract must have an ETH balance of at least `value`.
177      * - the called Solidity function must be `payable`.
178      *
179      * _Available since v3.1._
180      */
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value
185     ) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
191      * with `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         require(address(this).balance >= value, "Address: insufficient balance for call");
202         require(isContract(target), "Address: call to non-contract");
203 
204         (bool success, bytes memory returndata) = target.call{value: value}(data);
205         return verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
210      * but performing a static call.
211      *
212      * _Available since v3.3._
213      */
214     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
215         return functionStaticCall(target, data, "Address: low-level static call failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
220      * but performing a static call.
221      *
222      * _Available since v3.3._
223      */
224     function functionStaticCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal view returns (bytes memory) {
229         require(isContract(target), "Address: static call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.staticcall(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a delegate call.
238      *
239      * _Available since v3.4._
240      */
241     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
242         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a delegate call.
248      *
249      * _Available since v3.4._
250      */
251     function functionDelegateCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal returns (bytes memory) {
256         require(isContract(target), "Address: delegate call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.delegatecall(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
264      * revert reason using the provided one.
265      *
266      * _Available since v4.3._
267      */
268     function verifyCallResult(
269         bool success,
270         bytes memory returndata,
271         string memory errorMessage
272     ) internal pure returns (bytes memory) {
273         if (success) {
274             return returndata;
275         } else {
276             // Look for revert reason and bubble it up if present
277             if (returndata.length > 0) {
278                 // The easiest way to bubble the revert reason is using memory via assembly
279 
280                 assembly {
281                     let returndata_size := mload(returndata)
282                     revert(add(32, returndata), returndata_size)
283                 }
284             } else {
285                 revert(errorMessage);
286             }
287         }
288     }
289 }
290 
291 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
292 
293 
294 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
295 
296 pragma solidity ^0.8.0;
297 
298 /**
299  * @title ERC721 token receiver interface
300  * @dev Interface for any contract that wants to support safeTransfers
301  * from ERC721 asset contracts.
302  */
303 interface IERC721Receiver {
304     /**
305      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
306      * by `operator` from `from`, this function is called.
307      *
308      * It must return its Solidity selector to confirm the token transfer.
309      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
310      *
311      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
312      */
313     function onERC721Received(
314         address operator,
315         address from,
316         uint256 tokenId,
317         bytes calldata data
318     ) external returns (bytes4);
319 }
320 
321 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
322 
323 
324 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
325 
326 pragma solidity ^0.8.0;
327 
328 /**
329  * @dev Interface of the ERC165 standard, as defined in the
330  * https://eips.ethereum.org/EIPS/eip-165[EIP].
331  *
332  * Implementers can declare support of contract interfaces, which can then be
333  * queried by others ({ERC165Checker}).
334  *
335  * For an implementation, see {ERC165}.
336  */
337 interface IERC165 {
338     /**
339      * @dev Returns true if this contract implements the interface defined by
340      * `interfaceId`. See the corresponding
341      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
342      * to learn more about how these ids are created.
343      *
344      * This function call must use less than 30 000 gas.
345      */
346     function supportsInterface(bytes4 interfaceId) external view returns (bool);
347 }
348 
349 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
350 
351 
352 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @dev Implementation of the {IERC165} interface.
359  *
360  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
361  * for the additional interface id that will be supported. For example:
362  *
363  * ```solidity
364  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
365  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
366  * }
367  * ```
368  *
369  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
370  */
371 abstract contract ERC165 is IERC165 {
372     /**
373      * @dev See {IERC165-supportsInterface}.
374      */
375     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
376         return interfaceId == type(IERC165).interfaceId;
377     }
378 }
379 
380 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
381 
382 
383 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 
388 /**
389  * @dev Required interface of an ERC721 compliant contract.
390  */
391 interface IERC721 is IERC165 {
392     /**
393      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
394      */
395     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
396 
397     /**
398      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
399      */
400     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
404      */
405     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
406 
407     /**
408      * @dev Returns the number of tokens in ``owner``'s account.
409      */
410     function balanceOf(address owner) external view returns (uint256 balance);
411 
412     /**
413      * @dev Returns the owner of the `tokenId` token.
414      *
415      * Requirements:
416      *
417      * - `tokenId` must exist.
418      */
419     function ownerOf(uint256 tokenId) external view returns (address owner);
420 
421     /**
422      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
423      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must exist and be owned by `from`.
430      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
431      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
432      *
433      * Emits a {Transfer} event.
434      */
435     function safeTransferFrom(
436         address from,
437         address to,
438         uint256 tokenId
439     ) external;
440 
441     /**
442      * @dev Transfers `tokenId` token from `from` to `to`.
443      *
444      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
445      *
446      * Requirements:
447      *
448      * - `from` cannot be the zero address.
449      * - `to` cannot be the zero address.
450      * - `tokenId` token must be owned by `from`.
451      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
452      *
453      * Emits a {Transfer} event.
454      */
455     function transferFrom(
456         address from,
457         address to,
458         uint256 tokenId
459     ) external;
460 
461     /**
462      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
463      * The approval is cleared when the token is transferred.
464      *
465      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
466      *
467      * Requirements:
468      *
469      * - The caller must own the token or be an approved operator.
470      * - `tokenId` must exist.
471      *
472      * Emits an {Approval} event.
473      */
474     function approve(address to, uint256 tokenId) external;
475 
476     /**
477      * @dev Returns the account approved for `tokenId` token.
478      *
479      * Requirements:
480      *
481      * - `tokenId` must exist.
482      */
483     function getApproved(uint256 tokenId) external view returns (address operator);
484 
485     /**
486      * @dev Approve or remove `operator` as an operator for the caller.
487      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
488      *
489      * Requirements:
490      *
491      * - The `operator` cannot be the caller.
492      *
493      * Emits an {ApprovalForAll} event.
494      */
495     function setApprovalForAll(address operator, bool _approved) external;
496 
497     /**
498      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
499      *
500      * See {setApprovalForAll}
501      */
502     function isApprovedForAll(address owner, address operator) external view returns (bool);
503 
504     /**
505      * @dev Safely transfers `tokenId` token from `from` to `to`.
506      *
507      * Requirements:
508      *
509      * - `from` cannot be the zero address.
510      * - `to` cannot be the zero address.
511      * - `tokenId` token must exist and be owned by `from`.
512      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
513      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
514      *
515      * Emits a {Transfer} event.
516      */
517     function safeTransferFrom(
518         address from,
519         address to,
520         uint256 tokenId,
521         bytes calldata data
522     ) external;
523 }
524 
525 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 
533 /**
534  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
535  * @dev See https://eips.ethereum.org/EIPS/eip-721
536  */
537 interface IERC721Enumerable is IERC721 {
538     /**
539      * @dev Returns the total amount of tokens stored by the contract.
540      */
541     function totalSupply() external view returns (uint256);
542 
543     /**
544      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
545      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
546      */
547     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
548 
549     /**
550      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
551      * Use along with {totalSupply} to enumerate all tokens.
552      */
553     function tokenByIndex(uint256 index) external view returns (uint256);
554 }
555 
556 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
557 
558 
559 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 
564 /**
565  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
566  * @dev See https://eips.ethereum.org/EIPS/eip-721
567  */
568 interface IERC721Metadata is IERC721 {
569     /**
570      * @dev Returns the token collection name.
571      */
572     function name() external view returns (string memory);
573 
574     /**
575      * @dev Returns the token collection symbol.
576      */
577     function symbol() external view returns (string memory);
578 
579     /**
580      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
581      */
582     function tokenURI(uint256 tokenId) external view returns (string memory);
583 }
584 
585 // File: @openzeppelin/contracts/utils/Context.sol
586 
587 
588 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
589 
590 pragma solidity ^0.8.0;
591 
592 /**
593  * @dev Provides information about the current execution context, including the
594  * sender of the transaction and its data. While these are generally available
595  * via msg.sender and msg.data, they should not be accessed in such a direct
596  * manner, since when dealing with meta-transactions the account sending and
597  * paying for execution may not be the actual sender (as far as an application
598  * is concerned).
599  *
600  * This contract is only required for intermediate, library-like contracts.
601  */
602 abstract contract Context {
603     function _msgSender() internal view virtual returns (address) {
604         return msg.sender;
605     }
606 
607     function _msgData() internal view virtual returns (bytes calldata) {
608         return msg.data;
609     }
610 }
611 
612 // File: @openzeppelin/contracts/access/Ownable.sol
613 
614 
615 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
616 
617 pragma solidity ^0.8.0;
618 
619 
620 /**
621  * @dev Contract module which provides a basic access control mechanism, where
622  * there is an account (an owner) that can be granted exclusive access to
623  * specific functions.
624  *
625  * By default, the owner account will be the one that deploys the contract. This
626  * can later be changed with {transferOwnership}.
627  *
628  * This module is used through inheritance. It will make available the modifier
629  * `onlyOwner`, which can be applied to your functions to restrict their use to
630  * the owner.
631  */
632 abstract contract Ownable is Context {
633     address private _owner;
634 
635     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
636 
637     /**
638      * @dev Initializes the contract setting the deployer as the initial owner.
639      */
640     constructor() {
641         _transferOwnership(_msgSender());
642     }
643 
644     /**
645      * @dev Returns the address of the current owner.
646      */
647     function owner() public view virtual returns (address) {
648         return _owner;
649     }
650 
651     /**
652      * @dev Throws if called by any account other than the owner.
653      */
654     modifier onlyOwner() {
655         require(owner() == _msgSender(), "Ownable: caller is not the owner");
656         _;
657     }
658 
659     /**
660      * @dev Leaves the contract without owner. It will not be possible to call
661      * `onlyOwner` functions anymore. Can only be called by the current owner.
662      *
663      * NOTE: Renouncing ownership will leave the contract without an owner,
664      * thereby removing any functionality that is only available to the owner.
665      */
666     function renounceOwnership() public virtual onlyOwner {
667         _transferOwnership(address(0));
668     }
669 
670     /**
671      * @dev Transfers ownership of the contract to a new account (`newOwner`).
672      * Can only be called by the current owner.
673      */
674     function transferOwnership(address newOwner) public virtual onlyOwner {
675         require(newOwner != address(0), "Ownable: new owner is the zero address");
676         _transferOwnership(newOwner);
677     }
678 
679     /**
680      * @dev Transfers ownership of the contract to a new account (`newOwner`).
681      * Internal function without access restriction.
682      */
683     function _transferOwnership(address newOwner) internal virtual {
684         address oldOwner = _owner;
685         _owner = newOwner;
686         emit OwnershipTransferred(oldOwner, newOwner);
687     }
688 }
689 
690 // File: Bees/WithSuperOperators.sol
691 
692 
693    
694 //SPDX-License-Identifier: MIT
695 // solhint-disable-next-line compiler-version
696 pragma solidity ^0.8.0;
697 
698 
699 contract WithSuperOperators is Ownable {
700     mapping(address => bool) internal _superOperators;
701 
702     event SuperOperator(address superOperator, bool enabled);
703 
704     /// @notice Enable or disable the ability of `superOperator` to transfer tokens of all (superOperator rights).
705     /// @param superOperator address that will be given/removed superOperator right.
706     /// @param enabled set whether the superOperator is enabled or disabled.
707     function setSuperOperator(address superOperator, bool enabled) external onlyOwner {
708         _superOperators[superOperator] = enabled;
709         emit SuperOperator(superOperator, enabled);
710     }
711 
712     /// @notice check whether address `who` is given superOperator rights.
713     /// @param who The address to query.
714     /// @return whether the address has superOperator rights.
715     function isSuperOperator(address who) public view returns (bool) {
716         return _superOperators[who];
717     }
718 }
719 // File: Bees/ERC721C_2.sol
720 
721 
722 
723 pragma solidity ^0.8.0;
724 
725 
726 
727 
728 
729 
730 
731 
732 
733 abstract contract ERC721C is Context, ERC165, IERC721, IERC721Metadata, WithSuperOperators {
734     using Address for address;
735     using Strings for uint256;
736 
737     // Token name
738     string private _name;
739 
740     // Token symbol
741     string private _symbol;
742 
743     //uint256 internal _supply;
744 
745     uint256[] internal _tokenIds;
746 
747     // Mapping from token ID to owner address
748     mapping(uint256 => address) internal _owners;
749 
750     // Mapping owner address to token count
751     mapping(address => uint256) private _balances;
752 
753     // Mapping from token ID to approved address
754     mapping(uint256 => address) private _tokenApprovals;
755 
756     // Mapping from owner to operator approvals
757     mapping(address => mapping(address => bool)) private _operatorApprovals;
758 
759     /**
760      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
761      */
762     constructor(string memory name_, string memory symbol_) {
763         _name = name_;
764         _symbol = symbol_;
765     }
766 
767     /**
768      * @dev See {IERC165-supportsInterface}.
769      */
770     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
771         return
772             interfaceId == type(IERC721).interfaceId ||
773             interfaceId == type(IERC721Metadata).interfaceId ||
774             super.supportsInterface(interfaceId);
775     }
776 
777     /**
778      * @dev See {IERC721-balanceOf}.
779      */
780     function balanceOf(address owner) public view virtual override returns (uint256) {
781         require(owner != address(0), "ERC721: balance query for the zero address");
782 
783         return _balances[owner];
784     }
785 
786     /**
787      * @dev See {IERC721-ownerOf}.
788      */
789     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
790         address owner = _owners[tokenId];
791         require(owner != address(0), "ERC721: owner query for nonexistent token");
792         return owner;
793     }
794 
795     /**
796      * @dev See {IERC721Metadata-name}.
797      */
798     function name() public view virtual override returns (string memory) {
799         return _name;
800     }
801 
802     /**
803      * @dev See {IERC721Metadata-symbol}.
804      */
805     function symbol() public view virtual override returns (string memory) {
806         return _symbol;
807     }
808     /**
809      * @dev See {IERC721Metadata-tokenURI}.
810      */
811     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
812         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
813 
814         string memory baseURI = _baseURI();
815         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
816     }
817 
818     /**
819      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
820      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
821      * by default, can be overriden in child contracts.
822      */
823     function _baseURI() internal view virtual returns (string memory) {
824         return "";
825     }
826     /**
827      * @dev See {IERC721-approve}.
828      */
829     function approve(address to, uint256 tokenId) public virtual override {
830         address owner = ERC721C.ownerOf(tokenId);
831         require(to != owner, "ERC721: approval to current owner");
832 
833         require(
834             _msgSender() == owner || _superOperators[_msgSender()] || isApprovedForAll(owner, _msgSender()),
835             "ERC721: approve caller is not owner nor approved for all"
836         );
837 
838         _approve(to, tokenId);
839     }
840 
841     /**
842      * @dev See {IERC721-getApproved}.
843      */
844     function getApproved(uint256 tokenId) public view virtual override returns (address) {
845         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
846 
847         return _tokenApprovals[tokenId];
848     }
849 
850     /**
851      * @dev See {IERC721-setApprovalForAll}.
852      */
853     function setApprovalForAll(address operator, bool approved) public virtual override {
854         require(operator != _msgSender(), "ERC721: approve to caller");
855 
856         _operatorApprovals[_msgSender()][operator] = approved;
857         emit ApprovalForAll(_msgSender(), operator, approved);
858     }
859 
860     /**
861      * @dev See {IERC721-isApprovedForAll}.
862      */
863     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
864         return _operatorApprovals[owner][operator];
865     }
866 
867 
868     /**
869      * @dev See {IERC721-transferFrom}.
870      */
871     function transferFrom(
872         address from,
873         address to,
874         uint256 tokenId
875     ) public virtual override {
876         //solhint-disable-next-line max-line-length
877         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
878 
879         _transfer(from, to, tokenId);
880     }
881 
882     /**
883      * @dev See {IERC721-safeTransferFrom}.
884      */
885     function safeTransferFrom(
886         address from,
887         address to,
888         uint256 tokenId
889     ) public virtual override {
890         safeTransferFrom(from, to, tokenId, "");
891     }
892 
893     /**
894      * @dev See {IERC721-safeTransferFrom}.
895      */
896     function safeTransferFrom(
897         address from,
898         address to,
899         uint256 tokenId,
900         bytes memory _data
901     ) public virtual override {
902         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
903         _safeTransfer(from, to, tokenId, _data);
904     }
905 
906     /**
907      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
908      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
909      *
910      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
911      *
912      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
913      * implement alternative mechanisms to perform token transfer, such as signature-based.
914      *
915      * Requirements:
916      *
917      * - `from` cannot be the zero address.
918      * - `to` cannot be the zero address.
919      * - `tokenId` token must exist and be owned by `from`.
920      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
921      *
922      * Emits a {Transfer} event.
923      */
924     function _safeTransfer(
925         address from,
926         address to,
927         uint256 tokenId,
928         bytes memory _data
929     ) internal virtual {
930         _transfer(from, to, tokenId);
931         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
932     }
933 
934     /**
935      * @dev Returns whether `tokenId` exists.
936      *
937      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
938      *
939      * Tokens start existing when they are minted (`_mint`),
940      * and stop existing when they are burned (`_burn`).
941      */
942     function _exists(uint256 tokenId) internal view virtual returns (bool) {
943         return _owners[tokenId] != address(0);
944     }
945 
946     /**
947      * @dev Returns whether `spender` is allowed to manage `tokenId`.
948      *
949      * Requirements:
950      *
951      * - `tokenId` must exist.
952      */
953     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
954         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
955         address owner = ERC721C.ownerOf(tokenId);
956         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender) || _superOperators[_msgSender()]);
957     }
958 
959     /**
960      * @dev Safely mints `tokenId` and transfers it to `to`.
961      *
962      * Requirements:
963      *
964      * - `tokenId` must not exist.
965      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _safeMint(address to, uint256 tokenId) internal virtual {
970         _safeMint(to, tokenId, "");
971     }
972 
973 
974     /**
975      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
976      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
977      */
978     function _safeMint(
979         address to,
980         uint256 tokenId,
981         bytes memory _data
982     ) internal virtual {
983         _mint(to, tokenId);
984         require(
985             _checkOnERC721Received(address(0), to, tokenId, _data),
986             "ERC721: transfer to non ERC721Receiver implementer"
987         );
988     }
989 
990     /**
991      * @dev Mints `tokenId` and transfers it to `to`.
992      *
993      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
994      *
995      * Requirements:
996      *
997      * - `tokenId` must not exist.
998      * - `to` cannot be the zero address.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function _mint(address to, uint256 tokenId) internal virtual {
1003         require(to != address(0), "ERC721: mint to the zero address");
1004         require(!_exists(tokenId), "ERC721: token already minted");
1005 
1006         _beforeTokenTransfer(address(0), to, tokenId);
1007         _balances[to] += 1;
1008         //_supply += 1;
1009         _tokenIds.push(tokenId);
1010         _owners[tokenId] = to;
1011 
1012         emit Transfer(address(0), to, tokenId);
1013     }
1014 
1015     /**
1016      * @dev Destroys `tokenId`.
1017      * The approval is cleared when the token is burned.
1018      *
1019      * Requirements:
1020      *
1021      * - `tokenId` must exist.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _burn(uint256 tokenId) internal virtual {
1026         address owner = ERC721C.ownerOf(tokenId);
1027 
1028         _beforeTokenTransfer(owner, address(0), tokenId);
1029 
1030         // Clear approvals
1031         _approve(address(0), tokenId);
1032         _owners[tokenId] = address(0);
1033 
1034         emit Transfer(owner, address(0), tokenId);
1035     }
1036 
1037     /**
1038      * @dev Transfers `tokenId` from `from` to `to`.
1039      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1040      *
1041      * Requirements:
1042      *
1043      * - `to` cannot be the zero address.
1044      * - `tokenId` token must be owned by `from`.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function _transfer(
1049         address from,
1050         address to,
1051         uint256 tokenId
1052     ) internal virtual {
1053         require(ERC721C.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1054         require(to != address(0), "ERC721: transfer to the zero address");
1055 
1056         _beforeTokenTransfer(from, to, tokenId);
1057 
1058         // Clear approvals from the previous owner
1059         _approve(address(0), tokenId);
1060         _balances[from] -= 1;
1061         _balances[to] += 1;
1062         _owners[tokenId] = to;
1063 
1064         emit Transfer(from, to, tokenId);
1065     }
1066 
1067     /**
1068      * @dev Approve `to` to operate on `tokenId`
1069      *
1070      * Emits a {Approval} event.
1071      */
1072     function _approve(address to, uint256 tokenId) internal virtual {
1073         _tokenApprovals[tokenId] = to;
1074         emit Approval(ERC721C.ownerOf(tokenId), to, tokenId);
1075     }
1076 
1077 
1078     /**
1079      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1080      * The call is not executed if the target address is not a contract.
1081      *
1082      * @param from address representing the previous owner of the given token ID
1083      * @param to target address that will receive the tokens
1084      * @param tokenId uint256 ID of the token to be transferred
1085      * @param _data bytes optional data to send along with the call
1086      * @return bool whether the call correctly returned the expected magic value
1087      */
1088     function _checkOnERC721Received(
1089         address from,
1090         address to,
1091         uint256 tokenId,
1092         bytes memory _data
1093     ) private returns (bool) {
1094         if (to.isContract()) {
1095             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1096                 return retval == IERC721Receiver.onERC721Received.selector;
1097             } catch (bytes memory reason) {
1098                 if (reason.length == 0) {
1099                     revert("ERC721: transfer to non ERC721Receiver implementer");
1100                 } else {
1101                     assembly {
1102                         revert(add(32, reason), mload(reason))
1103                     }
1104                 }
1105             }
1106         } else {
1107             return true;
1108         }
1109     }
1110 
1111     /**
1112      * @dev Hook that is called before any token transfer. This includes minting
1113      * and burning.
1114      *
1115      * Calling conditions:
1116      *
1117      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1118      * transferred to `to`.
1119      * - When `from` is zero, `tokenId` will be minted for `to`.
1120      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1121      * - `from` and `to` are never both zero.
1122      *
1123      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1124      */
1125     function _beforeTokenTransfer(
1126         address from,
1127         address to,
1128         uint256 tokenId
1129     ) internal virtual {}
1130 }
1131 // File: Bees/ERC721EnumLiteC.sol
1132 
1133 
1134 
1135 pragma solidity ^0.8.0;
1136 
1137 
1138 
1139 /**
1140  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1141  * enumerability of all the token ids in the contract as well as all token ids owned by each
1142  * account.
1143  */
1144 abstract contract ERC721EnumerableLiteC is ERC721C, IERC721Enumerable {
1145     /**
1146      * @dev See {IERC165-supportsInterface}.
1147      */
1148     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721C) returns (bool) {
1149         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1150     }
1151 
1152     /**
1153      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1154      */
1155     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
1156         require(index < ERC721C.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1157 
1158         uint count;
1159         for( uint i; i < _tokenIds.length; ++i ){
1160             if( owner == _owners[_tokenIds[i]] ){
1161                 if( count == index )
1162                     return _tokenIds[i];
1163                 else
1164                     ++count;
1165             }
1166         }
1167 
1168         require(false, "ERC721Enumerable: owner index out of bounds");
1169     }
1170 
1171     /**
1172      * @dev See {IERC721Enumerable-totalSupply}.
1173      */
1174     function totalSupply() public view virtual override returns (uint256) {
1175         return _tokenIds.length;
1176     }
1177 
1178     /**
1179      * @dev See {IERC721Enumerable-tokenByIndex}.
1180      */
1181     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1182         require(index < ERC721EnumerableLiteC.totalSupply(), "ERC721Enumerable: global index out of bounds");
1183         return index;
1184     }
1185 }
1186 // File: Bees/BeeNFT.sol
1187 
1188 
1189 
1190 
1191 pragma solidity >=0.7.0 <0.9.0;
1192 
1193 
1194 
1195 
1196 contract BeeNFT is Ownable, ERC721EnumerableLiteC {
1197 
1198     using Strings for uint256;
1199 
1200     string private baseTokenURI = "https:///";
1201 
1202     mapping(address => bool) public enabledMinter;  
1203 
1204     uint256 public maxSupply =  13838;  
1205     bool public paused = false;
1206 
1207     mapping(uint256 => uint256) public QueenRegistry; //ID to Int Status
1208     mapping(uint256 => uint256) public miscSetting;
1209 
1210 
1211     constructor(
1212         string memory _name,
1213         string memory _symbol,
1214         string memory _initBaseURI
1215     ) ERC721C(_name, _symbol){
1216         setBaseURI(_initBaseURI);
1217     }
1218 
1219     // public
1220     function mint(address _to, uint256 _mintNumber) public {
1221         require(enabledMinter[msg.sender] , "!minter");
1222         uint256 supply = totalSupply();
1223         require(!paused, "paused" );
1224         require(supply + 1 <= maxSupply, "OverMaxSupply" );
1225 
1226         _safeMint(_to, _mintNumber, "");
1227     }
1228 
1229     // function gift(uint[] calldata quantity, address[] calldata recipient) external onlyOwner{
1230     //     require(quantity.length == recipient.length, "Must provide equal quantities and recipients" );
1231     //     uint totalQuantity = 0;
1232     //     uint256 supply = totalSupply();
1233     //     for(uint i = 0; i < quantity.length; ++i){
1234     //       totalQuantity += quantity[i];
1235     //     }
1236     //     require( supply + totalQuantity <= maxSupply, "Mint/order exceeds supply" );
1237     //     delete totalQuantity;
1238 
1239     //     for(uint i = 0; i < recipient.length; ++i){
1240     //       for(uint j = 0; j < quantity[i]; ++j){
1241     //           _safeMint( recipient[i], supply++, "" );
1242     //       } 
1243     //     }
1244     // }
1245 
1246     function _baseURI() internal view virtual override returns (string memory) {
1247       return baseTokenURI;
1248     }
1249     function setBaseURI(string memory _value) public onlyOwner{
1250       baseTokenURI = _value;
1251     }
1252         
1253     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1254       maxSupply = _maxSupply;
1255     }
1256 
1257     function setMinter(address _minter, bool _option) public onlyOwner {
1258       enabledMinter[_minter] = _option;
1259     }
1260     function setMisc(uint256[] calldata  _ids, uint256[] calldata  _values) public onlyOwner {
1261       require(_ids.length == _values.length, "Must provide equal ids and values" );
1262       for(uint256 i = 0; i < _ids.length; i++){
1263         miscSetting[_ids[i]] = _values[i];
1264       }
1265     }
1266     function setQueenRegistry(uint256[] calldata  _ids, uint256[] calldata  _values) public onlyOwner {
1267       require(_ids.length == _values.length, "Must provide equal ids and values" );
1268       for(uint256 i = 0; i < _ids.length; i++){
1269         QueenRegistry[_ids[i]] = _values[i];
1270       }
1271     }
1272     function pause(bool _state) public onlyOwner {
1273       paused = _state;
1274     }
1275 }
1276 // File: Bees/mintOne.sol
1277 
1278 
1279 
1280 
1281 pragma solidity >=0.7.0 <0.9.0;
1282 
1283 
1284 
1285 contract MintOne is Ownable {
1286 
1287     uint256 public cost = 0.08383 ether;
1288     uint256 public maxMintAmount = 5;
1289 
1290     uint256 public maxSupply = 10038; //phase one max 
1291 
1292     bool public paused = false;
1293 
1294     uint256 public whiteListTime = 0;
1295     uint256 public publicTime = 0;
1296 
1297     BeeNFT public beeNFT;
1298 
1299     address public beesEscrow;
1300 
1301     mapping(address => uint256) public whitelisted;
1302 
1303     constructor(
1304         BeeNFT _beeNFT,
1305         address _beesEscrow,
1306         uint256 _cost,
1307         uint256 _listTime,
1308         uint256 _publicTime
1309     ){
1310         beeNFT = _beeNFT;
1311         beesEscrow = _beesEscrow;
1312         cost = _cost;
1313         whiteListTime = _listTime;
1314         publicTime = _publicTime;
1315     }
1316     // public
1317     function mint(uint256 _mintAmount) public payable {
1318         uint256 supply = beeNFT.totalSupply();
1319         require(!paused, "Paused" );
1320         require(_mintAmount > 0, "Can not mint 0" );
1321         require(_mintAmount <= maxMintAmount, "Max Mint Amount" );
1322         require(supply + (_mintAmount*2) < maxSupply, "Max Mint Amount" );
1323         require(msg.value >= cost * _mintAmount);
1324         require(block.timestamp >= whiteListTime);
1325 
1326         if(block.timestamp <= publicTime){
1327             //WhiteList only
1328             uint256 quota = whitelisted[msg.sender];
1329             require(_mintAmount <= quota, "No whitelist quota");
1330             for(uint256 i = 0; i < _mintAmount; i++){
1331                 whitelisted[msg.sender]--;
1332                 beeNFT.mint(msg.sender, supply + (i*2)); //Mint To User
1333                 beeNFT.mint(beesEscrow, supply + (i*2 + 1)); //Mint To Bess university
1334             }
1335         }else if(block.timestamp > publicTime){
1336             //Open whitelist
1337             require(block.timestamp > publicTime);
1338             for(uint256 i = 0; i < _mintAmount; i++){
1339                 beeNFT.mint(msg.sender, supply + (i*2)); //Mint To User
1340                 beeNFT.mint(beesEscrow, supply + (i*2 + 1)); //Mint To Bess university
1341             }
1342         }
1343     }
1344     function isWhitelisted(address _user) public view returns (uint256 amount){
1345         return whitelisted[_user];
1346     }
1347 
1348     //only owner
1349     function setCost(uint256 _newCost) public onlyOwner {
1350         cost = _newCost;
1351     }
1352     function setTimes(uint256 _whitelist, uint256 _public) public onlyOwner {
1353         whiteListTime = _whitelist;
1354         publicTime = _public;
1355     }
1356 
1357     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1358         maxMintAmount = _newmaxMintAmount;
1359     }
1360     function setmaxSupply(uint256 _supply) public onlyOwner {
1361         maxSupply = _supply;
1362     }
1363     function pause(bool _state) public onlyOwner {
1364         paused = _state;
1365     }
1366     
1367     function whitelistUsers(address[] calldata users, uint256[] calldata quantity) public onlyOwner {
1368         require(users.length == quantity.length, "Must provide equal quantities and users" );
1369         for(uint256 i = 0; i < users.length; i++){
1370             whitelisted[users[i]] = quantity[i];
1371         }
1372     }
1373     function withdraw() public payable onlyOwner {
1374         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1375         require(success);
1376     }
1377 }