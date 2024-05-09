1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
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
73 
74 pragma solidity ^0.8.0;
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
124         _setOwner(_msgSender());
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
150         _setOwner(address(0));
151     }
152 
153     /**
154      * @dev Transfers ownership of the contract to a new account (`newOwner`).
155      * Can only be called by the current owner.
156      */
157     function transferOwnership(address newOwner) public virtual onlyOwner {
158         require(newOwner != address(0), "Ownable: new owner is the zero address");
159         _setOwner(newOwner);
160     }
161 
162     function _setOwner(address newOwner) private {
163         address oldOwner = _owner;
164         _owner = newOwner;
165         emit OwnershipTransferred(oldOwner, newOwner);
166     }
167 }
168 
169 // File: @openzeppelin/contracts/utils/Address.sol
170 
171 
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @dev Collection of functions related to the address type
177  */
178 library Address {
179     /**
180      * @dev Returns true if `account` is a contract.
181      *
182      * [IMPORTANT]
183      * ====
184      * It is unsafe to assume that an address for which this function returns
185      * false is an externally-owned account (EOA) and not a contract.
186      *
187      * Among others, `isContract` will return false for the following
188      * types of addresses:
189      *
190      *  - an externally-owned account
191      *  - a contract in construction
192      *  - an address where a contract will be created
193      *  - an address where a contract lived, but was destroyed
194      * ====
195      */
196     function isContract(address account) internal view returns (bool) {
197         // This method relies on extcodesize, which returns 0 for contracts in
198         // construction, since the code is only stored at the end of the
199         // constructor execution.
200 
201         uint256 size;
202         assembly {
203             size := extcodesize(account)
204         }
205         return size > 0;
206     }
207 
208     /**
209      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
210      * `recipient`, forwarding all available gas and reverting on errors.
211      *
212      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
213      * of certain opcodes, possibly making contracts go over the 2300 gas limit
214      * imposed by `transfer`, making them unable to receive funds via
215      * `transfer`. {sendValue} removes this limitation.
216      *
217      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
218      *
219      * IMPORTANT: because control is transferred to `recipient`, care must be
220      * taken to not create reentrancy vulnerabilities. Consider using
221      * {ReentrancyGuard} or the
222      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
223      */
224     function sendValue(address payable recipient, uint256 amount) internal {
225         require(address(this).balance >= amount, "Address: insufficient balance");
226 
227         (bool success, ) = recipient.call{value: amount}("");
228         require(success, "Address: unable to send value, recipient may have reverted");
229     }
230 
231     /**
232      * @dev Performs a Solidity function call using a low level `call`. A
233      * plain `call` is an unsafe replacement for a function call: use this
234      * function instead.
235      *
236      * If `target` reverts with a revert reason, it is bubbled up by this
237      * function (like regular Solidity function calls).
238      *
239      * Returns the raw returned data. To convert to the expected return value,
240      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
241      *
242      * Requirements:
243      *
244      * - `target` must be a contract.
245      * - calling `target` with `data` must not revert.
246      *
247      * _Available since v3.1._
248      */
249     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
250         return functionCall(target, data, "Address: low-level call failed");
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
255      * `errorMessage` as a fallback revert reason when `target` reverts.
256      *
257      * _Available since v3.1._
258      */
259     function functionCall(
260         address target,
261         bytes memory data,
262         string memory errorMessage
263     ) internal returns (bytes memory) {
264         return functionCallWithValue(target, data, 0, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but also transferring `value` wei to `target`.
270      *
271      * Requirements:
272      *
273      * - the calling contract must have an ETH balance of at least `value`.
274      * - the called Solidity function must be `payable`.
275      *
276      * _Available since v3.1._
277      */
278     function functionCallWithValue(
279         address target,
280         bytes memory data,
281         uint256 value
282     ) internal returns (bytes memory) {
283         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
288      * with `errorMessage` as a fallback revert reason when `target` reverts.
289      *
290      * _Available since v3.1._
291      */
292     function functionCallWithValue(
293         address target,
294         bytes memory data,
295         uint256 value,
296         string memory errorMessage
297     ) internal returns (bytes memory) {
298         require(address(this).balance >= value, "Address: insufficient balance for call");
299         require(isContract(target), "Address: call to non-contract");
300 
301         (bool success, bytes memory returndata) = target.call{value: value}(data);
302         return verifyCallResult(success, returndata, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but performing a static call.
308      *
309      * _Available since v3.3._
310      */
311     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
312         return functionStaticCall(target, data, "Address: low-level static call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
317      * but performing a static call.
318      *
319      * _Available since v3.3._
320      */
321     function functionStaticCall(
322         address target,
323         bytes memory data,
324         string memory errorMessage
325     ) internal view returns (bytes memory) {
326         require(isContract(target), "Address: static call to non-contract");
327 
328         (bool success, bytes memory returndata) = target.staticcall(data);
329         return verifyCallResult(success, returndata, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but performing a delegate call.
335      *
336      * _Available since v3.4._
337      */
338     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
339         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
344      * but performing a delegate call.
345      *
346      * _Available since v3.4._
347      */
348     function functionDelegateCall(
349         address target,
350         bytes memory data,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         require(isContract(target), "Address: delegate call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.delegatecall(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
361      * revert reason using the provided one.
362      *
363      * _Available since v4.3._
364      */
365     function verifyCallResult(
366         bool success,
367         bytes memory returndata,
368         string memory errorMessage
369     ) internal pure returns (bytes memory) {
370         if (success) {
371             return returndata;
372         } else {
373             // Look for revert reason and bubble it up if present
374             if (returndata.length > 0) {
375                 // The easiest way to bubble the revert reason is using memory via assembly
376 
377                 assembly {
378                     let returndata_size := mload(returndata)
379                     revert(add(32, returndata), returndata_size)
380                 }
381             } else {
382                 revert(errorMessage);
383             }
384         }
385     }
386 }
387 
388 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
389 
390 
391 
392 pragma solidity ^0.8.0;
393 
394 /**
395  * @title ERC721 token receiver interface
396  * @dev Interface for any contract that wants to support safeTransfers
397  * from ERC721 asset contracts.
398  */
399 interface IERC721Receiver {
400     /**
401      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
402      * by `operator` from `from`, this function is called.
403      *
404      * It must return its Solidity selector to confirm the token transfer.
405      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
406      *
407      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
408      */
409     function onERC721Received(
410         address operator,
411         address from,
412         uint256 tokenId,
413         bytes calldata data
414     ) external returns (bytes4);
415 }
416 
417 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
418 
419 
420 
421 pragma solidity ^0.8.0;
422 
423 /**
424  * @dev Interface of the ERC165 standard, as defined in the
425  * https://eips.ethereum.org/EIPS/eip-165[EIP].
426  *
427  * Implementers can declare support of contract interfaces, which can then be
428  * queried by others ({ERC165Checker}).
429  *
430  * For an implementation, see {ERC165}.
431  */
432 interface IERC165 {
433     /**
434      * @dev Returns true if this contract implements the interface defined by
435      * `interfaceId`. See the corresponding
436      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
437      * to learn more about how these ids are created.
438      *
439      * This function call must use less than 30 000 gas.
440      */
441     function supportsInterface(bytes4 interfaceId) external view returns (bool);
442 }
443 
444 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
445 
446 
447 
448 pragma solidity ^0.8.0;
449 
450 
451 /**
452  * @dev Implementation of the {IERC165} interface.
453  *
454  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
455  * for the additional interface id that will be supported. For example:
456  *
457  * ```solidity
458  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
459  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
460  * }
461  * ```
462  *
463  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
464  */
465 abstract contract ERC165 is IERC165 {
466     /**
467      * @dev See {IERC165-supportsInterface}.
468      */
469     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
470         return interfaceId == type(IERC165).interfaceId;
471     }
472 }
473 
474 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
475 
476 
477 
478 pragma solidity ^0.8.0;
479 
480 
481 /**
482  * @dev Required interface of an ERC721 compliant contract.
483  */
484 interface IERC721 is IERC165 {
485     /**
486      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
487      */
488     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
489 
490     /**
491      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
492      */
493     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
494 
495     /**
496      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
497      */
498     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
499 
500     /**
501      * @dev Returns the number of tokens in ``owner``'s account.
502      */
503     function balanceOf(address owner) external view returns (uint256 balance);
504 
505     /**
506      * @dev Returns the owner of the `tokenId` token.
507      *
508      * Requirements:
509      *
510      * - `tokenId` must exist.
511      */
512     function ownerOf(uint256 tokenId) external view returns (address owner);
513 
514     /**
515      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
516      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
517      *
518      * Requirements:
519      *
520      * - `from` cannot be the zero address.
521      * - `to` cannot be the zero address.
522      * - `tokenId` token must exist and be owned by `from`.
523      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
524      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
525      *
526      * Emits a {Transfer} event.
527      */
528     function safeTransferFrom(
529         address from,
530         address to,
531         uint256 tokenId
532     ) external;
533 
534     /**
535      * @dev Transfers `tokenId` token from `from` to `to`.
536      *
537      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
538      *
539      * Requirements:
540      *
541      * - `from` cannot be the zero address.
542      * - `to` cannot be the zero address.
543      * - `tokenId` token must be owned by `from`.
544      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
545      *
546      * Emits a {Transfer} event.
547      */
548     function transferFrom(
549         address from,
550         address to,
551         uint256 tokenId
552     ) external;
553 
554     /**
555      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
556      * The approval is cleared when the token is transferred.
557      *
558      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
559      *
560      * Requirements:
561      *
562      * - The caller must own the token or be an approved operator.
563      * - `tokenId` must exist.
564      *
565      * Emits an {Approval} event.
566      */
567     function approve(address to, uint256 tokenId) external;
568 
569     /**
570      * @dev Returns the account approved for `tokenId` token.
571      *
572      * Requirements:
573      *
574      * - `tokenId` must exist.
575      */
576     function getApproved(uint256 tokenId) external view returns (address operator);
577 
578     /**
579      * @dev Approve or remove `operator` as an operator for the caller.
580      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
581      *
582      * Requirements:
583      *
584      * - The `operator` cannot be the caller.
585      *
586      * Emits an {ApprovalForAll} event.
587      */
588     function setApprovalForAll(address operator, bool _approved) external;
589 
590     /**
591      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
592      *
593      * See {setApprovalForAll}
594      */
595     function isApprovedForAll(address owner, address operator) external view returns (bool);
596 
597     /**
598      * @dev Safely transfers `tokenId` token from `from` to `to`.
599      *
600      * Requirements:
601      *
602      * - `from` cannot be the zero address.
603      * - `to` cannot be the zero address.
604      * - `tokenId` token must exist and be owned by `from`.
605      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
606      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
607      *
608      * Emits a {Transfer} event.
609      */
610     function safeTransferFrom(
611         address from,
612         address to,
613         uint256 tokenId,
614         bytes calldata data
615     ) external;
616 }
617 
618 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
619 
620 
621 
622 pragma solidity ^0.8.0;
623 
624 
625 /**
626  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
627  * @dev See https://eips.ethereum.org/EIPS/eip-721
628  */
629 interface IERC721Metadata is IERC721 {
630     /**
631      * @dev Returns the token collection name.
632      */
633     function name() external view returns (string memory);
634 
635     /**
636      * @dev Returns the token collection symbol.
637      */
638     function symbol() external view returns (string memory);
639 
640     /**
641      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
642      */
643     function tokenURI(uint256 tokenId) external view returns (string memory);
644 }
645 
646 // File: erc721a/contracts/IERC721A.sol
647 
648 
649 // ERC721A Contracts v3.3.0
650 // Creator: Chiru Labs
651 
652 pragma solidity ^0.8.4;
653 
654 
655 
656 /**
657  * @dev Interface of an ERC721A compliant contract.
658  */
659 interface IERC721A is IERC721, IERC721Metadata {
660     /**
661      * The caller must own the token or be an approved operator.
662      */
663     error ApprovalCallerNotOwnerNorApproved();
664 
665     /**
666      * The token does not exist.
667      */
668     error ApprovalQueryForNonexistentToken();
669 
670     /**
671      * The caller cannot approve to their own address.
672      */
673     error ApproveToCaller();
674 
675     /**
676      * The caller cannot approve to the current owner.
677      */
678     error ApprovalToCurrentOwner();
679 
680     /**
681      * Cannot query the balance for the zero address.
682      */
683     error BalanceQueryForZeroAddress();
684 
685     /**
686      * Cannot mint to the zero address.
687      */
688     error MintToZeroAddress();
689 
690     /**
691      * The quantity of tokens minted must be more than zero.
692      */
693     error MintZeroQuantity();
694 
695     /**
696      * The token does not exist.
697      */
698     error OwnerQueryForNonexistentToken();
699 
700     /**
701      * The caller must own the token or be an approved operator.
702      */
703     error TransferCallerNotOwnerNorApproved();
704 
705     /**
706      * The token must be owned by `from`.
707      */
708     error TransferFromIncorrectOwner();
709 
710     /**
711      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
712      */
713     error TransferToNonERC721ReceiverImplementer();
714 
715     /**
716      * Cannot transfer to the zero address.
717      */
718     error TransferToZeroAddress();
719 
720     /**
721      * The token does not exist.
722      */
723     error URIQueryForNonexistentToken();
724 
725     // Compiler will pack this into a single 256bit word.
726     struct TokenOwnership {
727         // The address of the owner.
728         address addr;
729         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
730         uint64 startTimestamp;
731         // Whether the token has been burned.
732         bool burned;
733     }
734 
735     // Compiler will pack this into a single 256bit word.
736     struct AddressData {
737         // Realistically, 2**64-1 is more than enough.
738         uint64 balance;
739         // Keeps track of mint count with minimal overhead for tokenomics.
740         uint64 numberMinted;
741         // Keeps track of burn count with minimal overhead for tokenomics.
742         uint64 numberBurned;
743         // For miscellaneous variable(s) pertaining to the address
744         // (e.g. number of whitelist mint slots used).
745         // If there are multiple variables, please pack them into a uint64.
746         uint64 aux;
747     }
748 
749     /**
750      * @dev Returns the total amount of tokens stored by the contract.
751      * 
752      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
753      */
754     function totalSupply() external view returns (uint256);
755 }
756 
757 // File: erc721a/contracts/ERC721A.sol
758 
759 
760 // ERC721A Contracts v3.3.0
761 // Creator: Chiru Labs
762 
763 pragma solidity ^0.8.4;
764 
765 
766 
767 
768 
769 
770 
771 /**
772  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
773  * the Metadata extension. Built to optimize for lower gas during batch mints.
774  *
775  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
776  *
777  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
778  *
779  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
780  */
781 contract ERC721A is Context, ERC165, IERC721A {
782     using Address for address;
783     using Strings for uint256;
784 
785     // The tokenId of the next token to be minted.
786     uint256 internal _currentIndex;
787 
788     // The number of tokens burned.
789     uint256 internal _burnCounter;
790 
791     // Token name
792     string private _name;
793 
794     // Token symbol
795     string private _symbol;
796 
797     // Mapping from token ID to ownership details
798     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
799     mapping(uint256 => TokenOwnership) internal _ownerships;
800 
801     // Mapping owner address to address data
802     mapping(address => AddressData) private _addressData;
803 
804     // Mapping from token ID to approved address
805     mapping(uint256 => address) private _tokenApprovals;
806 
807     // Mapping from owner to operator approvals
808     mapping(address => mapping(address => bool)) private _operatorApprovals;
809 
810     constructor(string memory name_, string memory symbol_) {
811         _name = name_;
812         _symbol = symbol_;
813         _currentIndex = _startTokenId();
814     }
815 
816     /**
817      * To change the starting tokenId, please override this function.
818      */
819     function _startTokenId() internal view virtual returns (uint256) {
820         return 0;
821     }
822 
823     /**
824      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
825      */
826     function totalSupply() public view override returns (uint256) {
827         // Counter underflow is impossible as _burnCounter cannot be incremented
828         // more than _currentIndex - _startTokenId() times
829         unchecked {
830             return _currentIndex - _burnCounter - _startTokenId();
831         }
832     }
833 
834     /**
835      * Returns the total amount of tokens minted in the contract.
836      */
837     function _totalMinted() internal view returns (uint256) {
838         // Counter underflow is impossible as _currentIndex does not decrement,
839         // and it is initialized to _startTokenId()
840         unchecked {
841             return _currentIndex - _startTokenId();
842         }
843     }
844 
845     /**
846      * @dev See {IERC165-supportsInterface}.
847      */
848     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
849         return
850             interfaceId == type(IERC721).interfaceId ||
851             interfaceId == type(IERC721Metadata).interfaceId ||
852             super.supportsInterface(interfaceId);
853     }
854 
855     /**
856      * @dev See {IERC721-balanceOf}.
857      */
858     function balanceOf(address owner) public view override returns (uint256) {
859         if (owner == address(0)) revert BalanceQueryForZeroAddress();
860         return uint256(_addressData[owner].balance);
861     }
862 
863     /**
864      * Returns the number of tokens minted by `owner`.
865      */
866     function _numberMinted(address owner) internal view returns (uint256) {
867         return uint256(_addressData[owner].numberMinted);
868     }
869 
870     /**
871      * Returns the number of tokens burned by or on behalf of `owner`.
872      */
873     function _numberBurned(address owner) internal view returns (uint256) {
874         return uint256(_addressData[owner].numberBurned);
875     }
876 
877     /**
878      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
879      */
880     function _getAux(address owner) internal view returns (uint64) {
881         return _addressData[owner].aux;
882     }
883 
884     /**
885      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
886      * If there are multiple variables, please pack them into a uint64.
887      */
888     function _setAux(address owner, uint64 aux) internal {
889         _addressData[owner].aux = aux;
890     }
891 
892     /**
893      * Gas spent here starts off proportional to the maximum mint batch size.
894      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
895      */
896     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
897         uint256 curr = tokenId;
898 
899         unchecked {
900             if (_startTokenId() <= curr) if (curr < _currentIndex) {
901                 TokenOwnership memory ownership = _ownerships[curr];
902                 if (!ownership.burned) {
903                     if (ownership.addr != address(0)) {
904                         return ownership;
905                     }
906                     // Invariant:
907                     // There will always be an ownership that has an address and is not burned
908                     // before an ownership that does not have an address and is not burned.
909                     // Hence, curr will not underflow.
910                     while (true) {
911                         curr--;
912                         ownership = _ownerships[curr];
913                         if (ownership.addr != address(0)) {
914                             return ownership;
915                         }
916                     }
917                 }
918             }
919         }
920         revert OwnerQueryForNonexistentToken();
921     }
922 
923     /**
924      * @dev See {IERC721-ownerOf}.
925      */
926     function ownerOf(uint256 tokenId) public view override returns (address) {
927         return _ownershipOf(tokenId).addr;
928     }
929 
930     /**
931      * @dev See {IERC721Metadata-name}.
932      */
933     function name() public view virtual override returns (string memory) {
934         return _name;
935     }
936 
937     /**
938      * @dev See {IERC721Metadata-symbol}.
939      */
940     function symbol() public view virtual override returns (string memory) {
941         return _symbol;
942     }
943 
944     /**
945      * @dev See {IERC721Metadata-tokenURI}.
946      */
947     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
948         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
949 
950         string memory baseURI = _baseURI();
951         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
952     }
953 
954     /**
955      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
956      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
957      * by default, can be overriden in child contracts.
958      */
959     function _baseURI() internal view virtual returns (string memory) {
960         return '';
961     }
962 
963     /**
964      * @dev See {IERC721-approve}.
965      */
966     function approve(address to, uint256 tokenId) public override {
967         address owner = ERC721A.ownerOf(tokenId);
968         if (to == owner) revert ApprovalToCurrentOwner();
969 
970         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
971             revert ApprovalCallerNotOwnerNorApproved();
972         }
973 
974         _approve(to, tokenId, owner);
975     }
976 
977     /**
978      * @dev See {IERC721-getApproved}.
979      */
980     function getApproved(uint256 tokenId) public view override returns (address) {
981         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
982 
983         return _tokenApprovals[tokenId];
984     }
985 
986     /**
987      * @dev See {IERC721-setApprovalForAll}.
988      */
989     function setApprovalForAll(address operator, bool approved) public virtual override {
990         if (operator == _msgSender()) revert ApproveToCaller();
991 
992         _operatorApprovals[_msgSender()][operator] = approved;
993         emit ApprovalForAll(_msgSender(), operator, approved);
994     }
995 
996     /**
997      * @dev See {IERC721-isApprovedForAll}.
998      */
999     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1000         return _operatorApprovals[owner][operator];
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-transferFrom}.
1005      */
1006     function transferFrom(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) public virtual override {
1011         _transfer(from, to, tokenId);
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-safeTransferFrom}.
1016      */
1017     function safeTransferFrom(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) public virtual override {
1022         safeTransferFrom(from, to, tokenId, '');
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-safeTransferFrom}.
1027      */
1028     function safeTransferFrom(
1029         address from,
1030         address to,
1031         uint256 tokenId,
1032         bytes memory _data
1033     ) public virtual override {
1034         _transfer(from, to, tokenId);
1035         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1036             revert TransferToNonERC721ReceiverImplementer();
1037         }
1038     }
1039 
1040     /**
1041      * @dev Returns whether `tokenId` exists.
1042      *
1043      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1044      *
1045      * Tokens start existing when they are minted (`_mint`),
1046      */
1047     function _exists(uint256 tokenId) internal view returns (bool) {
1048         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1049     }
1050 
1051     /**
1052      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1053      */
1054     function _safeMint(address to, uint256 quantity) internal {
1055         _safeMint(to, quantity, '');
1056     }
1057 
1058     /**
1059      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1060      *
1061      * Requirements:
1062      *
1063      * - If `to` refers to a smart contract, it must implement
1064      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1065      * - `quantity` must be greater than 0.
1066      *
1067      * Emits a {Transfer} event.
1068      */
1069     function _safeMint(
1070         address to,
1071         uint256 quantity,
1072         bytes memory _data
1073     ) internal {
1074         uint256 startTokenId = _currentIndex;
1075         if (to == address(0)) revert MintToZeroAddress();
1076         if (quantity == 0) revert MintZeroQuantity();
1077 
1078         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1079 
1080         // Overflows are incredibly unrealistic.
1081         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1082         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1083         unchecked {
1084             _addressData[to].balance += uint64(quantity);
1085             _addressData[to].numberMinted += uint64(quantity);
1086 
1087             _ownerships[startTokenId].addr = to;
1088             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1089 
1090             uint256 updatedIndex = startTokenId;
1091             uint256 end = updatedIndex + quantity;
1092 
1093             if (to.isContract()) {
1094                 do {
1095                     emit Transfer(address(0), to, updatedIndex);
1096                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1097                         revert TransferToNonERC721ReceiverImplementer();
1098                     }
1099                 } while (updatedIndex < end);
1100                 // Reentrancy protection
1101                 if (_currentIndex != startTokenId) revert();
1102             } else {
1103                 do {
1104                     emit Transfer(address(0), to, updatedIndex++);
1105                 } while (updatedIndex < end);
1106             }
1107             _currentIndex = updatedIndex;
1108         }
1109         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1110     }
1111 
1112     /**
1113      * @dev Mints `quantity` tokens and transfers them to `to`.
1114      *
1115      * Requirements:
1116      *
1117      * - `to` cannot be the zero address.
1118      * - `quantity` must be greater than 0.
1119      *
1120      * Emits a {Transfer} event.
1121      */
1122     function _mint(address to, uint256 quantity) internal {
1123         uint256 startTokenId = _currentIndex;
1124         if (to == address(0)) revert MintToZeroAddress();
1125         if (quantity == 0) revert MintZeroQuantity();
1126 
1127         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1128 
1129         // Overflows are incredibly unrealistic.
1130         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1131         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1132         unchecked {
1133             _addressData[to].balance += uint64(quantity);
1134             _addressData[to].numberMinted += uint64(quantity);
1135 
1136             _ownerships[startTokenId].addr = to;
1137             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1138 
1139             uint256 updatedIndex = startTokenId;
1140             uint256 end = updatedIndex + quantity;
1141 
1142             do {
1143                 emit Transfer(address(0), to, updatedIndex++);
1144             } while (updatedIndex < end);
1145 
1146             _currentIndex = updatedIndex;
1147         }
1148         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1149     }
1150 
1151     /**
1152      * @dev Transfers `tokenId` from `from` to `to`.
1153      *
1154      * Requirements:
1155      *
1156      * - `to` cannot be the zero address.
1157      * - `tokenId` token must be owned by `from`.
1158      *
1159      * Emits a {Transfer} event.
1160      */
1161     function _transfer(
1162         address from,
1163         address to,
1164         uint256 tokenId
1165     ) private {
1166         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1167 
1168         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1169 
1170         bool isApprovedOrOwner = (_msgSender() == from ||
1171             isApprovedForAll(from, _msgSender()) ||
1172             getApproved(tokenId) == _msgSender());
1173 
1174         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1175         if (to == address(0)) revert TransferToZeroAddress();
1176 
1177         _beforeTokenTransfers(from, to, tokenId, 1);
1178 
1179         // Clear approvals from the previous owner
1180         _approve(address(0), tokenId, from);
1181 
1182         // Underflow of the sender's balance is impossible because we check for
1183         // ownership above and the recipient's balance can't realistically overflow.
1184         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1185         unchecked {
1186             _addressData[from].balance -= 1;
1187             _addressData[to].balance += 1;
1188 
1189             TokenOwnership storage currSlot = _ownerships[tokenId];
1190             currSlot.addr = to;
1191             currSlot.startTimestamp = uint64(block.timestamp);
1192 
1193             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1194             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1195             uint256 nextTokenId = tokenId + 1;
1196             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1197             if (nextSlot.addr == address(0)) {
1198                 // This will suffice for checking _exists(nextTokenId),
1199                 // as a burned slot cannot contain the zero address.
1200                 if (nextTokenId != _currentIndex) {
1201                     nextSlot.addr = from;
1202                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1203                 }
1204             }
1205         }
1206 
1207         emit Transfer(from, to, tokenId);
1208         _afterTokenTransfers(from, to, tokenId, 1);
1209     }
1210 
1211     /**
1212      * @dev Equivalent to `_burn(tokenId, false)`.
1213      */
1214     function _burn(uint256 tokenId) internal virtual {
1215         _burn(tokenId, false);
1216     }
1217 
1218     /**
1219      * @dev Destroys `tokenId`.
1220      * The approval is cleared when the token is burned.
1221      *
1222      * Requirements:
1223      *
1224      * - `tokenId` must exist.
1225      *
1226      * Emits a {Transfer} event.
1227      */
1228     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1229         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1230 
1231         address from = prevOwnership.addr;
1232 
1233         if (approvalCheck) {
1234             bool isApprovedOrOwner = (_msgSender() == from ||
1235                 isApprovedForAll(from, _msgSender()) ||
1236                 getApproved(tokenId) == _msgSender());
1237 
1238             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1239         }
1240 
1241         _beforeTokenTransfers(from, address(0), tokenId, 1);
1242 
1243         // Clear approvals from the previous owner
1244         _approve(address(0), tokenId, from);
1245 
1246         // Underflow of the sender's balance is impossible because we check for
1247         // ownership above and the recipient's balance can't realistically overflow.
1248         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1249         unchecked {
1250             AddressData storage addressData = _addressData[from];
1251             addressData.balance -= 1;
1252             addressData.numberBurned += 1;
1253 
1254             // Keep track of who burned the token, and the timestamp of burning.
1255             TokenOwnership storage currSlot = _ownerships[tokenId];
1256             currSlot.addr = from;
1257             currSlot.startTimestamp = uint64(block.timestamp);
1258             currSlot.burned = true;
1259 
1260             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1261             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1262             uint256 nextTokenId = tokenId + 1;
1263             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1264             if (nextSlot.addr == address(0)) {
1265                 // This will suffice for checking _exists(nextTokenId),
1266                 // as a burned slot cannot contain the zero address.
1267                 if (nextTokenId != _currentIndex) {
1268                     nextSlot.addr = from;
1269                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1270                 }
1271             }
1272         }
1273 
1274         emit Transfer(from, address(0), tokenId);
1275         _afterTokenTransfers(from, address(0), tokenId, 1);
1276 
1277         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1278         unchecked {
1279             _burnCounter++;
1280         }
1281     }
1282 
1283     /**
1284      * @dev Approve `to` to operate on `tokenId`
1285      *
1286      * Emits a {Approval} event.
1287      */
1288     function _approve(
1289         address to,
1290         uint256 tokenId,
1291         address owner
1292     ) private {
1293         _tokenApprovals[tokenId] = to;
1294         emit Approval(owner, to, tokenId);
1295     }
1296 
1297     /**
1298      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1299      *
1300      * @param from address representing the previous owner of the given token ID
1301      * @param to target address that will receive the tokens
1302      * @param tokenId uint256 ID of the token to be transferred
1303      * @param _data bytes optional data to send along with the call
1304      * @return bool whether the call correctly returned the expected magic value
1305      */
1306     function _checkContractOnERC721Received(
1307         address from,
1308         address to,
1309         uint256 tokenId,
1310         bytes memory _data
1311     ) private returns (bool) {
1312         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1313             return retval == IERC721Receiver(to).onERC721Received.selector;
1314         } catch (bytes memory reason) {
1315             if (reason.length == 0) {
1316                 revert TransferToNonERC721ReceiverImplementer();
1317             } else {
1318                 assembly {
1319                     revert(add(32, reason), mload(reason))
1320                 }
1321             }
1322         }
1323     }
1324 
1325     /**
1326      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1327      * And also called before burning one token.
1328      *
1329      * startTokenId - the first token id to be transferred
1330      * quantity - the amount to be transferred
1331      *
1332      * Calling conditions:
1333      *
1334      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1335      * transferred to `to`.
1336      * - When `from` is zero, `tokenId` will be minted for `to`.
1337      * - When `to` is zero, `tokenId` will be burned by `from`.
1338      * - `from` and `to` are never both zero.
1339      */
1340     function _beforeTokenTransfers(
1341         address from,
1342         address to,
1343         uint256 startTokenId,
1344         uint256 quantity
1345     ) internal virtual {}
1346 
1347     /**
1348      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1349      * minting.
1350      * And also called after one token has been burned.
1351      *
1352      * startTokenId - the first token id to be transferred
1353      * quantity - the amount to be transferred
1354      *
1355      * Calling conditions:
1356      *
1357      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1358      * transferred to `to`.
1359      * - When `from` is zero, `tokenId` has been minted for `to`.
1360      * - When `to` is zero, `tokenId` has been burned by `from`.
1361      * - `from` and `to` are never both zero.
1362      */
1363     function _afterTokenTransfers(
1364         address from,
1365         address to,
1366         uint256 startTokenId,
1367         uint256 quantity
1368     ) internal virtual {}
1369 }
1370 
1371 // File: TrippinEth.sol
1372 
1373 pragma solidity ^0.8.4;
1374 
1375 contract TrippinEth is Ownable, ERC721A {
1376     
1377     string public baseURI;
1378     string public baseExtension = ".json";
1379     uint256 public cost = 0.008 ether;
1380     uint256 public freeSupply = 1000;
1381     uint256 public maxSupply = 10000;
1382     uint256 public maxFreeMint = 5;
1383     uint256 public maxMintAmount = 30;
1384     bool public paused = true;
1385     bool public revealed = false;
1386 
1387 
1388     constructor(
1389         string memory _name,
1390         string memory _symbol,
1391         string memory _initBaseURI
1392     ) ERC721A(_name, _symbol) {
1393         setBaseURI(_initBaseURI);
1394         _safeMint(msg.sender, 10);
1395     }
1396 
1397     function mint(address _to, uint256 _mintAmount) public payable {
1398         require(tx.origin == _msgSender(), "Only EOA");
1399         require(!paused, "Contract paused");
1400         require(_mintAmount > 0);
1401         require(totalSupply() + _mintAmount <= maxSupply, "No more mints.");
1402 
1403         require(_mintAmount <= maxMintAmount);
1404         require(msg.value >= cost * _mintAmount, "Not enough ETH.");
1405 
1406         _safeMint(_to, _mintAmount);
1407     }
1408 
1409     function mintFree(address _to, uint256 _mintAmount) public payable {
1410         require(tx.origin == _msgSender(), "Only EOA");
1411         require(!paused, "Contract paused");
1412         require(_mintAmount > 0 && _mintAmount <= maxFreeMint);
1413         require(totalSupply() + _mintAmount <= freeSupply, "No more free mints.");
1414 
1415         _safeMint(_to, _mintAmount);
1416     }
1417 
1418     function tokenURI(uint256 _tokenId)
1419         public
1420         view
1421         override
1422         returns (string memory)
1423     {
1424         require(
1425         _exists(_tokenId),
1426         "ERC721Metadata: URI query for nonexistent token"
1427         );
1428 
1429         string memory currentBaseURI = baseURI;
1430 
1431         if(!revealed) {
1432             return bytes(currentBaseURI).length > 0
1433                 ? string(abi.encodePacked(currentBaseURI))
1434                 : "";
1435         }
1436 
1437         return bytes(currentBaseURI).length > 0
1438             ? string(abi.encodePacked(currentBaseURI, Strings.toString(_tokenId), baseExtension))
1439             : "";
1440     }
1441 
1442     //only owner
1443     function setCost(uint256 _newCost) public onlyOwner() {
1444         cost = _newCost;
1445     }
1446 
1447     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1448         baseURI = _newBaseURI;
1449     }
1450 
1451     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1452         baseExtension = _newBaseExtension;
1453     }
1454 
1455     function pause(bool _state) public onlyOwner {
1456         paused = _state;
1457     }
1458 
1459     function setRevealed(bool _state) public onlyOwner {
1460         revealed = _state;
1461     }
1462 
1463     function withdraw() public payable onlyOwner {
1464         require(payable(msg.sender).send(address(this).balance));
1465     }
1466 }