1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Contract module that helps prevent reentrant calls to a function.
9  *
10  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
11  * available, which can be applied to functions to make sure there are no nested
12  * (reentrant) calls to them.
13  *
14  * Note that because there is a single `nonReentrant` guard, functions marked as
15  * `nonReentrant` may not call one another. This can be worked around by making
16  * those functions `private`, and then adding `external` `nonReentrant` entry
17  * points to them.
18  *
19  * TIP: If you would like to learn more about reentrancy and alternative ways
20  * to protect against it, check out our blog post
21  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
22  */
23 abstract contract ReentrancyGuard {
24     // Booleans are more expensive than uint256 or any type that takes up a full
25     // word because each write operation emits an extra SLOAD to first read the
26     // slot's contents, replace the bits taken up by the boolean, and then write
27     // back. This is the compiler's defense against contract upgrades and
28     // pointer aliasing, and it cannot be disabled.
29 
30     // The values being non-zero value makes deployment a bit more expensive,
31     // but in exchange the refund on every call to nonReentrant will be lower in
32     // amount. Since refunds are capped to a percentage of the total
33     // transaction's gas, it is best to keep them low in cases like this one, to
34     // increase the likelihood of the full refund coming into effect.
35     uint256 private constant _NOT_ENTERED = 1;
36     uint256 private constant _ENTERED = 2;
37 
38     uint256 private _status;
39 
40     constructor() {
41         _status = _NOT_ENTERED;
42     }
43 
44     /**
45      * @dev Prevents a contract from calling itself, directly or indirectly.
46      * Calling a `nonReentrant` function from another `nonReentrant`
47      * function is not supported. It is possible to prevent this from happening
48      * by making the `nonReentrant` function external, and make it call a
49      * `private` function that does the actual work.
50      */
51     modifier nonReentrant() {
52         // On the first call to nonReentrant, _notEntered will be true
53         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
54 
55         // Any calls to nonReentrant after this point will fail
56         _status = _ENTERED;
57 
58         _;
59 
60         // By storing the original value once again, a refund is triggered (see
61         // https://eips.ethereum.org/EIPS/eip-2200)
62         _status = _NOT_ENTERED;
63     }
64 }
65 
66 // File: @openzeppelin/contracts/utils/Strings.sol
67 
68 
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev String operations.
74  */
75 library Strings {
76     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
80      */
81     function toString(uint256 value) internal pure returns (string memory) {
82         // Inspired by OraclizeAPI's implementation - MIT licence
83         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
84 
85         if (value == 0) {
86             return "0";
87         }
88         uint256 temp = value;
89         uint256 digits;
90         while (temp != 0) {
91             digits++;
92             temp /= 10;
93         }
94         bytes memory buffer = new bytes(digits);
95         while (value != 0) {
96             digits -= 1;
97             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
98             value /= 10;
99         }
100         return string(buffer);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
105      */
106     function toHexString(uint256 value) internal pure returns (string memory) {
107         if (value == 0) {
108             return "0x00";
109         }
110         uint256 temp = value;
111         uint256 length = 0;
112         while (temp != 0) {
113             length++;
114             temp >>= 8;
115         }
116         return toHexString(value, length);
117     }
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
121      */
122     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
123         bytes memory buffer = new bytes(2 * length + 2);
124         buffer[0] = "0";
125         buffer[1] = "x";
126         for (uint256 i = 2 * length + 1; i > 1; --i) {
127             buffer[i] = _HEX_SYMBOLS[value & 0xf];
128             value >>= 4;
129         }
130         require(value == 0, "Strings: hex length insufficient");
131         return string(buffer);
132     }
133 }
134 
135 // File: @openzeppelin/contracts/utils/Context.sol
136 
137 
138 
139 pragma solidity ^0.8.0;
140 
141 /**
142  * @dev Provides information about the current execution context, including the
143  * sender of the transaction and its data. While these are generally available
144  * via msg.sender and msg.data, they should not be accessed in such a direct
145  * manner, since when dealing with meta-transactions the account sending and
146  * paying for execution may not be the actual sender (as far as an application
147  * is concerned).
148  *
149  * This contract is only required for intermediate, library-like contracts.
150  */
151 abstract contract Context {
152     function _msgSender() internal view virtual returns (address) {
153         return msg.sender;
154     }
155 
156     function _msgData() internal view virtual returns (bytes calldata) {
157         return msg.data;
158     }
159 }
160 
161 // File: @openzeppelin/contracts/access/Ownable.sol
162 
163 
164 
165 pragma solidity ^0.8.0;
166 
167 
168 /**
169  * @dev Contract module which provides a basic access control mechanism, where
170  * there is an account (an owner) that can be granted exclusive access to
171  * specific functions.
172  *
173  * By default, the owner account will be the one that deploys the contract. This
174  * can later be changed with {transferOwnership}.
175  *
176  * This module is used through inheritance. It will make available the modifier
177  * `onlyOwner`, which can be applied to your functions to restrict their use to
178  * the owner.
179  */
180 abstract contract Ownable is Context {
181     address private _owner;
182 
183     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
184 
185     /**
186      * @dev Initializes the contract setting the deployer as the initial owner.
187      */
188     constructor() {
189         _setOwner(_msgSender());
190     }
191 
192     /**
193      * @dev Returns the address of the current owner.
194      */
195     function owner() public view virtual returns (address) {
196         return _owner;
197     }
198 
199     /**
200      * @dev Throws if called by any account other than the owner.
201      */
202     modifier onlyOwner() {
203         require(owner() == _msgSender(), "Ownable: caller is not the owner");
204         _;
205     }
206 
207     /**
208      * @dev Leaves the contract without owner. It will not be possible to call
209      * `onlyOwner` functions anymore. Can only be called by the current owner.
210      *
211      * NOTE: Renouncing ownership will leave the contract without an owner,
212      * thereby removing any functionality that is only available to the owner.
213      */
214     function renounceOwnership() public virtual onlyOwner {
215         _setOwner(address(0));
216     }
217 
218     /**
219      * @dev Transfers ownership of the contract to a new account (`newOwner`).
220      * Can only be called by the current owner.
221      */
222     function transferOwnership(address newOwner) public virtual onlyOwner {
223         require(newOwner != address(0), "Ownable: new owner is the zero address");
224         _setOwner(newOwner);
225     }
226 
227     function _setOwner(address newOwner) private {
228         address oldOwner = _owner;
229         _owner = newOwner;
230         emit OwnershipTransferred(oldOwner, newOwner);
231     }
232 }
233 
234 // File: @openzeppelin/contracts/utils/Address.sol
235 
236 
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev Collection of functions related to the address type
242  */
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, `isContract` will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      */
261     function isContract(address account) internal view returns (bool) {
262         // This method relies on extcodesize, which returns 0 for contracts in
263         // construction, since the code is only stored at the end of the
264         // constructor execution.
265 
266         uint256 size;
267         assembly {
268             size := extcodesize(account)
269         }
270         return size > 0;
271     }
272 
273     /**
274      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275      * `recipient`, forwarding all available gas and reverting on errors.
276      *
277      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
278      * of certain opcodes, possibly making contracts go over the 2300 gas limit
279      * imposed by `transfer`, making them unable to receive funds via
280      * `transfer`. {sendValue} removes this limitation.
281      *
282      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283      *
284      * IMPORTANT: because control is transferred to `recipient`, care must be
285      * taken to not create reentrancy vulnerabilities. Consider using
286      * {ReentrancyGuard} or the
287      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288      */
289     function sendValue(address payable recipient, uint256 amount) internal {
290         require(address(this).balance >= amount, "Address: insufficient balance");
291 
292         (bool success, ) = recipient.call{value: amount}("");
293         require(success, "Address: unable to send value, recipient may have reverted");
294     }
295 
296     /**
297      * @dev Performs a Solidity function call using a low level `call`. A
298      * plain `call` is an unsafe replacement for a function call: use this
299      * function instead.
300      *
301      * If `target` reverts with a revert reason, it is bubbled up by this
302      * function (like regular Solidity function calls).
303      *
304      * Returns the raw returned data. To convert to the expected return value,
305      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306      *
307      * Requirements:
308      *
309      * - `target` must be a contract.
310      * - calling `target` with `data` must not revert.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionCall(target, data, "Address: low-level call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320      * `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(
344         address target,
345         bytes memory data,
346         uint256 value
347     ) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(
358         address target,
359         bytes memory data,
360         uint256 value,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         require(isContract(target), "Address: call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.call{value: value}(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
377         return functionStaticCall(target, data, "Address: low-level static call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal view returns (bytes memory) {
391         require(isContract(target), "Address: static call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.staticcall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
404         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal returns (bytes memory) {
418         require(isContract(target), "Address: delegate call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.delegatecall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
426      * revert reason using the provided one.
427      *
428      * _Available since v4.3._
429      */
430     function verifyCallResult(
431         bool success,
432         bytes memory returndata,
433         string memory errorMessage
434     ) internal pure returns (bytes memory) {
435         if (success) {
436             return returndata;
437         } else {
438             // Look for revert reason and bubble it up if present
439             if (returndata.length > 0) {
440                 // The easiest way to bubble the revert reason is using memory via assembly
441 
442                 assembly {
443                     let returndata_size := mload(returndata)
444                     revert(add(32, returndata), returndata_size)
445                 }
446             } else {
447                 revert(errorMessage);
448             }
449         }
450     }
451 }
452 
453 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
454 
455 
456 
457 pragma solidity ^0.8.0;
458 
459 /**
460  * @title ERC721 token receiver interface
461  * @dev Interface for any contract that wants to support safeTransfers
462  * from ERC721 asset contracts.
463  */
464 interface IERC721Receiver {
465     /**
466      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
467      * by `operator` from `from`, this function is called.
468      *
469      * It must return its Solidity selector to confirm the token transfer.
470      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
471      *
472      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
473      */
474     function onERC721Received(
475         address operator,
476         address from,
477         uint256 tokenId,
478         bytes calldata data
479     ) external returns (bytes4);
480 }
481 
482 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
483 
484 
485 
486 pragma solidity ^0.8.0;
487 
488 /**
489  * @dev Interface of the ERC165 standard, as defined in the
490  * https://eips.ethereum.org/EIPS/eip-165[EIP].
491  *
492  * Implementers can declare support of contract interfaces, which can then be
493  * queried by others ({ERC165Checker}).
494  *
495  * For an implementation, see {ERC165}.
496  */
497 interface IERC165 {
498     /**
499      * @dev Returns true if this contract implements the interface defined by
500      * `interfaceId`. See the corresponding
501      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
502      * to learn more about how these ids are created.
503      *
504      * This function call must use less than 30 000 gas.
505      */
506     function supportsInterface(bytes4 interfaceId) external view returns (bool);
507 }
508 
509 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
510 
511 
512 
513 pragma solidity ^0.8.0;
514 
515 
516 /**
517  * @dev Implementation of the {IERC165} interface.
518  *
519  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
520  * for the additional interface id that will be supported. For example:
521  *
522  * ```solidity
523  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
524  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
525  * }
526  * ```
527  *
528  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
529  */
530 abstract contract ERC165 is IERC165 {
531     /**
532      * @dev See {IERC165-supportsInterface}.
533      */
534     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
535         return interfaceId == type(IERC165).interfaceId;
536     }
537 }
538 
539 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
540 
541 
542 
543 pragma solidity ^0.8.0;
544 
545 
546 /**
547  * @dev Required interface of an ERC721 compliant contract.
548  */
549 interface IERC721 is IERC165 {
550     /**
551      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
552      */
553     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
554 
555     /**
556      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
557      */
558     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
559 
560     /**
561      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
562      */
563     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
564 
565     /**
566      * @dev Returns the number of tokens in ``owner``'s account.
567      */
568     function balanceOf(address owner) external view returns (uint256 balance);
569 
570     /**
571      * @dev Returns the owner of the `tokenId` token.
572      *
573      * Requirements:
574      *
575      * - `tokenId` must exist.
576      */
577     function ownerOf(uint256 tokenId) external view returns (address owner);
578 
579     /**
580      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
581      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
582      *
583      * Requirements:
584      *
585      * - `from` cannot be the zero address.
586      * - `to` cannot be the zero address.
587      * - `tokenId` token must exist and be owned by `from`.
588      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
589      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
590      *
591      * Emits a {Transfer} event.
592      */
593     function safeTransferFrom(
594         address from,
595         address to,
596         uint256 tokenId
597     ) external;
598 
599     /**
600      * @dev Transfers `tokenId` token from `from` to `to`.
601      *
602      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
603      *
604      * Requirements:
605      *
606      * - `from` cannot be the zero address.
607      * - `to` cannot be the zero address.
608      * - `tokenId` token must be owned by `from`.
609      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
610      *
611      * Emits a {Transfer} event.
612      */
613     function transferFrom(
614         address from,
615         address to,
616         uint256 tokenId
617     ) external;
618 
619     /**
620      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
621      * The approval is cleared when the token is transferred.
622      *
623      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
624      *
625      * Requirements:
626      *
627      * - The caller must own the token or be an approved operator.
628      * - `tokenId` must exist.
629      *
630      * Emits an {Approval} event.
631      */
632     function approve(address to, uint256 tokenId) external;
633 
634     /**
635      * @dev Returns the account approved for `tokenId` token.
636      *
637      * Requirements:
638      *
639      * - `tokenId` must exist.
640      */
641     function getApproved(uint256 tokenId) external view returns (address operator);
642 
643     /**
644      * @dev Approve or remove `operator` as an operator for the caller.
645      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
646      *
647      * Requirements:
648      *
649      * - The `operator` cannot be the caller.
650      *
651      * Emits an {ApprovalForAll} event.
652      */
653     function setApprovalForAll(address operator, bool _approved) external;
654 
655     /**
656      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
657      *
658      * See {setApprovalForAll}
659      */
660     function isApprovedForAll(address owner, address operator) external view returns (bool);
661 
662     /**
663      * @dev Safely transfers `tokenId` token from `from` to `to`.
664      *
665      * Requirements:
666      *
667      * - `from` cannot be the zero address.
668      * - `to` cannot be the zero address.
669      * - `tokenId` token must exist and be owned by `from`.
670      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
671      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
672      *
673      * Emits a {Transfer} event.
674      */
675     function safeTransferFrom(
676         address from,
677         address to,
678         uint256 tokenId,
679         bytes calldata data
680     ) external;
681 }
682 
683 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
684 
685 
686 
687 pragma solidity ^0.8.0;
688 
689 
690 /**
691  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
692  * @dev See https://eips.ethereum.org/EIPS/eip-721
693  */
694 interface IERC721Enumerable is IERC721 {
695     /**
696      * @dev Returns the total amount of tokens stored by the contract.
697      */
698     function totalSupply() external view returns (uint256);
699 
700     /**
701      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
702      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
703      */
704     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
705 
706     /**
707      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
708      * Use along with {totalSupply} to enumerate all tokens.
709      */
710     function tokenByIndex(uint256 index) external view returns (uint256);
711 }
712 
713 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
714 
715 
716 
717 pragma solidity ^0.8.0;
718 
719 
720 /**
721  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
722  * @dev See https://eips.ethereum.org/EIPS/eip-721
723  */
724 interface IERC721Metadata is IERC721 {
725     /**
726      * @dev Returns the token collection name.
727      */
728     function name() external view returns (string memory);
729 
730     /**
731      * @dev Returns the token collection symbol.
732      */
733     function symbol() external view returns (string memory);
734 
735     /**
736      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
737      */
738     function tokenURI(uint256 tokenId) external view returns (string memory);
739 }
740 
741 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
742 
743 
744 
745 pragma solidity ^0.8.0;
746 
747 
748 
749 
750 
751 
752 
753 
754 /**
755  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
756  * the Metadata extension, but not including the Enumerable extension, which is available separately as
757  * {ERC721Enumerable}.
758  */
759 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
760     using Address for address;
761     using Strings for uint256;
762 
763     // Token name
764     string private _name;
765 
766     // Token symbol
767     string private _symbol;
768 
769     // Mapping from token ID to owner address
770     mapping(uint256 => address) private _owners;
771 
772     // Mapping owner address to token count
773     mapping(address => uint256) private _balances;
774 
775     // Mapping from token ID to approved address
776     mapping(uint256 => address) private _tokenApprovals;
777 
778     // Mapping from owner to operator approvals
779     mapping(address => mapping(address => bool)) private _operatorApprovals;
780 
781     /**
782      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
783      */
784     constructor(string memory name_, string memory symbol_) {
785         _name = name_;
786         _symbol = symbol_;
787     }
788 
789     /**
790      * @dev See {IERC165-supportsInterface}.
791      */
792     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
793         return
794             interfaceId == type(IERC721).interfaceId ||
795             interfaceId == type(IERC721Metadata).interfaceId ||
796             super.supportsInterface(interfaceId);
797     }
798 
799     /**
800      * @dev See {IERC721-balanceOf}.
801      */
802     function balanceOf(address owner) public view virtual override returns (uint256) {
803         require(owner != address(0), "ERC721: balance query for the zero address");
804         return _balances[owner];
805     }
806 
807     /**
808      * @dev See {IERC721-ownerOf}.
809      */
810     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
811         address owner = _owners[tokenId];
812         require(owner != address(0), "ERC721: owner query for nonexistent token");
813         return owner;
814     }
815 
816     /**
817      * @dev See {IERC721Metadata-name}.
818      */
819     function name() public view virtual override returns (string memory) {
820         return _name;
821     }
822 
823     /**
824      * @dev See {IERC721Metadata-symbol}.
825      */
826     function symbol() public view virtual override returns (string memory) {
827         return _symbol;
828     }
829 
830     /**
831      * @dev See {IERC721Metadata-tokenURI}.
832      */
833     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
834         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
835 
836         string memory baseURI = _baseURI();
837         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
838     }
839 
840     /**
841      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
842      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
843      * by default, can be overriden in child contracts.
844      */
845     function _baseURI() internal view virtual returns (string memory) {
846         return "";
847     }
848 
849     /**
850      * @dev See {IERC721-approve}.
851      */
852     function approve(address to, uint256 tokenId) public virtual override {
853         address owner = ERC721.ownerOf(tokenId);
854         require(to != owner, "ERC721: approval to current owner");
855 
856         require(
857             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
858             "ERC721: approve caller is not owner nor approved for all"
859         );
860 
861         _approve(to, tokenId);
862     }
863 
864     /**
865      * @dev See {IERC721-getApproved}.
866      */
867     function getApproved(uint256 tokenId) public view virtual override returns (address) {
868         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
869 
870         return _tokenApprovals[tokenId];
871     }
872 
873     /**
874      * @dev See {IERC721-setApprovalForAll}.
875      */
876     function setApprovalForAll(address operator, bool approved) public virtual override {
877         require(operator != _msgSender(), "ERC721: approve to caller");
878 
879         _operatorApprovals[_msgSender()][operator] = approved;
880         emit ApprovalForAll(_msgSender(), operator, approved);
881     }
882 
883     /**
884      * @dev See {IERC721-isApprovedForAll}.
885      */
886     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
887         return _operatorApprovals[owner][operator];
888     }
889 
890     /**
891      * @dev See {IERC721-transferFrom}.
892      */
893     function transferFrom(
894         address from,
895         address to,
896         uint256 tokenId
897     ) public virtual override {
898         //solhint-disable-next-line max-line-length
899         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
900 
901         _transfer(from, to, tokenId);
902     }
903 
904     /**
905      * @dev See {IERC721-safeTransferFrom}.
906      */
907     function safeTransferFrom(
908         address from,
909         address to,
910         uint256 tokenId
911     ) public virtual override {
912         safeTransferFrom(from, to, tokenId, "");
913     }
914 
915     /**
916      * @dev See {IERC721-safeTransferFrom}.
917      */
918     function safeTransferFrom(
919         address from,
920         address to,
921         uint256 tokenId,
922         bytes memory _data
923     ) public virtual override {
924         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
925         _safeTransfer(from, to, tokenId, _data);
926     }
927 
928     /**
929      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
930      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
931      *
932      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
933      *
934      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
935      * implement alternative mechanisms to perform token transfer, such as signature-based.
936      *
937      * Requirements:
938      *
939      * - `from` cannot be the zero address.
940      * - `to` cannot be the zero address.
941      * - `tokenId` token must exist and be owned by `from`.
942      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
943      *
944      * Emits a {Transfer} event.
945      */
946     function _safeTransfer(
947         address from,
948         address to,
949         uint256 tokenId,
950         bytes memory _data
951     ) internal virtual {
952         _transfer(from, to, tokenId);
953         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
954     }
955 
956     /**
957      * @dev Returns whether `tokenId` exists.
958      *
959      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
960      *
961      * Tokens start existing when they are minted (`_mint`),
962      * and stop existing when they are burned (`_burn`).
963      */
964     function _exists(uint256 tokenId) internal view virtual returns (bool) {
965         return _owners[tokenId] != address(0);
966     }
967 
968     /**
969      * @dev Returns whether `spender` is allowed to manage `tokenId`.
970      *
971      * Requirements:
972      *
973      * - `tokenId` must exist.
974      */
975     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
976         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
977         address owner = ERC721.ownerOf(tokenId);
978         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
979     }
980 
981     /**
982      * @dev Safely mints `tokenId` and transfers it to `to`.
983      *
984      * Requirements:
985      *
986      * - `tokenId` must not exist.
987      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _safeMint(address to, uint256 tokenId) internal virtual {
992         _safeMint(to, tokenId, "");
993     }
994 
995     /**
996      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
997      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
998      */
999     function _safeMint(
1000         address to,
1001         uint256 tokenId,
1002         bytes memory _data
1003     ) internal virtual {
1004         _mint(to, tokenId);
1005         require(
1006             _checkOnERC721Received(address(0), to, tokenId, _data),
1007             "ERC721: transfer to non ERC721Receiver implementer"
1008         );
1009     }
1010 
1011     /**
1012      * @dev Mints `tokenId` and transfers it to `to`.
1013      *
1014      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1015      *
1016      * Requirements:
1017      *
1018      * - `tokenId` must not exist.
1019      * - `to` cannot be the zero address.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function _mint(address to, uint256 tokenId) internal virtual {
1024         require(to != address(0), "ERC721: mint to the zero address");
1025         require(!_exists(tokenId), "ERC721: token already minted");
1026 
1027         _beforeTokenTransfer(address(0), to, tokenId);
1028 
1029         _balances[to] += 1;
1030         _owners[tokenId] = to;
1031 
1032         emit Transfer(address(0), to, tokenId);
1033     }
1034 
1035     /**
1036      * @dev Destroys `tokenId`.
1037      * The approval is cleared when the token is burned.
1038      *
1039      * Requirements:
1040      *
1041      * - `tokenId` must exist.
1042      *
1043      * Emits a {Transfer} event.
1044      */
1045     function _burn(uint256 tokenId) internal virtual {
1046         address owner = ERC721.ownerOf(tokenId);
1047 
1048         _beforeTokenTransfer(owner, address(0), tokenId);
1049 
1050         // Clear approvals
1051         _approve(address(0), tokenId);
1052 
1053         _balances[owner] -= 1;
1054         delete _owners[tokenId];
1055 
1056         emit Transfer(owner, address(0), tokenId);
1057     }
1058 
1059     /**
1060      * @dev Transfers `tokenId` from `from` to `to`.
1061      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1062      *
1063      * Requirements:
1064      *
1065      * - `to` cannot be the zero address.
1066      * - `tokenId` token must be owned by `from`.
1067      *
1068      * Emits a {Transfer} event.
1069      */
1070     function _transfer(
1071         address from,
1072         address to,
1073         uint256 tokenId
1074     ) internal virtual {
1075         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1076         require(to != address(0), "ERC721: transfer to the zero address");
1077 
1078         _beforeTokenTransfer(from, to, tokenId);
1079 
1080         // Clear approvals from the previous owner
1081         _approve(address(0), tokenId);
1082 
1083         _balances[from] -= 1;
1084         _balances[to] += 1;
1085         _owners[tokenId] = to;
1086 
1087         emit Transfer(from, to, tokenId);
1088     }
1089 
1090     /**
1091      * @dev Approve `to` to operate on `tokenId`
1092      *
1093      * Emits a {Approval} event.
1094      */
1095     function _approve(address to, uint256 tokenId) internal virtual {
1096         _tokenApprovals[tokenId] = to;
1097         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1098     }
1099 
1100     /**
1101      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1102      * The call is not executed if the target address is not a contract.
1103      *
1104      * @param from address representing the previous owner of the given token ID
1105      * @param to target address that will receive the tokens
1106      * @param tokenId uint256 ID of the token to be transferred
1107      * @param _data bytes optional data to send along with the call
1108      * @return bool whether the call correctly returned the expected magic value
1109      */
1110     function _checkOnERC721Received(
1111         address from,
1112         address to,
1113         uint256 tokenId,
1114         bytes memory _data
1115     ) private returns (bool) {
1116         if (to.isContract()) {
1117             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1118                 return retval == IERC721Receiver.onERC721Received.selector;
1119             } catch (bytes memory reason) {
1120                 if (reason.length == 0) {
1121                     revert("ERC721: transfer to non ERC721Receiver implementer");
1122                 } else {
1123                     assembly {
1124                         revert(add(32, reason), mload(reason))
1125                     }
1126                 }
1127             }
1128         } else {
1129             return true;
1130         }
1131     }
1132 
1133     /**
1134      * @dev Hook that is called before any token transfer. This includes minting
1135      * and burning.
1136      *
1137      * Calling conditions:
1138      *
1139      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1140      * transferred to `to`.
1141      * - When `from` is zero, `tokenId` will be minted for `to`.
1142      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1143      * - `from` and `to` are never both zero.
1144      *
1145      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1146      */
1147     function _beforeTokenTransfer(
1148         address from,
1149         address to,
1150         uint256 tokenId
1151     ) internal virtual {}
1152 }
1153 
1154 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1155 
1156 
1157 
1158 pragma solidity ^0.8.0;
1159 
1160 
1161 
1162 /**
1163  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1164  * enumerability of all the token ids in the contract as well as all token ids owned by each
1165  * account.
1166  */
1167 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1168     // Mapping from owner to list of owned token IDs
1169     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1170 
1171     // Mapping from token ID to index of the owner tokens list
1172     mapping(uint256 => uint256) private _ownedTokensIndex;
1173 
1174     // Array with all token ids, used for enumeration
1175     uint256[] private _allTokens;
1176 
1177     // Mapping from token id to position in the allTokens array
1178     mapping(uint256 => uint256) private _allTokensIndex;
1179 
1180     /**
1181      * @dev See {IERC165-supportsInterface}.
1182      */
1183     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1184         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1185     }
1186 
1187     /**
1188      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1189      */
1190     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1191         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1192         return _ownedTokens[owner][index];
1193     }
1194 
1195     /**
1196      * @dev See {IERC721Enumerable-totalSupply}.
1197      */
1198     function totalSupply() public view virtual override returns (uint256) {
1199         return _allTokens.length;
1200     }
1201 
1202     /**
1203      * @dev See {IERC721Enumerable-tokenByIndex}.
1204      */
1205     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1206         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1207         return _allTokens[index];
1208     }
1209 
1210     /**
1211      * @dev Hook that is called before any token transfer. This includes minting
1212      * and burning.
1213      *
1214      * Calling conditions:
1215      *
1216      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1217      * transferred to `to`.
1218      * - When `from` is zero, `tokenId` will be minted for `to`.
1219      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1220      * - `from` cannot be the zero address.
1221      * - `to` cannot be the zero address.
1222      *
1223      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1224      */
1225     function _beforeTokenTransfer(
1226         address from,
1227         address to,
1228         uint256 tokenId
1229     ) internal virtual override {
1230         super._beforeTokenTransfer(from, to, tokenId);
1231 
1232         if (from == address(0)) {
1233             _addTokenToAllTokensEnumeration(tokenId);
1234         } else if (from != to) {
1235             _removeTokenFromOwnerEnumeration(from, tokenId);
1236         }
1237         if (to == address(0)) {
1238             _removeTokenFromAllTokensEnumeration(tokenId);
1239         } else if (to != from) {
1240             _addTokenToOwnerEnumeration(to, tokenId);
1241         }
1242     }
1243 
1244     /**
1245      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1246      * @param to address representing the new owner of the given token ID
1247      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1248      */
1249     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1250         uint256 length = ERC721.balanceOf(to);
1251         _ownedTokens[to][length] = tokenId;
1252         _ownedTokensIndex[tokenId] = length;
1253     }
1254 
1255     /**
1256      * @dev Private function to add a token to this extension's token tracking data structures.
1257      * @param tokenId uint256 ID of the token to be added to the tokens list
1258      */
1259     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1260         _allTokensIndex[tokenId] = _allTokens.length;
1261         _allTokens.push(tokenId);
1262     }
1263 
1264     /**
1265      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1266      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1267      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1268      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1269      * @param from address representing the previous owner of the given token ID
1270      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1271      */
1272     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1273         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1274         // then delete the last slot (swap and pop).
1275 
1276         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1277         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1278 
1279         // When the token to delete is the last token, the swap operation is unnecessary
1280         if (tokenIndex != lastTokenIndex) {
1281             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1282 
1283             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1284             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1285         }
1286 
1287         // This also deletes the contents at the last position of the array
1288         delete _ownedTokensIndex[tokenId];
1289         delete _ownedTokens[from][lastTokenIndex];
1290     }
1291 
1292     /**
1293      * @dev Private function to remove a token from this extension's token tracking data structures.
1294      * This has O(1) time complexity, but alters the order of the _allTokens array.
1295      * @param tokenId uint256 ID of the token to be removed from the tokens list
1296      */
1297     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1298         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1299         // then delete the last slot (swap and pop).
1300 
1301         uint256 lastTokenIndex = _allTokens.length - 1;
1302         uint256 tokenIndex = _allTokensIndex[tokenId];
1303 
1304         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1305         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1306         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1307         uint256 lastTokenId = _allTokens[lastTokenIndex];
1308 
1309         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1310         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1311 
1312         // This also deletes the contents at the last position of the array
1313         delete _allTokensIndex[tokenId];
1314         _allTokens.pop();
1315     }
1316 }
1317 
1318 // File: contracts/5_dragon.sol
1319 
1320 pragma solidity >= 0.8.0;
1321 
1322 
1323 
1324 
1325 /*
1326                           ,     \    /      ,
1327                          / \    )\__/(     / \
1328                         /   \  (_\  /_)   /   \
1329      __________________/_____\__\@  @/___/_____\_________________
1330      |                          |\../|                          |
1331      |                           \VV/                           |
1332      |                                                          |
1333      |                       DRAGON SAGA                        |
1334      |                                                          |
1335      |                                                          |
1336      |__________________________________________________________|
1337                    |    /\ /      \\       \ /\    |
1338                    |  /   V        ))       V   \  |
1339                    |/     `       //        '     \|
1340                    `              V                '
1341 */
1342 contract DragonSaga is ERC721, ERC721Enumerable, Ownable {
1343     uint256 public constant MAXSUPPLY = 10000;
1344     uint256 public constant RESERVE = 100;
1345     uint256 public constant MAX_PER_PRESALE_TRANSACTION = 3;
1346     uint256 public constant MAX_PER_RESERVE_TRANSACTION = 5;
1347     uint256 public constant MAX_PER_PUBLIC_TRANSACTION  = 5;
1348     uint256 public constant MAX_PRESALE = 1500;
1349     uint256 private constant PRICE = 0.08 ether; 
1350 
1351     // launch dates - unix timestamp
1352     uint256 private _presaleDate = 0;
1353     uint256 private _reserveDate = 0;
1354     uint256 private _publicDate  = 0;
1355 
1356     // tokenURI for metadata
1357     string private _tokenURI = "";
1358 
1359     // presale whitelist logic 
1360     uint256 public presaleAllowedCount = 0;
1361     mapping(address => bool) presaleAddressAllowed;
1362     mapping(address => uint256) presaleAddressMinted;
1363 
1364     // reservation logic
1365     uint256 public reservationAllowedCount = 0;
1366     mapping(address => uint256) reservationAddressAllowed;
1367     mapping(address => uint256) reservationAddressMinted;
1368 
1369     // public sale logic
1370     mapping(address => uint256) publicAddressMinted;
1371 
1372     // Team wallet addresses for withdrawal.
1373     address public a1;
1374     address public a2;
1375     address public a3;
1376     address public a4;
1377 
1378     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1379         super._beforeTokenTransfer(from, to, tokenId);
1380     }
1381     
1382     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1383         return super.supportsInterface(interfaceId);
1384     }
1385 
1386     
1387     /**
1388      * Modifiers
1389      */
1390 
1391     // ensures that the max presale can't be over the limit
1392     modifier checkIfPresaleCapped(uint256 _amount) {
1393         require(presaleAllowedCount + _amount <= MAX_PRESALE, "Adding more will exceed presale total supply");
1394         _;
1395     }
1396 
1397     // checks if the presale is active.
1398     modifier checkIfPresaleSaleActive(){
1399         require(block.timestamp >= _presaleDate && _presaleDate > 0, "Presale Sale hasn't started yet!");
1400         require(block.timestamp < _reserveDate && _reserveDate > 0, "Presale has ended!");
1401         _;
1402     }
1403 
1404     // checks if the reserve sale is active.
1405     modifier checkIfReserveSaleActive() {
1406         require(block.timestamp >= _reserveDate && _reserveDate > 0, "Reserve sale hasn't started yet!");
1407         require(block.timestamp < _publicDate && _publicDate > 0, "Reserve sale has ended!");
1408         _;
1409     }
1410 
1411     // checks if the public sale is active.
1412     modifier checkIfPublicSaleActive(){
1413         require(block.timestamp >= _publicDate && _publicDate > 0, "Public sale hasn't started yet!");
1414         _;
1415     }
1416 
1417 
1418     constructor(string memory tokenURI) ERC721("DRAGONSAGA", "SAGA") {
1419         setBaseURI(tokenURI);
1420         _tokenURI = tokenURI;
1421     }
1422 
1423 
1424     // Override so the openzeppelin tokenURI() method will use this method to create the full tokenURI instead
1425     function _baseURI() internal view virtual override returns (string memory) {
1426         return _tokenURI;
1427     }
1428 
1429     /**
1430      * sets the token uri for the metadata after mint
1431      *
1432      * @param baseURI metadata api url
1433      */
1434     function setBaseURI(string memory baseURI) public onlyOwner {
1435         _tokenURI = baseURI;
1436     }
1437 
1438     /**
1439      * Set withdrawal addresses. 
1440      */
1441     function setAddresses(address[] memory _a) public onlyOwner {
1442         a1 = _a[0];
1443         a2 = _a[1];
1444         a3 = _a[2];
1445         a4 = _a[3];
1446     }
1447 
1448     /**
1449      * Withdraw holdings and pay the hard working team.
1450      */
1451     function withdrawToTeam(uint256 amount) public payable onlyOwner {
1452 
1453         uint256 percent = amount / 100;
1454         
1455         // Give each member their share.
1456         require(payable(a1).send(percent * 25));
1457         require(payable(a2).send(percent * 25));
1458         require(payable(a3).send(percent * 25));
1459         require(payable(a4).send(percent * 25));
1460     }
1461 
1462     /**
1463      * Funny man
1464      */
1465     function emergencyWithdraw() public pure returns (string memory){
1466         return "https://tenor.com/view/jake-jake-the-dog-funny-laugh-laughing-gif-5372688"; // LOL, just kidding.
1467     }
1468 
1469     /**
1470      * set the presale, public, or reserve launch date
1471      * 
1472      * @param timestamp unix formatted
1473      * @param group 0 for public launch
1474      */
1475     function setLaunchDate(uint256 timestamp, uint256 group) public onlyOwner {
1476         if (group == 0) {
1477             _presaleDate = timestamp;
1478         }
1479         if (group == 1){
1480             _reserveDate = timestamp;
1481         }
1482         if (group == 2){
1483             _publicDate = timestamp;
1484         }
1485     }
1486 
1487     /**
1488      * adds a bulk array of address to the presale list
1489      * 
1490      * @param _list group of addresses
1491      */
1492     function addListToPresale(address[] memory _list) public onlyOwner checkIfPresaleCapped(_list.length) {
1493         for (uint256 i; i < _list.length; i++) {
1494             presaleAddressAllowed[_list[i]] = true;
1495             presaleAllowedCount += 1;
1496         }
1497     }
1498 
1499     /**
1500      * adds a bulk array of address to the reservation list
1501      *
1502      * @param _list group of addresses
1503      */
1504     function addListToReservation(address[] memory _list, uint256[] memory _amount) public onlyOwner {
1505         for (uint256 i; i < _list.length; i++) {
1506             reservationAddressAllowed[_list[i]] = _amount[i];
1507             reservationAllowedCount += 1;
1508         }
1509     }
1510 
1511     /**
1512      * Minting functions.
1513      */
1514 
1515     /**
1516      * reserves the dragons for giveaways, community events, and team
1517      *
1518      * @param _amount the amount we're minting
1519      */
1520     function reserveDragons(uint256 _amount) public onlyOwner {
1521         uint256 amountOfTokens = balanceOf(msg.sender);
1522         uint256 totalSupply = totalSupply();
1523 
1524         require(_amount <= RESERVE, "Your amount exceeds the reserve supply!");
1525         require(_amount + amountOfTokens <= RESERVE, "Your amount plus your balance exceeds the reserve supply!");
1526 
1527         for (uint256 i; i < _amount; i++) {
1528             _safeMint(msg.sender, totalSupply + i);
1529         }
1530     }
1531 
1532     /**
1533      * this is the mint function for presale release
1534      *
1535      * @param _amount the amount we're minting
1536      */
1537     function mintPresale(uint256 _amount) public payable checkIfPresaleSaleActive {
1538         
1539         uint256 totalSupply = totalSupply();
1540 
1541         require(_amount <= MAX_PER_PRESALE_TRANSACTION, "Your amount exceeds presale transaction limit!");
1542         require(presaleAddressAllowed[msg.sender] == true, "You're not whitelisted for presale!");
1543         require(presaleAddressMinted[msg.sender] < 1, "You already purchased during presale!");
1544         require(presaleAddressMinted[msg.sender] + _amount <= MAX_PER_PRESALE_TRANSACTION, "You already purchased during presale!");
1545         require(PRICE * _amount <= msg.value, "Transaction value is too low");
1546         require(totalSupply + _amount + RESERVE <= MAXSUPPLY, "You can not mint more than the max supply" );
1547 
1548         for (uint256 i;i < _amount;i++) {
1549             _safeMint(msg.sender, totalSupply + i);
1550         }
1551 
1552         presaleAddressMinted[msg.sender] += _amount;
1553     }
1554 
1555     /**
1556      * Let the user mint from the amount reserved.
1557      *
1558      * @param _amount the amount we're minting
1559      */
1560     function mintReservation(uint256 _amount) public payable checkIfReserveSaleActive {
1561         
1562         uint256 totalSupply = totalSupply();
1563         uint256 reservedAmount = reservationAddressAllowed[msg.sender];
1564 
1565         require(reservationAddressMinted[msg.sender] < 1, "You already minted your reserved amount!");
1566         require(reservedAmount > 0, "You're address is not reserved!");
1567         require(_amount == reservedAmount, "You have to mint the number reserved to you.");
1568         require(PRICE * _amount <= msg.value, "Transaction value is too low");
1569         require(totalSupply + _amount + RESERVE <= MAXSUPPLY, "You can not mint more than the max supply" );
1570 
1571         for (uint256 i;i < _amount;i++) {
1572             _safeMint(msg.sender, totalSupply + i);
1573         }
1574 
1575         reservationAddressMinted[msg.sender] += _amount;
1576     }
1577 
1578     /**
1579      * Let the user mint from our public
1580      *
1581      * @param _amount the amount we're minting
1582      */
1583     function mintPublic(uint256 _amount) public payable checkIfPublicSaleActive {
1584         
1585         uint256 totalSupply = totalSupply();
1586 
1587         require(_amount > 0, "You have to mint at least 1.");
1588         require(_amount <= MAX_PER_PUBLIC_TRANSACTION, "You cannot mint more then 5 per request.");
1589         require(PRICE * _amount <= msg.value, "Transaction value is too low");
1590         require(totalSupply + _amount + RESERVE <= MAXSUPPLY, "You can not mint more than the max supply" );
1591         
1592         for (uint256 i;i < _amount;i++) {
1593             _safeMint(msg.sender, totalSupply + i);
1594         }
1595 
1596         publicAddressMinted[msg.sender] += _amount;
1597     }
1598 
1599 
1600 
1601     /**
1602      * Helper functions.
1603      */
1604      
1605     // checks if the address provided is part of the presale
1606     function checkPresaleAddress(address _address) public view returns (bool) {
1607         return presaleAddressAllowed[_address];
1608     }
1609 
1610     // Checks if the address provided is part of the reserved list
1611     function checkReservationAddress(address _address) public view returns (uint256) {
1612         return reservationAddressAllowed[_address];
1613     }
1614 
1615     // Gets the tokens owned by the address provided and returns it
1616     function getTokensFromAddress(address _address) public view returns (uint256[] memory) {
1617         uint256 amountOfTokens = balanceOf(_address);
1618 
1619         if (amountOfTokens == 0) {
1620             return new uint256[](0);
1621         }
1622 
1623         uint256[] memory tokens = new uint256[](amountOfTokens);
1624 
1625         for (uint256 i; i < amountOfTokens;i++) {
1626             tokens[i] = tokenOfOwnerByIndex(_address, i);
1627         }
1628 
1629         return tokens;
1630     }
1631     
1632     /**
1633      * Getter functions
1634      */
1635     function getPresaleDate() public view returns (uint256) { return _presaleDate; }
1636     function getReserveDate() public view returns (uint256) { return _reserveDate; }
1637     function getPublicDate()  public view returns (uint256) { return _publicDate;  }
1638 
1639     // Get the max per transaction
1640     function getMaxPerPresale() public pure returns (uint256) { return MAX_PER_PRESALE_TRANSACTION; }
1641     function getMaxPerReserve() public pure returns (uint256) { return MAX_PER_RESERVE_TRANSACTION; }
1642     function getMaxPerPublic()  public pure returns (uint256) { return MAX_PER_PUBLIC_TRANSACTION;  }
1643 
1644     // get the price for each token
1645     function getPrice() public pure returns (uint256) { return PRICE; }
1646 
1647     // returns the amount of addresses in the presale
1648     function getPresaleAddressCount() public view returns (uint256) { return presaleAllowedCount; }
1649 
1650     // returns the amount of address in the reservation
1651     function getReservationAddressCount() public view returns (uint256) { return reservationAllowedCount; }
1652 }