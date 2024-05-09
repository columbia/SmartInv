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
444 // File: @openzeppelin/contracts/interfaces/IERC165.sol
445 
446 
447 
448 pragma solidity ^0.8.0;
449 
450 
451 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
452 
453 
454 
455 pragma solidity ^0.8.0;
456 
457 
458 /**
459  * @dev Interface for the NFT Royalty Standard
460  */
461 interface IERC2981 is IERC165 {
462     /**
463      * @dev Called with the sale price to determine how much royalty is owed and to whom.
464      * @param tokenId - the NFT asset queried for royalty information
465      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
466      * @return receiver - address of who should be sent the royalty payment
467      * @return royaltyAmount - the royalty payment amount for `salePrice`
468      */
469     function royaltyInfo(uint256 tokenId, uint256 salePrice)
470         external
471         view
472         returns (address receiver, uint256 royaltyAmount);
473 }
474 
475 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
476 
477 
478 
479 pragma solidity ^0.8.0;
480 
481 
482 /**
483  * @dev Implementation of the {IERC165} interface.
484  *
485  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
486  * for the additional interface id that will be supported. For example:
487  *
488  * ```solidity
489  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
490  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
491  * }
492  * ```
493  *
494  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
495  */
496 abstract contract ERC165 is IERC165 {
497     /**
498      * @dev See {IERC165-supportsInterface}.
499      */
500     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
501         return interfaceId == type(IERC165).interfaceId;
502     }
503 }
504 
505 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
506 
507 
508 
509 pragma solidity ^0.8.0;
510 
511 
512 /**
513  * @dev Required interface of an ERC721 compliant contract.
514  */
515 interface IERC721 is IERC165 {
516     /**
517      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
518      */
519     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
520 
521     /**
522      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
523      */
524     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
525 
526     /**
527      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
528      */
529     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
530 
531     /**
532      * @dev Returns the number of tokens in ``owner``'s account.
533      */
534     function balanceOf(address owner) external view returns (uint256 balance);
535 
536     /**
537      * @dev Returns the owner of the `tokenId` token.
538      *
539      * Requirements:
540      *
541      * - `tokenId` must exist.
542      */
543     function ownerOf(uint256 tokenId) external view returns (address owner);
544 
545     /**
546      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
547      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
548      *
549      * Requirements:
550      *
551      * - `from` cannot be the zero address.
552      * - `to` cannot be the zero address.
553      * - `tokenId` token must exist and be owned by `from`.
554      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
555      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
556      *
557      * Emits a {Transfer} event.
558      */
559     function safeTransferFrom(
560         address from,
561         address to,
562         uint256 tokenId
563     ) external;
564 
565     /**
566      * @dev Transfers `tokenId` token from `from` to `to`.
567      *
568      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
569      *
570      * Requirements:
571      *
572      * - `from` cannot be the zero address.
573      * - `to` cannot be the zero address.
574      * - `tokenId` token must be owned by `from`.
575      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
576      *
577      * Emits a {Transfer} event.
578      */
579     function transferFrom(
580         address from,
581         address to,
582         uint256 tokenId
583     ) external;
584 
585     /**
586      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
587      * The approval is cleared when the token is transferred.
588      *
589      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
590      *
591      * Requirements:
592      *
593      * - The caller must own the token or be an approved operator.
594      * - `tokenId` must exist.
595      *
596      * Emits an {Approval} event.
597      */
598     function approve(address to, uint256 tokenId) external;
599 
600     /**
601      * @dev Returns the account approved for `tokenId` token.
602      *
603      * Requirements:
604      *
605      * - `tokenId` must exist.
606      */
607     function getApproved(uint256 tokenId) external view returns (address operator);
608 
609     /**
610      * @dev Approve or remove `operator` as an operator for the caller.
611      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
612      *
613      * Requirements:
614      *
615      * - The `operator` cannot be the caller.
616      *
617      * Emits an {ApprovalForAll} event.
618      */
619     function setApprovalForAll(address operator, bool _approved) external;
620 
621     /**
622      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
623      *
624      * See {setApprovalForAll}
625      */
626     function isApprovedForAll(address owner, address operator) external view returns (bool);
627 
628     /**
629      * @dev Safely transfers `tokenId` token from `from` to `to`.
630      *
631      * Requirements:
632      *
633      * - `from` cannot be the zero address.
634      * - `to` cannot be the zero address.
635      * - `tokenId` token must exist and be owned by `from`.
636      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
637      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
638      *
639      * Emits a {Transfer} event.
640      */
641     function safeTransferFrom(
642         address from,
643         address to,
644         uint256 tokenId,
645         bytes calldata data
646     ) external;
647 }
648 
649 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
650 
651 
652 
653 pragma solidity ^0.8.0;
654 
655 
656 /**
657  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
658  * @dev See https://eips.ethereum.org/EIPS/eip-721
659  */
660 interface IERC721Enumerable is IERC721 {
661     /**
662      * @dev Returns the total amount of tokens stored by the contract.
663      */
664     function totalSupply() external view returns (uint256);
665 
666     /**
667      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
668      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
669      */
670     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
671 
672     /**
673      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
674      * Use along with {totalSupply} to enumerate all tokens.
675      */
676     function tokenByIndex(uint256 index) external view returns (uint256);
677 }
678 
679 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
680 
681 
682 
683 pragma solidity ^0.8.0;
684 
685 
686 /**
687  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
688  * @dev See https://eips.ethereum.org/EIPS/eip-721
689  */
690 interface IERC721Metadata is IERC721 {
691     /**
692      * @dev Returns the token collection name.
693      */
694     function name() external view returns (string memory);
695 
696     /**
697      * @dev Returns the token collection symbol.
698      */
699     function symbol() external view returns (string memory);
700 
701     /**
702      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
703      */
704     function tokenURI(uint256 tokenId) external view returns (string memory);
705 }
706 
707 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
708 
709 
710 
711 pragma solidity ^0.8.0;
712 
713 
714 
715 
716 
717 
718 
719 
720 /**
721  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
722  * the Metadata extension, but not including the Enumerable extension, which is available separately as
723  * {ERC721Enumerable}.
724  */
725 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
726     using Address for address;
727     using Strings for uint256;
728 
729     // Token name
730     string private _name;
731 
732     // Token symbol
733     string private _symbol;
734 
735     // Mapping from token ID to owner address
736     mapping(uint256 => address) private _owners;
737 
738     // Mapping owner address to token count
739     mapping(address => uint256) private _balances;
740 
741     // Mapping from token ID to approved address
742     mapping(uint256 => address) private _tokenApprovals;
743 
744     // Mapping from owner to operator approvals
745     mapping(address => mapping(address => bool)) private _operatorApprovals;
746 
747     /**
748      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
749      */
750     constructor(string memory name_, string memory symbol_) {
751         _name = name_;
752         _symbol = symbol_;
753     }
754 
755     /**
756      * @dev See {IERC165-supportsInterface}.
757      */
758     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
759         return
760             interfaceId == type(IERC721).interfaceId ||
761             interfaceId == type(IERC721Metadata).interfaceId ||
762             super.supportsInterface(interfaceId);
763     }
764 
765     /**
766      * @dev See {IERC721-balanceOf}.
767      */
768     function balanceOf(address owner) public view virtual override returns (uint256) {
769         require(owner != address(0), "ERC721: balance query for the zero address");
770         return _balances[owner];
771     }
772 
773     /**
774      * @dev See {IERC721-ownerOf}.
775      */
776     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
777         address owner = _owners[tokenId];
778         require(owner != address(0), "ERC721: owner query for nonexistent token");
779         return owner;
780     }
781 
782     /**
783      * @dev See {IERC721Metadata-name}.
784      */
785     function name() public view virtual override returns (string memory) {
786         return _name;
787     }
788 
789     /**
790      * @dev See {IERC721Metadata-symbol}.
791      */
792     function symbol() public view virtual override returns (string memory) {
793         return _symbol;
794     }
795 
796     /**
797      * @dev See {IERC721Metadata-tokenURI}.
798      */
799     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
800         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
801 
802         string memory baseURI = _baseURI();
803         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
804     }
805 
806     /**
807      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
808      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
809      * by default, can be overriden in child contracts.
810      */
811     function _baseURI() internal view virtual returns (string memory) {
812         return "";
813     }
814 
815     /**
816      * @dev See {IERC721-approve}.
817      */
818     function approve(address to, uint256 tokenId) public virtual override {
819         address owner = ERC721.ownerOf(tokenId);
820         require(to != owner, "ERC721: approval to current owner");
821 
822         require(
823             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
824             "ERC721: approve caller is not owner nor approved for all"
825         );
826 
827         _approve(to, tokenId);
828     }
829 
830     /**
831      * @dev See {IERC721-getApproved}.
832      */
833     function getApproved(uint256 tokenId) public view virtual override returns (address) {
834         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
835 
836         return _tokenApprovals[tokenId];
837     }
838 
839     /**
840      * @dev See {IERC721-setApprovalForAll}.
841      */
842     function setApprovalForAll(address operator, bool approved) public virtual override {
843         require(operator != _msgSender(), "ERC721: approve to caller");
844 
845         _operatorApprovals[_msgSender()][operator] = approved;
846         emit ApprovalForAll(_msgSender(), operator, approved);
847     }
848 
849     /**
850      * @dev See {IERC721-isApprovedForAll}.
851      */
852     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
853         return _operatorApprovals[owner][operator];
854     }
855 
856     /**
857      * @dev See {IERC721-transferFrom}.
858      */
859     function transferFrom(
860         address from,
861         address to,
862         uint256 tokenId
863     ) public virtual override {
864         //solhint-disable-next-line max-line-length
865         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
866 
867         _transfer(from, to, tokenId);
868     }
869 
870     /**
871      * @dev See {IERC721-safeTransferFrom}.
872      */
873     function safeTransferFrom(
874         address from,
875         address to,
876         uint256 tokenId
877     ) public virtual override {
878         safeTransferFrom(from, to, tokenId, "");
879     }
880 
881     /**
882      * @dev See {IERC721-safeTransferFrom}.
883      */
884     function safeTransferFrom(
885         address from,
886         address to,
887         uint256 tokenId,
888         bytes memory _data
889     ) public virtual override {
890         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
891         _safeTransfer(from, to, tokenId, _data);
892     }
893 
894     /**
895      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
896      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
897      *
898      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
899      *
900      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
901      * implement alternative mechanisms to perform token transfer, such as signature-based.
902      *
903      * Requirements:
904      *
905      * - `from` cannot be the zero address.
906      * - `to` cannot be the zero address.
907      * - `tokenId` token must exist and be owned by `from`.
908      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _safeTransfer(
913         address from,
914         address to,
915         uint256 tokenId,
916         bytes memory _data
917     ) internal virtual {
918         _transfer(from, to, tokenId);
919         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
920     }
921 
922     /**
923      * @dev Returns whether `tokenId` exists.
924      *
925      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
926      *
927      * Tokens start existing when they are minted (`_mint`),
928      * and stop existing when they are burned (`_burn`).
929      */
930     function _exists(uint256 tokenId) internal view virtual returns (bool) {
931         return _owners[tokenId] != address(0);
932     }
933 
934     /**
935      * @dev Returns whether `spender` is allowed to manage `tokenId`.
936      *
937      * Requirements:
938      *
939      * - `tokenId` must exist.
940      */
941     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
942         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
943         address owner = ERC721.ownerOf(tokenId);
944         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
945     }
946 
947     /**
948      * @dev Safely mints `tokenId` and transfers it to `to`.
949      *
950      * Requirements:
951      *
952      * - `tokenId` must not exist.
953      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
954      *
955      * Emits a {Transfer} event.
956      */
957     function _safeMint(address to, uint256 tokenId) internal virtual {
958         _safeMint(to, tokenId, "");
959     }
960 
961     /**
962      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
963      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
964      */
965     function _safeMint(
966         address to,
967         uint256 tokenId,
968         bytes memory _data
969     ) internal virtual {
970         _mint(to, tokenId);
971         require(
972             _checkOnERC721Received(address(0), to, tokenId, _data),
973             "ERC721: transfer to non ERC721Receiver implementer"
974         );
975     }
976 
977     /**
978      * @dev Mints `tokenId` and transfers it to `to`.
979      *
980      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
981      *
982      * Requirements:
983      *
984      * - `tokenId` must not exist.
985      * - `to` cannot be the zero address.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _mint(address to, uint256 tokenId) internal virtual {
990         require(to != address(0), "ERC721: mint to the zero address");
991         require(!_exists(tokenId), "ERC721: token already minted");
992 
993         _beforeTokenTransfer(address(0), to, tokenId);
994 
995         _balances[to] += 1;
996         _owners[tokenId] = to;
997 
998         emit Transfer(address(0), to, tokenId);
999     }
1000 
1001     /**
1002      * @dev Destroys `tokenId`.
1003      * The approval is cleared when the token is burned.
1004      *
1005      * Requirements:
1006      *
1007      * - `tokenId` must exist.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _burn(uint256 tokenId) internal virtual {
1012         address owner = ERC721.ownerOf(tokenId);
1013 
1014         _beforeTokenTransfer(owner, address(0), tokenId);
1015 
1016         // Clear approvals
1017         _approve(address(0), tokenId);
1018 
1019         _balances[owner] -= 1;
1020         delete _owners[tokenId];
1021 
1022         emit Transfer(owner, address(0), tokenId);
1023     }
1024 
1025     /**
1026      * @dev Transfers `tokenId` from `from` to `to`.
1027      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1028      *
1029      * Requirements:
1030      *
1031      * - `to` cannot be the zero address.
1032      * - `tokenId` token must be owned by `from`.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function _transfer(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) internal virtual {
1041         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1042         require(to != address(0), "ERC721: transfer to the zero address");
1043 
1044         _beforeTokenTransfer(from, to, tokenId);
1045 
1046         // Clear approvals from the previous owner
1047         _approve(address(0), tokenId);
1048 
1049         _balances[from] -= 1;
1050         _balances[to] += 1;
1051         _owners[tokenId] = to;
1052 
1053         emit Transfer(from, to, tokenId);
1054     }
1055 
1056     /**
1057      * @dev Approve `to` to operate on `tokenId`
1058      *
1059      * Emits a {Approval} event.
1060      */
1061     function _approve(address to, uint256 tokenId) internal virtual {
1062         _tokenApprovals[tokenId] = to;
1063         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1064     }
1065 
1066     /**
1067      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1068      * The call is not executed if the target address is not a contract.
1069      *
1070      * @param from address representing the previous owner of the given token ID
1071      * @param to target address that will receive the tokens
1072      * @param tokenId uint256 ID of the token to be transferred
1073      * @param _data bytes optional data to send along with the call
1074      * @return bool whether the call correctly returned the expected magic value
1075      */
1076     function _checkOnERC721Received(
1077         address from,
1078         address to,
1079         uint256 tokenId,
1080         bytes memory _data
1081     ) private returns (bool) {
1082         if (to.isContract()) {
1083             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1084                 return retval == IERC721Receiver.onERC721Received.selector;
1085             } catch (bytes memory reason) {
1086                 if (reason.length == 0) {
1087                     revert("ERC721: transfer to non ERC721Receiver implementer");
1088                 } else {
1089                     assembly {
1090                         revert(add(32, reason), mload(reason))
1091                     }
1092                 }
1093             }
1094         } else {
1095             return true;
1096         }
1097     }
1098 
1099     /**
1100      * @dev Hook that is called before any token transfer. This includes minting
1101      * and burning.
1102      *
1103      * Calling conditions:
1104      *
1105      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1106      * transferred to `to`.
1107      * - When `from` is zero, `tokenId` will be minted for `to`.
1108      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1109      * - `from` and `to` are never both zero.
1110      *
1111      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1112      */
1113     function _beforeTokenTransfer(
1114         address from,
1115         address to,
1116         uint256 tokenId
1117     ) internal virtual {}
1118 }
1119 
1120 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1121 
1122 
1123 
1124 pragma solidity ^0.8.0;
1125 
1126 
1127 
1128 /**
1129  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1130  * enumerability of all the token ids in the contract as well as all token ids owned by each
1131  * account.
1132  */
1133 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1134     // Mapping from owner to list of owned token IDs
1135     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1136 
1137     // Mapping from token ID to index of the owner tokens list
1138     mapping(uint256 => uint256) private _ownedTokensIndex;
1139 
1140     // Array with all token ids, used for enumeration
1141     uint256[] private _allTokens;
1142 
1143     // Mapping from token id to position in the allTokens array
1144     mapping(uint256 => uint256) private _allTokensIndex;
1145 
1146     /**
1147      * @dev See {IERC165-supportsInterface}.
1148      */
1149     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1150         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1151     }
1152 
1153     /**
1154      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1155      */
1156     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1157         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1158         return _ownedTokens[owner][index];
1159     }
1160 
1161     /**
1162      * @dev See {IERC721Enumerable-totalSupply}.
1163      */
1164     function totalSupply() public view virtual override returns (uint256) {
1165         return _allTokens.length;
1166     }
1167 
1168     /**
1169      * @dev See {IERC721Enumerable-tokenByIndex}.
1170      */
1171     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1172         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1173         return _allTokens[index];
1174     }
1175 
1176     /**
1177      * @dev Hook that is called before any token transfer. This includes minting
1178      * and burning.
1179      *
1180      * Calling conditions:
1181      *
1182      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1183      * transferred to `to`.
1184      * - When `from` is zero, `tokenId` will be minted for `to`.
1185      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1186      * - `from` cannot be the zero address.
1187      * - `to` cannot be the zero address.
1188      *
1189      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1190      */
1191     function _beforeTokenTransfer(
1192         address from,
1193         address to,
1194         uint256 tokenId
1195     ) internal virtual override {
1196         super._beforeTokenTransfer(from, to, tokenId);
1197 
1198         if (from == address(0)) {
1199             _addTokenToAllTokensEnumeration(tokenId);
1200         } else if (from != to) {
1201             _removeTokenFromOwnerEnumeration(from, tokenId);
1202         }
1203         if (to == address(0)) {
1204             _removeTokenFromAllTokensEnumeration(tokenId);
1205         } else if (to != from) {
1206             _addTokenToOwnerEnumeration(to, tokenId);
1207         }
1208     }
1209 
1210     /**
1211      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1212      * @param to address representing the new owner of the given token ID
1213      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1214      */
1215     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1216         uint256 length = ERC721.balanceOf(to);
1217         _ownedTokens[to][length] = tokenId;
1218         _ownedTokensIndex[tokenId] = length;
1219     }
1220 
1221     /**
1222      * @dev Private function to add a token to this extension's token tracking data structures.
1223      * @param tokenId uint256 ID of the token to be added to the tokens list
1224      */
1225     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1226         _allTokensIndex[tokenId] = _allTokens.length;
1227         _allTokens.push(tokenId);
1228     }
1229 
1230     /**
1231      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1232      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1233      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1234      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1235      * @param from address representing the previous owner of the given token ID
1236      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1237      */
1238     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1239         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1240         // then delete the last slot (swap and pop).
1241 
1242         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1243         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1244 
1245         // When the token to delete is the last token, the swap operation is unnecessary
1246         if (tokenIndex != lastTokenIndex) {
1247             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1248 
1249             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1250             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1251         }
1252 
1253         // This also deletes the contents at the last position of the array
1254         delete _ownedTokensIndex[tokenId];
1255         delete _ownedTokens[from][lastTokenIndex];
1256     }
1257 
1258     /**
1259      * @dev Private function to remove a token from this extension's token tracking data structures.
1260      * This has O(1) time complexity, but alters the order of the _allTokens array.
1261      * @param tokenId uint256 ID of the token to be removed from the tokens list
1262      */
1263     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1264         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1265         // then delete the last slot (swap and pop).
1266 
1267         uint256 lastTokenIndex = _allTokens.length - 1;
1268         uint256 tokenIndex = _allTokensIndex[tokenId];
1269 
1270         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1271         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1272         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1273         uint256 lastTokenId = _allTokens[lastTokenIndex];
1274 
1275         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1276         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1277 
1278         // This also deletes the contents at the last position of the array
1279         delete _allTokensIndex[tokenId];
1280         _allTokens.pop();
1281     }
1282 }
1283 
1284 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1285 
1286 
1287 
1288 pragma solidity ^0.8.0;
1289 
1290 /**
1291  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1292  *
1293  * These functions can be used to verify that a message was signed by the holder
1294  * of the private keys of a given address.
1295  */
1296 library ECDSA {
1297     enum RecoverError {
1298         NoError,
1299         InvalidSignature,
1300         InvalidSignatureLength,
1301         InvalidSignatureS,
1302         InvalidSignatureV
1303     }
1304 
1305     function _throwError(RecoverError error) private pure {
1306         if (error == RecoverError.NoError) {
1307             return; // no error: do nothing
1308         } else if (error == RecoverError.InvalidSignature) {
1309             revert("ECDSA: invalid signature");
1310         } else if (error == RecoverError.InvalidSignatureLength) {
1311             revert("ECDSA: invalid signature length");
1312         } else if (error == RecoverError.InvalidSignatureS) {
1313             revert("ECDSA: invalid signature 's' value");
1314         } else if (error == RecoverError.InvalidSignatureV) {
1315             revert("ECDSA: invalid signature 'v' value");
1316         }
1317     }
1318 
1319     /**
1320      * @dev Returns the address that signed a hashed message (`hash`) with
1321      * `signature` or error string. This address can then be used for verification purposes.
1322      *
1323      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1324      * this function rejects them by requiring the `s` value to be in the lower
1325      * half order, and the `v` value to be either 27 or 28.
1326      *
1327      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1328      * verification to be secure: it is possible to craft signatures that
1329      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1330      * this is by receiving a hash of the original message (which may otherwise
1331      * be too long), and then calling {toEthSignedMessageHash} on it.
1332      *
1333      * Documentation for signature generation:
1334      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1335      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1336      *
1337      * _Available since v4.3._
1338      */
1339     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1340         // Check the signature length
1341         // - case 65: r,s,v signature (standard)
1342         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1343         if (signature.length == 65) {
1344             bytes32 r;
1345             bytes32 s;
1346             uint8 v;
1347             // ecrecover takes the signature parameters, and the only way to get them
1348             // currently is to use assembly.
1349             assembly {
1350                 r := mload(add(signature, 0x20))
1351                 s := mload(add(signature, 0x40))
1352                 v := byte(0, mload(add(signature, 0x60)))
1353             }
1354             return tryRecover(hash, v, r, s);
1355         } else if (signature.length == 64) {
1356             bytes32 r;
1357             bytes32 vs;
1358             // ecrecover takes the signature parameters, and the only way to get them
1359             // currently is to use assembly.
1360             assembly {
1361                 r := mload(add(signature, 0x20))
1362                 vs := mload(add(signature, 0x40))
1363             }
1364             return tryRecover(hash, r, vs);
1365         } else {
1366             return (address(0), RecoverError.InvalidSignatureLength);
1367         }
1368     }
1369 
1370     /**
1371      * @dev Returns the address that signed a hashed message (`hash`) with
1372      * `signature`. This address can then be used for verification purposes.
1373      *
1374      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1375      * this function rejects them by requiring the `s` value to be in the lower
1376      * half order, and the `v` value to be either 27 or 28.
1377      *
1378      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1379      * verification to be secure: it is possible to craft signatures that
1380      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1381      * this is by receiving a hash of the original message (which may otherwise
1382      * be too long), and then calling {toEthSignedMessageHash} on it.
1383      */
1384     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1385         (address recovered, RecoverError error) = tryRecover(hash, signature);
1386         _throwError(error);
1387         return recovered;
1388     }
1389 
1390     /**
1391      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1392      *
1393      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1394      *
1395      * _Available since v4.3._
1396      */
1397     function tryRecover(
1398         bytes32 hash,
1399         bytes32 r,
1400         bytes32 vs
1401     ) internal pure returns (address, RecoverError) {
1402         bytes32 s;
1403         uint8 v;
1404         assembly {
1405             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1406             v := add(shr(255, vs), 27)
1407         }
1408         return tryRecover(hash, v, r, s);
1409     }
1410 
1411     /**
1412      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1413      *
1414      * _Available since v4.2._
1415      */
1416     function recover(
1417         bytes32 hash,
1418         bytes32 r,
1419         bytes32 vs
1420     ) internal pure returns (address) {
1421         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1422         _throwError(error);
1423         return recovered;
1424     }
1425 
1426     /**
1427      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1428      * `r` and `s` signature fields separately.
1429      *
1430      * _Available since v4.3._
1431      */
1432     function tryRecover(
1433         bytes32 hash,
1434         uint8 v,
1435         bytes32 r,
1436         bytes32 s
1437     ) internal pure returns (address, RecoverError) {
1438         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1439         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1440         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1441         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1442         //
1443         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1444         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1445         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1446         // these malleable signatures as well.
1447         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1448             return (address(0), RecoverError.InvalidSignatureS);
1449         }
1450         if (v != 27 && v != 28) {
1451             return (address(0), RecoverError.InvalidSignatureV);
1452         }
1453 
1454         // If the signature is valid (and not malleable), return the signer address
1455         address signer = ecrecover(hash, v, r, s);
1456         if (signer == address(0)) {
1457             return (address(0), RecoverError.InvalidSignature);
1458         }
1459 
1460         return (signer, RecoverError.NoError);
1461     }
1462 
1463     /**
1464      * @dev Overload of {ECDSA-recover} that receives the `v`,
1465      * `r` and `s` signature fields separately.
1466      */
1467     function recover(
1468         bytes32 hash,
1469         uint8 v,
1470         bytes32 r,
1471         bytes32 s
1472     ) internal pure returns (address) {
1473         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1474         _throwError(error);
1475         return recovered;
1476     }
1477 
1478     /**
1479      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1480      * produces hash corresponding to the one signed with the
1481      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1482      * JSON-RPC method as part of EIP-191.
1483      *
1484      * See {recover}.
1485      */
1486     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1487         // 32 is the length in bytes of hash,
1488         // enforced by the type signature above
1489         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1490     }
1491 
1492     /**
1493      * @dev Returns an Ethereum Signed Typed Data, created from a
1494      * `domainSeparator` and a `structHash`. This produces hash corresponding
1495      * to the one signed with the
1496      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1497      * JSON-RPC method as part of EIP-712.
1498      *
1499      * See {recover}.
1500      */
1501     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1502         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1503     }
1504 }
1505 
1506 // File: contracts/crayonCodes.sol
1507 
1508 
1509 pragma solidity 0.8.10;
1510 
1511 
1512 
1513 
1514 
1515 
1516 contract Authorizable is Ownable {
1517     address public trustee;
1518 
1519     constructor() {
1520         trustee = address(0x0);
1521     }
1522 
1523     modifier onlyAuthorized() {
1524         require(msg.sender == trustee || msg.sender == owner());
1525         _;
1526     }
1527 
1528     function setTrustee(address newTrustee_) external onlyOwner {
1529         trustee = newTrustee_;
1530 
1531         emit TrusteeChanged(newTrustee_);
1532     }
1533 
1534     event TrusteeChanged(address newTrustee);
1535 }
1536 
1537 contract CrayonCodes is ERC721Enumerable, Authorizable, IERC2981 {
1538     using Strings for uint256;
1539 
1540     address public royaltyPayoutAddress;
1541     bool public isMintable = true;
1542 
1543     struct Token {
1544         uint32 artistID;
1545         uint32 crayonID;
1546         uint32 editionNumber;
1547         uint32 royaltyAggBPS;
1548         address artist;
1549         string ipfsCID;
1550     }
1551 
1552     mapping(uint256 => Token) public tokens; // tokenID => Token
1553     mapping(uint256 => uint256[]) public tokensByCrayonID; // crayonID => tokenID
1554     mapping(uint256 => uint256[]) public tokensByArtistID; // artistID => tokenID
1555 
1556     string private _contractURI;
1557     string public tokenBaseURI;
1558 
1559     constructor(
1560         string memory title_,
1561         string memory symbol_,
1562         string memory contractURI_,
1563         string memory tokenBaseURI_,
1564         address royaltyPayoutAddress_
1565     ) ERC721(title_, symbol_) {
1566         require(royaltyPayoutAddress_ != address(0), "invalid payout address");
1567         _contractURI = contractURI_;
1568         tokenBaseURI = tokenBaseURI_;
1569         royaltyPayoutAddress = royaltyPayoutAddress_;
1570     }
1571 
1572     /// @notice isValidRequest validates a message by ecrecover to ensure
1573     //          it is signed by either the contract owner or a trustee
1574     //          who is set by the contract owner.
1575     /// @param message_ - the raw message for signing
1576     /// @param r_ - part of signature for validating parameters integrity
1577     /// @param s_ - part of signature for validating parameters integrity
1578     /// @param v_ - part of signature for validating parameters integrity
1579     function isValidRequest(
1580         bytes32 message_,
1581         bytes32 r_,
1582         bytes32 s_,
1583         uint8 v_
1584     ) internal view returns (bool authorized) {
1585         address signer = ECDSA.recover(
1586             ECDSA.toEthSignedMessageHash(message_),
1587             v_,
1588             r_,
1589             s_
1590         );
1591         authorized = signer == trustee || signer == owner();
1592     }
1593 
1594     /// @notice Call to update the minting status
1595     function setMintable(bool isMintable_) external onlyAuthorized {
1596         isMintable = isMintable_;
1597     }
1598 
1599     /// @notice Call to update the royaltyPayoutAddress
1600     function setRoyaltyPayoutAddress(address payoutAddress_)
1601         external
1602         onlyAuthorized
1603     {
1604         require(payoutAddress_ != address(0), "invalid payout address");
1605         royaltyPayoutAddress = payoutAddress_;
1606     }
1607 
1608     /// @notice Called with a valid signatures and parameters to mint a new
1609     //          token. The signature is to ensure the request is authorized.
1610     /// @param r_ - part of signature for validating parameters integrity
1611     /// @param s_ - part of signature for validating parameters integrity
1612     /// @param v_ - part of signature for validating parameters integrity
1613     /// @param userID_ - the user id of the NFT asset
1614     /// @param crayonID_ - the visual id of the NFT asset
1615     /// @param editionNumber_ - the edition number of the NFT asset
1616     /// @param royaltyAggBPS_ - the aggregated BPS for the royalty payment of the NFT asset
1617     /// @param ipfsCid_ - the ipfs cid of a token
1618     function authorizedMint(
1619         bytes32 r_,
1620         bytes32 s_,
1621         uint8 v_,
1622         uint32 userID_,
1623         uint32 crayonID_,
1624         uint32 editionNumber_,
1625         uint32 royaltyAggBPS_,
1626         address artist_,
1627         string calldata ipfsCid_
1628     ) external {
1629         require(isMintable, "minting process is forbidden");
1630 
1631         bytes32 requestHash = keccak256(
1632             abi.encode(
1633                 msg.sender,
1634                 userID_,
1635                 crayonID_,
1636                 editionNumber_,
1637                 royaltyAggBPS_,
1638                 artist_,
1639                 ipfsCid_
1640             )
1641         );
1642 
1643         require(
1644             isValidRequest(requestHash, r_, s_, v_),
1645             "the minting request is not authorized"
1646         );
1647 
1648         uint256 tokenID = uint256(crayonID_) *
1649             100_000 +
1650             uint256(editionNumber_);
1651 
1652         Token memory token = Token(
1653             userID_,
1654             crayonID_,
1655             editionNumber_,
1656             royaltyAggBPS_,
1657             artist_,
1658             ipfsCid_
1659         );
1660         
1661         tokensByArtistID[userID_].push(tokenID);
1662         tokensByCrayonID[crayonID_].push(tokenID);
1663         tokens[tokenID] = token;
1664 
1665         _safeMint(artist_, tokenID);
1666         _safeTransfer(artist_, msg.sender, tokenID, "");
1667     }
1668     
1669     
1670     /// @notice Get the artist address of the given token
1671     /// @param tokenId_ - queried tokenId
1672     /// @return artist - artist of the token
1673     function artistOf(uint256 tokenId_)
1674         external
1675         view
1676         returns (address artist)
1677     {
1678          require(
1679             _exists(tokenId_),
1680             "Token not found"
1681         );
1682         artist = tokens[tokenId_].artist;
1683     }
1684     
1685     /// @notice Get the artist address of the given token
1686     /// @param crayonId_ - queried crayonId_
1687     /// @return tokenIds - list of tokens of this crayon
1688     function getTokensByCrayonID(uint256 crayonId_)
1689         external
1690         view
1691         returns (uint256 [] memory tokenIds)
1692     {
1693         tokenIds = tokensByCrayonID[crayonId_];
1694     }
1695     
1696     /// @notice Get the artist address of the given token
1697     /// @param artistID_ - queried userId_
1698     /// @return tokenIds - list of tokens of this crayon
1699     function getTokensByArtistID(uint256 artistID_)
1700         external
1701         view
1702         returns (uint256 [] memory tokenIds)
1703     {
1704         tokenIds = tokensByArtistID[artistID_];
1705     }
1706     
1707     /// @notice Burn given token
1708     /// @param tokenId_ - queried tokenId_
1709     function burn(uint256 tokenId_)
1710     external
1711       {
1712         require(_isApprovedOrOwner(msg.sender, tokenId_), "Not authorized");
1713         _burn(tokenId_);
1714       }
1715     
1716 
1717     /// @notice Called with the sale price to determine how much royalty
1718     //          is owed and to whom.
1719     /// @param tokenId_ - the NFT asset queried for royalty information
1720     /// @param salePrice_ - the sale price of the NFT asset specified by tokenId_
1721     /// @return receiver - address of who should be sent the royalty payment
1722     /// @return royaltyAmount - the royalty payment amount for salePrice_
1723     function royaltyInfo(uint256 tokenId_, uint256 salePrice_)
1724         external
1725         view
1726         override
1727         returns (address receiver, uint256 royaltyAmount)
1728     {
1729         require(
1730             _exists(tokenId_),
1731             "IERC2981: royalty info query for nonexistent token"
1732         );
1733         Token memory token = tokens[tokenId_];
1734 
1735         receiver = royaltyPayoutAddress;
1736         royaltyAmount =
1737             (salePrice_ * uint256(token.royaltyAggBPS)) / 100_00;
1738     }
1739 
1740 
1741     /// @notice Update the base token uri
1742     /// @param baseURI_ - the base tokne uri
1743     function setTokenBaseURI(string memory baseURI_) external onlyAuthorized {
1744         tokenBaseURI = baseURI_;
1745     }
1746     
1747     function _baseURI() internal view virtual override returns (string memory) {
1748         return tokenBaseURI;
1749     }
1750     
1751     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
1752     function tokenURI(uint256 tokenId_)
1753         public
1754         view
1755         virtual
1756         override
1757         returns (string memory)
1758     {
1759         require(
1760             _exists(tokenId_),
1761             "ERC721Metadata: URI query for nonexistent token"
1762         );
1763 
1764         string memory ipfsID = tokens[tokenId_].ipfsCID;
1765 
1766         return string(abi.encodePacked(_baseURI(), ipfsID));
1767     }
1768 
1769     /// @notice Update the contract URI
1770     function setContractURI(string memory contractURI_)
1771         external
1772         onlyAuthorized
1773     {
1774         _contractURI = contractURI_;
1775     }
1776 
1777     /// @notice A URL for the opensea storefront-level metadata
1778     function contractURI() external view returns (string memory) {
1779         return _contractURI;
1780     }
1781 }