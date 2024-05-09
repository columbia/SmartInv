1 // File: contracts/utils/Strings.sol
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
57     function toHexString(uint256 value, uint256 length)
58         internal
59         pure
60         returns (string memory)
61     {
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
74 // File: contracts/utils/Context.sol
75 
76 
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Provides information about the current execution context, including the
82  * sender of the transaction and its data. While these are generally available
83  * via msg.sender and msg.data, they should not be accessed in such a direct
84  * manner, since when dealing with meta-transactions the account sending and
85  * paying for execution may not be the actual sender (as far as an application
86  * is concerned).
87  *
88  * This contract is only required for intermediate, library-like contracts.
89  */
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 // File: contracts/access/Ownable.sol
101 
102 
103 
104 pragma solidity ^0.8.0;
105 
106 
107 /**
108  * @dev Contract module which provides a basic access control mechanism, where
109  * there is an account (an owner) that can be granted exclusive access to
110  * specific functions.
111  *
112  * By default, the owner account will be the one that deploys the contract. This
113  * can later be changed with {transferOwnership}.
114  *
115  * This module is used through inheritance. It will make available the modifier
116  * `onlyOwner`, which can be applied to your functions to restrict their use to
117  * the owner.
118  */
119 abstract contract Ownable is Context {
120     address private _owner;
121 
122     event OwnershipTransferred(
123         address indexed previousOwner,
124         address indexed newOwner
125     );
126 
127     /**
128      * @dev Initializes the contract setting the deployer as the initial owner.
129      */
130     constructor() {
131         _setOwner(_msgSender());
132     }
133 
134     /**
135      * @dev Returns the address of the current owner.
136      */
137     function owner() public view virtual returns (address) {
138         return _owner;
139     }
140 
141     /**
142      * @dev Throws if called by any account other than the owner.
143      */
144     modifier onlyOwner() {
145         require(owner() == _msgSender(), "Ownable: caller is not the owner");
146         _;
147     }
148 
149     /**
150      * @dev Leaves the contract without owner. It will not be possible to call
151      * `onlyOwner` functions anymore. Can only be called by the current owner.
152      *
153      * NOTE: Renouncing ownership will leave the contract without an owner,
154      * thereby removing any functionality that is only available to the owner.
155      */
156     function renounceOwnership() public virtual onlyOwner {
157         _setOwner(address(0));
158     }
159 
160     /**
161      * @dev Transfers ownership of the contract to a new account (`newOwner`).
162      * Can only be called by the current owner.
163      */
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(
166             newOwner != address(0),
167             "Ownable: new owner is the zero address"
168         );
169         _setOwner(newOwner);
170     }
171 
172     function _setOwner(address newOwner) private {
173         address oldOwner = _owner;
174         _owner = newOwner;
175         emit OwnershipTransferred(oldOwner, newOwner);
176     }
177 }
178 
179 // File: contracts/utils/Address.sol
180 
181 
182 
183 pragma solidity ^0.8.0;
184 
185 /**
186  * @dev Collection of functions related to the address type
187  */
188 library Address {
189     /**
190      * @dev Returns true if `account` is a contract.
191      *
192      * [IMPORTANT]
193      * ====
194      * It is unsafe to assume that an address for which this function returns
195      * false is an externally-owned account (EOA) and not a contract.
196      *
197      * Among others, `isContract` will return false for the following
198      * types of addresses:
199      *
200      *  - an externally-owned account
201      *  - a contract in construction
202      *  - an address where a contract will be created
203      *  - an address where a contract lived, but was destroyed
204      * ====
205      */
206     function isContract(address account) internal view returns (bool) {
207         // This method relies on extcodesize, which returns 0 for contracts in
208         // construction, since the code is only stored at the end of the
209         // constructor execution.
210 
211         uint256 size;
212         assembly {
213             size := extcodesize(account)
214         }
215         return size > 0;
216     }
217 
218     /**
219      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
220      * `recipient`, forwarding all available gas and reverting on errors.
221      *
222      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
223      * of certain opcodes, possibly making contracts go over the 2300 gas limit
224      * imposed by `transfer`, making them unable to receive funds via
225      * `transfer`. {sendValue} removes this limitation.
226      *
227      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
228      *
229      * IMPORTANT: because control is transferred to `recipient`, care must be
230      * taken to not create reentrancy vulnerabilities. Consider using
231      * {ReentrancyGuard} or the
232      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
233      */
234     function sendValue(address payable recipient, uint256 amount) internal {
235         require(
236             address(this).balance >= amount,
237             "Address: insufficient balance"
238         );
239 
240         (bool success, ) = recipient.call{value: amount}("");
241         require(
242             success,
243             "Address: unable to send value, recipient may have reverted"
244         );
245     }
246 
247     /**
248      * @dev Performs a Solidity function call using a low level `call`. A
249      * plain `call` is an unsafe replacement for a function call: use this
250      * function instead.
251      *
252      * If `target` reverts with a revert reason, it is bubbled up by this
253      * function (like regular Solidity function calls).
254      *
255      * Returns the raw returned data. To convert to the expected return value,
256      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
257      *
258      * Requirements:
259      *
260      * - `target` must be a contract.
261      * - calling `target` with `data` must not revert.
262      *
263      * _Available since v3.1._
264      */
265     function functionCall(address target, bytes memory data)
266         internal
267         returns (bytes memory)
268     {
269         return functionCall(target, data, "Address: low-level call failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
274      * `errorMessage` as a fallback revert reason when `target` reverts.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal returns (bytes memory) {
283         return functionCallWithValue(target, data, 0, errorMessage);
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
288      * but also transferring `value` wei to `target`.
289      *
290      * Requirements:
291      *
292      * - the calling contract must have an ETH balance of at least `value`.
293      * - the called Solidity function must be `payable`.
294      *
295      * _Available since v3.1._
296      */
297     function functionCallWithValue(
298         address target,
299         bytes memory data,
300         uint256 value
301     ) internal returns (bytes memory) {
302         return
303             functionCallWithValue(
304                 target,
305                 data,
306                 value,
307                 "Address: low-level call with value failed"
308             );
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
313      * with `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     function functionCallWithValue(
318         address target,
319         bytes memory data,
320         uint256 value,
321         string memory errorMessage
322     ) internal returns (bytes memory) {
323         require(
324             address(this).balance >= value,
325             "Address: insufficient balance for call"
326         );
327         require(isContract(target), "Address: call to non-contract");
328 
329         (bool success, bytes memory returndata) = target.call{value: value}(
330             data
331         );
332         return verifyCallResult(success, returndata, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but performing a static call.
338      *
339      * _Available since v3.3._
340      */
341     function functionStaticCall(address target, bytes memory data)
342         internal
343         view
344         returns (bytes memory)
345     {
346         return
347             functionStaticCall(
348                 target,
349                 data,
350                 "Address: low-level static call failed"
351             );
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
356      * but performing a static call.
357      *
358      * _Available since v3.3._
359      */
360     function functionStaticCall(
361         address target,
362         bytes memory data,
363         string memory errorMessage
364     ) internal view returns (bytes memory) {
365         require(isContract(target), "Address: static call to non-contract");
366 
367         (bool success, bytes memory returndata) = target.staticcall(data);
368         return verifyCallResult(success, returndata, errorMessage);
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
373      * but performing a delegate call.
374      *
375      * _Available since v3.4._
376      */
377     function functionDelegateCall(address target, bytes memory data)
378         internal
379         returns (bytes memory)
380     {
381         return
382             functionDelegateCall(
383                 target,
384                 data,
385                 "Address: low-level delegate call failed"
386             );
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
391      * but performing a delegate call.
392      *
393      * _Available since v3.4._
394      */
395     function functionDelegateCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         require(isContract(target), "Address: delegate call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.delegatecall(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
408      * revert reason using the provided one.
409      *
410      * _Available since v4.3._
411      */
412     function verifyCallResult(
413         bool success,
414         bytes memory returndata,
415         string memory errorMessage
416     ) internal pure returns (bytes memory) {
417         if (success) {
418             return returndata;
419         } else {
420             // Look for revert reason and bubble it up if present
421             if (returndata.length > 0) {
422                 // The easiest way to bubble the revert reason is using memory via assembly
423 
424                 assembly {
425                     let returndata_size := mload(returndata)
426                     revert(add(32, returndata), returndata_size)
427                 }
428             } else {
429                 revert(errorMessage);
430             }
431         }
432     }
433 }
434 
435 // File: contracts/token/ERC721/IERC721Receiver.sol
436 
437 
438 
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @title ERC721 token receiver interface
443  * @dev Interface for any contract that wants to support safeTransfers
444  * from ERC721 asset contracts.
445  */
446 interface IERC721Receiver {
447     /**
448      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
449      * by `operator` from `from`, this function is called.
450      *
451      * It must return its Solidity selector to confirm the token transfer.
452      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
453      *
454      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
455      */
456     function onERC721Received(
457         address operator,
458         address from,
459         uint256 tokenId,
460         bytes calldata data
461     ) external returns (bytes4);
462 }
463 
464 // File: contracts/utils/introspection/IERC165.sol
465 
466 
467 
468 pragma solidity ^0.8.0;
469 
470 /**
471  * @dev Interface of the ERC165 standard, as defined in the
472  * https://eips.ethereum.org/EIPS/eip-165[EIP].
473  *
474  * Implementers can declare support of contract interfaces, which can then be
475  * queried by others ({ERC165Checker}).
476  *
477  * For an implementation, see {ERC165}.
478  */
479 interface IERC165 {
480     /**
481      * @dev Returns true if this contract implements the interface defined by
482      * `interfaceId`. See the corresponding
483      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
484      * to learn more about how these ids are created.
485      *
486      * This function call must use less than 30 000 gas.
487      */
488     function supportsInterface(bytes4 interfaceId) external view returns (bool);
489 }
490 
491 // File: contracts/utils/introspection/ERC165.sol
492 
493 
494 
495 pragma solidity ^0.8.0;
496 
497 
498 /**
499  * @dev Implementation of the {IERC165} interface.
500  *
501  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
502  * for the additional interface id that will be supported. For example:
503  *
504  * ```solidity
505  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
506  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
507  * }
508  * ```
509  *
510  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
511  */
512 abstract contract ERC165 is IERC165 {
513     /**
514      * @dev See {IERC165-supportsInterface}.
515      */
516     function supportsInterface(bytes4 interfaceId)
517         public
518         view
519         virtual
520         override
521         returns (bool)
522     {
523         return interfaceId == type(IERC165).interfaceId;
524     }
525 }
526 
527 // File: contracts/token/ERC721/IERC721.sol
528 
529 
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @dev Required interface of an ERC721 compliant contract.
536  */
537 interface IERC721 is IERC165 {
538     /**
539      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
540      */
541     event Transfer(
542         address indexed from,
543         address indexed to,
544         uint256 indexed tokenId
545     );
546 
547     /**
548      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
549      */
550     event Approval(
551         address indexed owner,
552         address indexed approved,
553         uint256 indexed tokenId
554     );
555 
556     /**
557      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
558      */
559     event ApprovalForAll(
560         address indexed owner,
561         address indexed operator,
562         bool approved
563     );
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
641     function getApproved(uint256 tokenId)
642         external
643         view
644         returns (address operator);
645 
646     /**
647      * @dev Approve or remove `operator` as an operator for the caller.
648      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
649      *
650      * Requirements:
651      *
652      * - The `operator` cannot be the caller.
653      *
654      * Emits an {ApprovalForAll} event.
655      */
656     function setApprovalForAll(address operator, bool _approved) external;
657 
658     /**
659      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
660      *
661      * See {setApprovalForAll}
662      */
663     function isApprovedForAll(address owner, address operator)
664         external
665         view
666         returns (bool);
667 
668     /**
669      * @dev Safely transfers `tokenId` token from `from` to `to`.
670      *
671      * Requirements:
672      *
673      * - `from` cannot be the zero address.
674      * - `to` cannot be the zero address.
675      * - `tokenId` token must exist and be owned by `from`.
676      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
677      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
678      *
679      * Emits a {Transfer} event.
680      */
681     function safeTransferFrom(
682         address from,
683         address to,
684         uint256 tokenId,
685         bytes calldata data
686     ) external;
687 }
688 
689 // File: contracts/token/ERC721/extensions/IERC721Enumerable.sol
690 
691 
692 
693 pragma solidity ^0.8.0;
694 
695 
696 /**
697  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
698  * @dev See https://eips.ethereum.org/EIPS/eip-721
699  */
700 interface IERC721Enumerable is IERC721 {
701     /**
702      * @dev Returns the total amount of tokens stored by the contract.
703      */
704     function totalSupply() external view returns (uint256);
705 
706     /**
707      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
708      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
709      */
710     function tokenOfOwnerByIndex(address owner, uint256 index)
711         external
712         view
713         returns (uint256 tokenId);
714 
715     /**
716      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
717      * Use along with {totalSupply} to enumerate all tokens.
718      */
719     function tokenByIndex(uint256 index) external view returns (uint256);
720 }
721 
722 // File: contracts/token/ERC721/extensions/IERC721Metadata.sol
723 
724 
725 
726 pragma solidity ^0.8.0;
727 
728 
729 /**
730  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
731  * @dev See https://eips.ethereum.org/EIPS/eip-721
732  */
733 interface IERC721Metadata is IERC721 {
734     /**
735      * @dev Returns the token collection name.
736      */
737     function name() external view returns (string memory);
738 
739     /**
740      * @dev Returns the token collection symbol.
741      */
742     function symbol() external view returns (string memory);
743 
744     /**
745      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
746      */
747     function tokenURI(uint256 tokenId) external view returns (string memory);
748 }
749 
750 // File: contracts/token/ERC721/ERC721.sol
751 
752 
753 
754 pragma solidity ^0.8.0;
755 
756 
757 
758 
759 
760 
761 
762 
763 /**
764  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
765  * the Metadata extension, but not including the Enumerable extension, which is available separately as
766  * {ERC721Enumerable}.
767  */
768 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
769     using Address for address;
770     using Strings for uint256;
771 
772     // Token name
773     string private _name;
774 
775     // Token symbol
776     string private _symbol;
777 
778     // Mapping from token ID to owner address
779     mapping(uint256 => address) private _owners;
780 
781     // Mapping owner address to token count
782     mapping(address => uint256) private _balances;
783 
784     // Mapping from token ID to approved address
785     mapping(uint256 => address) private _tokenApprovals;
786 
787     // Mapping from owner to operator approvals
788     mapping(address => mapping(address => bool)) private _operatorApprovals;
789 
790     /**
791      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
792      */
793     constructor(string memory name_, string memory symbol_) {
794         _name = name_;
795         _symbol = symbol_;
796     }
797 
798     /**
799      * @dev See {IERC165-supportsInterface}.
800      */
801     function supportsInterface(bytes4 interfaceId)
802         public
803         view
804         virtual
805         override(ERC165, IERC165)
806         returns (bool)
807     {
808         return
809             interfaceId == type(IERC721).interfaceId ||
810             interfaceId == type(IERC721Metadata).interfaceId ||
811             super.supportsInterface(interfaceId);
812     }
813 
814     /**
815      * @dev See {IERC721-balanceOf}.
816      */
817     function balanceOf(address owner)
818         public
819         view
820         virtual
821         override
822         returns (uint256)
823     {
824         require(
825             owner != address(0),
826             "ERC721: balance query for the zero address"
827         );
828         return _balances[owner];
829     }
830 
831     /**
832      * @dev See {IERC721-ownerOf}.
833      */
834     function ownerOf(uint256 tokenId)
835         public
836         view
837         virtual
838         override
839         returns (address)
840     {
841         address owner = _owners[tokenId];
842         require(
843             owner != address(0),
844             "ERC721: owner query for nonexistent token"
845         );
846         return owner;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-name}.
851      */
852     function name() public view virtual override returns (string memory) {
853         return _name;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-symbol}.
858      */
859     function symbol() public view virtual override returns (string memory) {
860         return _symbol;
861     }
862 
863     /**
864      * @dev See {IERC721Metadata-tokenURI}.
865      */
866     function tokenURI(uint256 tokenId)
867         public
868         view
869         virtual
870         override
871         returns (string memory)
872     {
873         require(
874             _exists(tokenId),
875             "ERC721Metadata: URI query for nonexistent token"
876         );
877 
878         string memory baseURI = _baseURI();
879         return
880             bytes(baseURI).length > 0
881                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
882                 : "";
883     }
884 
885     /**
886      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
887      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
888      * by default, can be overriden in child contracts.
889      */
890     function _baseURI() internal view virtual returns (string memory) {
891         return "";
892     }
893 
894     /**
895      * @dev See {IERC721-approve}.
896      */
897     function approve(address to, uint256 tokenId) public virtual override {
898         address owner = ERC721.ownerOf(tokenId);
899         require(to != owner, "ERC721: approval to current owner");
900 
901         require(
902             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
903             "ERC721: approve caller is not owner nor approved for all"
904         );
905 
906         _approve(to, tokenId);
907     }
908 
909     /**
910      * @dev See {IERC721-getApproved}.
911      */
912     function getApproved(uint256 tokenId)
913         public
914         view
915         virtual
916         override
917         returns (address)
918     {
919         require(
920             _exists(tokenId),
921             "ERC721: approved query for nonexistent token"
922         );
923 
924         return _tokenApprovals[tokenId];
925     }
926 
927     /**
928      * @dev See {IERC721-setApprovalForAll}.
929      */
930     function setApprovalForAll(address operator, bool approved)
931         public
932         virtual
933         override
934     {
935         require(operator != _msgSender(), "ERC721: approve to caller");
936 
937         _operatorApprovals[_msgSender()][operator] = approved;
938         emit ApprovalForAll(_msgSender(), operator, approved);
939     }
940 
941     /**
942      * @dev See {IERC721-isApprovedForAll}.
943      */
944     function isApprovedForAll(address owner, address operator)
945         public
946         view
947         virtual
948         override
949         returns (bool)
950     {
951         return _operatorApprovals[owner][operator];
952     }
953 
954     /**
955      * @dev See {IERC721-transferFrom}.
956      */
957     function transferFrom(
958         address from,
959         address to,
960         uint256 tokenId
961     ) public virtual override {
962         //solhint-disable-next-line max-line-length
963         require(
964             _isApprovedOrOwner(_msgSender(), tokenId),
965             "ERC721: transfer caller is not owner nor approved"
966         );
967 
968         _transfer(from, to, tokenId);
969     }
970 
971     /**
972      * @dev See {IERC721-safeTransferFrom}.
973      */
974     function safeTransferFrom(
975         address from,
976         address to,
977         uint256 tokenId
978     ) public virtual override {
979         safeTransferFrom(from, to, tokenId, "");
980     }
981 
982     /**
983      * @dev See {IERC721-safeTransferFrom}.
984      */
985     function safeTransferFrom(
986         address from,
987         address to,
988         uint256 tokenId,
989         bytes memory _data
990     ) public virtual override {
991         require(
992             _isApprovedOrOwner(_msgSender(), tokenId),
993             "ERC721: transfer caller is not owner nor approved"
994         );
995         _safeTransfer(from, to, tokenId, _data);
996     }
997 
998     /**
999      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1000      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1001      *
1002      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1003      *
1004      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1005      * implement alternative mechanisms to perform token transfer, such as signature-based.
1006      *
1007      * Requirements:
1008      *
1009      * - `from` cannot be the zero address.
1010      * - `to` cannot be the zero address.
1011      * - `tokenId` token must exist and be owned by `from`.
1012      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function _safeTransfer(
1017         address from,
1018         address to,
1019         uint256 tokenId,
1020         bytes memory _data
1021     ) internal virtual {
1022         _transfer(from, to, tokenId);
1023         require(
1024             _checkOnERC721Received(from, to, tokenId, _data),
1025             "ERC721: transfer to non ERC721Receiver implementer"
1026         );
1027     }
1028 
1029     /**
1030      * @dev Returns whether `tokenId` exists.
1031      *
1032      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1033      *
1034      * Tokens start existing when they are minted (`_mint`),
1035      * and stop existing when they are burned (`_burn`).
1036      */
1037     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1038         return _owners[tokenId] != address(0);
1039     }
1040 
1041     /**
1042      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1043      *
1044      * Requirements:
1045      *
1046      * - `tokenId` must exist.
1047      */
1048     function _isApprovedOrOwner(address spender, uint256 tokenId)
1049         internal
1050         view
1051         virtual
1052         returns (bool)
1053     {
1054         require(
1055             _exists(tokenId),
1056             "ERC721: operator query for nonexistent token"
1057         );
1058         address owner = ERC721.ownerOf(tokenId);
1059         return (spender == owner ||
1060             getApproved(tokenId) == spender ||
1061             isApprovedForAll(owner, spender));
1062     }
1063 
1064     /**
1065      * @dev Safely mints `tokenId` and transfers it to `to`.
1066      *
1067      * Requirements:
1068      *
1069      * - `tokenId` must not exist.
1070      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _safeMint(address to, uint256 tokenId) internal virtual {
1075         _safeMint(to, tokenId, "");
1076     }
1077 
1078     /**
1079      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1080      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1081      */
1082     function _safeMint(
1083         address to,
1084         uint256 tokenId,
1085         bytes memory _data
1086     ) internal virtual {
1087         _mint(to, tokenId);
1088         require(
1089             _checkOnERC721Received(address(0), to, tokenId, _data),
1090             "ERC721: transfer to non ERC721Receiver implementer"
1091         );
1092     }
1093 
1094     /**
1095      * @dev Mints `tokenId` and transfers it to `to`.
1096      *
1097      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1098      *
1099      * Requirements:
1100      *
1101      * - `tokenId` must not exist.
1102      * - `to` cannot be the zero address.
1103      *
1104      * Emits a {Transfer} event.
1105      */
1106     function _mint(address to, uint256 tokenId) internal virtual {
1107         require(to != address(0), "ERC721: mint to the zero address");
1108         require(!_exists(tokenId), "ERC721: token already minted");
1109 
1110         _beforeTokenTransfer(address(0), to, tokenId);
1111 
1112         _balances[to] += 1;
1113         _owners[tokenId] = to;
1114 
1115         emit Transfer(address(0), to, tokenId);
1116     }
1117 
1118     /**
1119      * @dev Destroys `tokenId`.
1120      * The approval is cleared when the token is burned.
1121      *
1122      * Requirements:
1123      *
1124      * - `tokenId` must exist.
1125      *
1126      * Emits a {Transfer} event.
1127      */
1128     function _burn(uint256 tokenId) internal virtual {
1129         address owner = ERC721.ownerOf(tokenId);
1130 
1131         _beforeTokenTransfer(owner, address(0), tokenId);
1132 
1133         // Clear approvals
1134         _approve(address(0), tokenId);
1135 
1136         _balances[owner] -= 1;
1137         delete _owners[tokenId];
1138 
1139         emit Transfer(owner, address(0), tokenId);
1140     }
1141 
1142     /**
1143      * @dev Transfers `tokenId` from `from` to `to`.
1144      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1145      *
1146      * Requirements:
1147      *
1148      * - `to` cannot be the zero address.
1149      * - `tokenId` token must be owned by `from`.
1150      *
1151      * Emits a {Transfer} event.
1152      */
1153     function _transfer(
1154         address from,
1155         address to,
1156         uint256 tokenId
1157     ) internal virtual {
1158         require(
1159             ERC721.ownerOf(tokenId) == from,
1160             "ERC721: transfer of token that is not own"
1161         );
1162         require(to != address(0), "ERC721: transfer to the zero address");
1163 
1164         _beforeTokenTransfer(from, to, tokenId);
1165 
1166         // Clear approvals from the previous owner
1167         _approve(address(0), tokenId);
1168 
1169         _balances[from] -= 1;
1170         _balances[to] += 1;
1171         _owners[tokenId] = to;
1172 
1173         emit Transfer(from, to, tokenId);
1174     }
1175 
1176     /**
1177      * @dev Approve `to` to operate on `tokenId`
1178      *
1179      * Emits a {Approval} event.
1180      */
1181     function _approve(address to, uint256 tokenId) internal virtual {
1182         _tokenApprovals[tokenId] = to;
1183         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1184     }
1185 
1186     /**
1187      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1188      * The call is not executed if the target address is not a contract.
1189      *
1190      * @param from address representing the previous owner of the given token ID
1191      * @param to target address that will receive the tokens
1192      * @param tokenId uint256 ID of the token to be transferred
1193      * @param _data bytes optional data to send along with the call
1194      * @return bool whether the call correctly returned the expected magic value
1195      */
1196     function _checkOnERC721Received(
1197         address from,
1198         address to,
1199         uint256 tokenId,
1200         bytes memory _data
1201     ) private returns (bool) {
1202         if (to.isContract()) {
1203             try
1204                 IERC721Receiver(to).onERC721Received(
1205                     _msgSender(),
1206                     from,
1207                     tokenId,
1208                     _data
1209                 )
1210             returns (bytes4 retval) {
1211                 return retval == IERC721Receiver.onERC721Received.selector;
1212             } catch (bytes memory reason) {
1213                 if (reason.length == 0) {
1214                     revert(
1215                         "ERC721: transfer to non ERC721Receiver implementer"
1216                     );
1217                 } else {
1218                     assembly {
1219                         revert(add(32, reason), mload(reason))
1220                     }
1221                 }
1222             }
1223         } else {
1224             return true;
1225         }
1226     }
1227 
1228     /**
1229      * @dev Hook that is called before any token transfer. This includes minting
1230      * and burning.
1231      *
1232      * Calling conditions:
1233      *
1234      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1235      * transferred to `to`.
1236      * - When `from` is zero, `tokenId` will be minted for `to`.
1237      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1238      * - `from` and `to` are never both zero.
1239      *
1240      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1241      */
1242     function _beforeTokenTransfer(
1243         address from,
1244         address to,
1245         uint256 tokenId
1246     ) internal virtual {}
1247 }
1248 
1249 // File: contracts/token/ERC721/extensions/ERC721Enumerable.sol
1250 
1251 
1252 
1253 pragma solidity ^0.8.0;
1254 
1255 
1256 
1257 /**
1258  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1259  * enumerability of all the token ids in the contract as well as all token ids owned by each
1260  * account.
1261  */
1262 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1263     // Mapping from owner to list of owned token IDs
1264     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1265 
1266     // Mapping from token ID to index of the owner tokens list
1267     mapping(uint256 => uint256) private _ownedTokensIndex;
1268 
1269     // Array with all token ids, used for enumeration
1270     uint256[] private _allTokens;
1271 
1272     // Mapping from token id to position in the allTokens array
1273     mapping(uint256 => uint256) private _allTokensIndex;
1274 
1275     /**
1276      * @dev See {IERC165-supportsInterface}.
1277      */
1278     function supportsInterface(bytes4 interfaceId)
1279         public
1280         view
1281         virtual
1282         override(IERC165, ERC721)
1283         returns (bool)
1284     {
1285         return
1286             interfaceId == type(IERC721Enumerable).interfaceId ||
1287             super.supportsInterface(interfaceId);
1288     }
1289 
1290     /**
1291      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1292      */
1293     function tokenOfOwnerByIndex(address owner, uint256 index)
1294         public
1295         view
1296         virtual
1297         override
1298         returns (uint256)
1299     {
1300         require(
1301             index < ERC721.balanceOf(owner),
1302             "ERC721Enumerable: owner index out of bounds"
1303         );
1304         return _ownedTokens[owner][index];
1305     }
1306 
1307     /**
1308      * @dev See {IERC721Enumerable-totalSupply}.
1309      */
1310     function totalSupply() public view virtual override returns (uint256) {
1311         return _allTokens.length;
1312     }
1313 
1314     /**
1315      * @dev See {IERC721Enumerable-tokenByIndex}.
1316      */
1317     function tokenByIndex(uint256 index)
1318         public
1319         view
1320         virtual
1321         override
1322         returns (uint256)
1323     {
1324         require(
1325             index < ERC721Enumerable.totalSupply(),
1326             "ERC721Enumerable: global index out of bounds"
1327         );
1328         return _allTokens[index];
1329     }
1330 
1331     /**
1332      * @dev Hook that is called before any token transfer. This includes minting
1333      * and burning.
1334      *
1335      * Calling conditions:
1336      *
1337      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1338      * transferred to `to`.
1339      * - When `from` is zero, `tokenId` will be minted for `to`.
1340      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1341      * - `from` cannot be the zero address.
1342      * - `to` cannot be the zero address.
1343      *
1344      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1345      */
1346     function _beforeTokenTransfer(
1347         address from,
1348         address to,
1349         uint256 tokenId
1350     ) internal virtual override {
1351         super._beforeTokenTransfer(from, to, tokenId);
1352 
1353         if (from == address(0)) {
1354             _addTokenToAllTokensEnumeration(tokenId);
1355         } else if (from != to) {
1356             _removeTokenFromOwnerEnumeration(from, tokenId);
1357         }
1358         if (to == address(0)) {
1359             _removeTokenFromAllTokensEnumeration(tokenId);
1360         } else if (to != from) {
1361             _addTokenToOwnerEnumeration(to, tokenId);
1362         }
1363     }
1364 
1365     /**
1366      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1367      * @param to address representing the new owner of the given token ID
1368      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1369      */
1370     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1371         uint256 length = ERC721.balanceOf(to);
1372         _ownedTokens[to][length] = tokenId;
1373         _ownedTokensIndex[tokenId] = length;
1374     }
1375 
1376     /**
1377      * @dev Private function to add a token to this extension's token tracking data structures.
1378      * @param tokenId uint256 ID of the token to be added to the tokens list
1379      */
1380     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1381         _allTokensIndex[tokenId] = _allTokens.length;
1382         _allTokens.push(tokenId);
1383     }
1384 
1385     /**
1386      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1387      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1388      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1389      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1390      * @param from address representing the previous owner of the given token ID
1391      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1392      */
1393     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1394         private
1395     {
1396         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1397         // then delete the last slot (swap and pop).
1398 
1399         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1400         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1401 
1402         // When the token to delete is the last token, the swap operation is unnecessary
1403         if (tokenIndex != lastTokenIndex) {
1404             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1405 
1406             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1407             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1408         }
1409 
1410         // This also deletes the contents at the last position of the array
1411         delete _ownedTokensIndex[tokenId];
1412         delete _ownedTokens[from][lastTokenIndex];
1413     }
1414 
1415     /**
1416      * @dev Private function to remove a token from this extension's token tracking data structures.
1417      * This has O(1) time complexity, but alters the order of the _allTokens array.
1418      * @param tokenId uint256 ID of the token to be removed from the tokens list
1419      */
1420     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1421         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1422         // then delete the last slot (swap and pop).
1423 
1424         uint256 lastTokenIndex = _allTokens.length - 1;
1425         uint256 tokenIndex = _allTokensIndex[tokenId];
1426 
1427         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1428         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1429         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1430         uint256 lastTokenId = _allTokens[lastTokenIndex];
1431 
1432         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1433         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1434 
1435         // This also deletes the contents at the last position of the array
1436         delete _allTokensIndex[tokenId];
1437         _allTokens.pop();
1438     }
1439 }
1440 
1441 // File: witlink.sol
1442 
1443 //SPDX-License-Identifier: MIT
1444 
1445 pragma solidity ^0.8.7;
1446 
1447 
1448 
1449 contract WitLink is ERC721Enumerable, Ownable {
1450     using Strings for uint256;
1451 
1452     string public baseURI;
1453     string public baseExtension = ".json";
1454     uint256 public cost = 0.05 ether;
1455     uint256 public presaleCost = 0.03 ether;
1456     uint256 public maxSupply = 7000;
1457     uint256 public standardSupply = 3213;
1458     uint256 public deluxeSupply = 2023;
1459     uint256 public villaSupply = 595;
1460     uint256 public executiveSupply = 119;
1461     uint256 public maxMintAmount = 50;
1462     uint256 public standardCost = 0.12 ether;
1463     uint256 public deluxeCost = 0.24 ether;
1464     uint256 public villaCost = 0.59 ether;
1465     uint256 public executiveCost = 1.5 ether;
1466     bool public paused = false;
1467     mapping(address => bool) public whitelisted;
1468     mapping(address => bool) public presaleWallets;
1469 
1470     constructor(
1471         string memory _name,
1472         string memory _symbol,
1473         string memory _initBaseURI
1474     ) ERC721(_name, _symbol) {
1475         setBaseURI(_initBaseURI);
1476         minttokenId(msg.sender, 3213, 10);
1477         minttokenId(msg.sender, 5803, 10);
1478         minttokenId(msg.sender, 6755, 10);
1479         minttokenId(msg.sender, 6979, 10);
1480     }
1481 
1482     // internal
1483     function _baseURI() internal view virtual override returns (string memory) {
1484         return baseURI;
1485     }
1486     function setstandardCost(uint256 _newstandardCost) public onlyOwner {
1487         standardCost = _newstandardCost;
1488     }
1489     function setdeluxeCost(uint256 _newdeluxeCost) public onlyOwner {
1490         deluxeCost = _newdeluxeCost;
1491     }
1492     function setvillaCost(uint256 _newvillaCost) public onlyOwner {
1493         villaCost = _newvillaCost;
1494     }
1495     function setexecutiveCost(uint256 _newexecutiveCost) public onlyOwner {
1496         executiveCost = _newexecutiveCost;
1497     }
1498     
1499     function setstandardSupply(uint256 _standardSupply) internal {
1500         standardSupply = _standardSupply;
1501     }
1502     function setdeluxeSupply(uint256 _deluxeSupply) internal {
1503         deluxeSupply = _deluxeSupply;
1504     }
1505     function setvillaSupply(uint256 _villaSupply) internal {
1506         villaSupply = _villaSupply;
1507     }
1508     function setexecutiveSupply(uint256 _executiveSupply) internal {
1509         executiveSupply = _executiveSupply;
1510     }
1511     function needToUpdateCost(uint256 _supply) internal view returns (uint256 _cost) {
1512         if(_supply <= 3780) {
1513             return standardCost;
1514         }
1515         if(_supply <= 6160) {
1516             return deluxeCost;
1517         }
1518         if(_supply <= 6860) {
1519             return villaCost;
1520         }
1521         if(_supply <= maxSupply) {
1522             return executiveCost;
1523         }
1524     }
1525     function updateSupply(uint256 _tokenId, uint256 _mintAmount) internal {
1526         if(_tokenId < 3213 && _mintAmount + _tokenId < 3213) {
1527             setstandardSupply(standardSupply - _mintAmount);
1528         }
1529         if((3780 < _tokenId && 3780 < _tokenId + _mintAmount) && (_tokenId<5803 && _tokenId + _mintAmount<5803)) {
1530             setdeluxeSupply(deluxeSupply - _mintAmount);
1531         }
1532         if((6160<_tokenId && 6160<_tokenId + _mintAmount) && (_tokenId<6755 && _tokenId + _mintAmount<6755)) {
1533             setvillaSupply(villaSupply - _mintAmount);
1534         }
1535         if((6860<_tokenId && 6860<_tokenId + _mintAmount) && (_tokenId<6979 && _tokenId + _mintAmount<6979)) {
1536             setexecutiveSupply(executiveSupply - _mintAmount);
1537         }
1538     }
1539     function minttokenId(address _to, uint256 _tokenId, uint256 _mintAmount) public payable {
1540         uint256 supply = totalSupply();
1541         require(!paused);
1542         require(_mintAmount > 0);
1543         require(supply + _mintAmount <= maxSupply);
1544         if (msg.sender != owner()) {
1545             require((_tokenId < 3213 && _mintAmount + _tokenId < 3213) || ((3780 < _tokenId && 3780 < _tokenId + _mintAmount) && (_tokenId<5803 && _tokenId + _mintAmount<5803)) || ((6160<_tokenId && 6160<_tokenId + _mintAmount) && (_tokenId<6755 && _tokenId + _mintAmount<6755)) || ((6860<_tokenId && 6860<_tokenId + _mintAmount) && (_tokenId<6979 && _tokenId + _mintAmount<6979)), "reserved");
1546             require(_mintAmount <= maxMintAmount, "Mint amount exceed maximum allowed");
1547             require(msg.value >= needToUpdateCost(_tokenId) * _mintAmount, "Not enough to pay");
1548         }
1549         for (uint256 i = 0; i < _mintAmount; i++) {
1550             _safeMint(_to,_tokenId + i);
1551         }
1552         updateSupply(_tokenId,_mintAmount);
1553     }
1554 
1555     function walletOfOwner(address _owner)
1556         public
1557         view
1558         returns (uint256[] memory)
1559     {
1560         uint256 ownerTokenCount = balanceOf(_owner);
1561         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1562         for (uint256 i; i < ownerTokenCount; i++) {
1563             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1564         }
1565         return tokenIds;
1566     }
1567 
1568     function tokenURI(uint256 tokenId)
1569         public
1570         view
1571         virtual
1572         override
1573         returns (string memory)
1574     {
1575         require(
1576             _exists(tokenId),
1577             "ERC721Metadata: URI query for nonexistent token"
1578         );
1579 
1580         string memory currentBaseURI = _baseURI();
1581         return
1582             bytes(currentBaseURI).length > 0
1583                 ? string(
1584                     abi.encodePacked(
1585                         currentBaseURI,
1586                         tokenId.toString(),
1587                         baseExtension
1588                     )
1589                 )
1590                 : "";
1591     }
1592 
1593     //only owner
1594     function setCost(uint256 _newCost) public onlyOwner {
1595         cost = _newCost;
1596     }
1597 
1598     function setPresaleCost(uint256 _newCost) public onlyOwner {
1599         presaleCost = _newCost;
1600     }
1601 
1602     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1603         maxMintAmount = _newmaxMintAmount;
1604     }
1605 
1606     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1607         baseURI = _newBaseURI;
1608     }
1609 
1610     function setBaseExtension(string memory _newBaseExtension)
1611         public
1612         onlyOwner
1613     {
1614         baseExtension = _newBaseExtension;
1615     }
1616 
1617     function pause(bool _state) public onlyOwner {
1618         paused = _state;
1619     }
1620 
1621     function whitelistUser(address _user) public onlyOwner {
1622         whitelisted[_user] = true;
1623     }
1624 
1625     function removeWhitelistUser(address _user) public onlyOwner {
1626         whitelisted[_user] = false;
1627     }
1628 
1629     function addPresaleUser(address _user) public onlyOwner {
1630         presaleWallets[_user] = true;
1631     }
1632 
1633     function add100PresaleUsers(address[100] memory _users) public onlyOwner {
1634         for (uint256 i = 0; i < 2; i++) {
1635             presaleWallets[_users[i]] = true;
1636         }
1637     }
1638 
1639     function removePresaleUser(address _user) public onlyOwner {
1640         presaleWallets[_user] = false;
1641     }
1642 
1643     function withdraw() public payable onlyOwner {
1644         (bool success, ) = payable(msg.sender).call{
1645             value: address(this).balance
1646         }("");
1647         require(success);
1648     }
1649 }