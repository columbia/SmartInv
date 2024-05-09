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
689 // File: contracts/token/ERC721/extensions/IERC721Metadata.sol
690 
691 
692 
693 pragma solidity ^0.8.0;
694 
695 
696 /**
697  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
698  * @dev See https://eips.ethereum.org/EIPS/eip-721
699  */
700 interface IERC721Metadata is IERC721 {
701     /**
702      * @dev Returns the token collection name.
703      */
704     function name() external view returns (string memory);
705 
706     /**
707      * @dev Returns the token collection symbol.
708      */
709     function symbol() external view returns (string memory);
710 
711     /**
712      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
713      */
714     function tokenURI(uint256 tokenId) external view returns (string memory);
715 }
716 
717 // File: contracts/token/ERC721/ERC721.sol
718 
719 
720 
721 pragma solidity ^0.8.0;
722 
723 
724 
725 
726 
727 
728 
729 
730 /**
731  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
732  * the Metadata extension, but not including the Enumerable extension, which is available separately as
733  * {ERC721Enumerable}.
734  */
735 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
736     using Address for address;
737     using Strings for uint256;
738 
739     // Token name
740     string private _name;
741 
742     // Token symbol
743     string private _symbol;
744 
745     // Mapping from token ID to owner address
746     mapping(uint256 => address) private _owners;
747 
748     // Mapping owner address to token count
749     mapping(address => uint256) private _balances;
750 
751     // Mapping from token ID to approved address
752     mapping(uint256 => address) private _tokenApprovals;
753 
754     // Mapping from owner to operator approvals
755     mapping(address => mapping(address => bool)) private _operatorApprovals;
756 
757     /**
758      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
759      */
760     constructor(string memory name_, string memory symbol_) {
761         _name = name_;
762         _symbol = symbol_;
763     }
764 
765     /**
766      * @dev See {IERC165-supportsInterface}.
767      */
768     function supportsInterface(bytes4 interfaceId)
769         public
770         view
771         virtual
772         override(ERC165, IERC165)
773         returns (bool)
774     {
775         return
776             interfaceId == type(IERC721).interfaceId ||
777             interfaceId == type(IERC721Metadata).interfaceId ||
778             super.supportsInterface(interfaceId);
779     }
780 
781     /**
782      * @dev See {IERC721-balanceOf}.
783      */
784     function balanceOf(address owner)
785         public
786         view
787         virtual
788         override
789         returns (uint256)
790     {
791         require(
792             owner != address(0),
793             "ERC721: balance query for the zero address"
794         );
795         return _balances[owner];
796     }
797 
798     /**
799      * @dev See {IERC721-ownerOf}.
800      */
801     function ownerOf(uint256 tokenId)
802         public
803         view
804         virtual
805         override
806         returns (address)
807     {
808         address owner = _owners[tokenId];
809         require(
810             owner != address(0),
811             "ERC721: owner query for nonexistent token"
812         );
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
833     function tokenURI(uint256 tokenId)
834         public
835         view
836         virtual
837         override
838         returns (string memory)
839     {
840         require(
841             _exists(tokenId),
842             "ERC721Metadata: URI query for nonexistent token"
843         );
844 
845         string memory baseURI = _baseURI();
846         return
847             bytes(baseURI).length > 0
848                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
849                 : "";
850     }
851 
852     /**
853      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
854      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
855      * by default, can be overriden in child contracts.
856      */
857     function _baseURI() internal view virtual returns (string memory) {
858         return "";
859     }
860 
861     /**
862      * @dev See {IERC721-approve}.
863      */
864     function approve(address to, uint256 tokenId) public virtual override {
865         address owner = ERC721.ownerOf(tokenId);
866         require(to != owner, "ERC721: approval to current owner");
867 
868         require(
869             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
870             "ERC721: approve caller is not owner nor approved for all"
871         );
872 
873         _approve(to, tokenId);
874     }
875 
876     /**
877      * @dev See {IERC721-getApproved}.
878      */
879     function getApproved(uint256 tokenId)
880         public
881         view
882         virtual
883         override
884         returns (address)
885     {
886         require(
887             _exists(tokenId),
888             "ERC721: approved query for nonexistent token"
889         );
890 
891         return _tokenApprovals[tokenId];
892     }
893 
894     /**
895      * @dev See {IERC721-setApprovalForAll}.
896      */
897     function setApprovalForAll(address operator, bool approved)
898         public
899         virtual
900         override
901     {
902         require(operator != _msgSender(), "ERC721: approve to caller");
903 
904         _operatorApprovals[_msgSender()][operator] = approved;
905         emit ApprovalForAll(_msgSender(), operator, approved);
906     }
907 
908     /**
909      * @dev See {IERC721-isApprovedForAll}.
910      */
911     function isApprovedForAll(address owner, address operator)
912         public
913         view
914         virtual
915         override
916         returns (bool)
917     {
918         return _operatorApprovals[owner][operator];
919     }
920 
921     /**
922      * @dev See {IERC721-transferFrom}.
923      */
924     function transferFrom(
925         address from,
926         address to,
927         uint256 tokenId
928     ) public virtual override {
929         //solhint-disable-next-line max-line-length
930         require(
931             _isApprovedOrOwner(_msgSender(), tokenId),
932             "ERC721: transfer caller is not owner nor approved"
933         );
934 
935         _transfer(from, to, tokenId);
936     }
937 
938     /**
939      * @dev See {IERC721-safeTransferFrom}.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId
945     ) public virtual override {
946         safeTransferFrom(from, to, tokenId, "");
947     }
948 
949     /**
950      * @dev See {IERC721-safeTransferFrom}.
951      */
952     function safeTransferFrom(
953         address from,
954         address to,
955         uint256 tokenId,
956         bytes memory _data
957     ) public virtual override {
958         require(
959             _isApprovedOrOwner(_msgSender(), tokenId),
960             "ERC721: transfer caller is not owner nor approved"
961         );
962         _safeTransfer(from, to, tokenId, _data);
963     }
964 
965     /**
966      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
967      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
968      *
969      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
970      *
971      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
972      * implement alternative mechanisms to perform token transfer, such as signature-based.
973      *
974      * Requirements:
975      *
976      * - `from` cannot be the zero address.
977      * - `to` cannot be the zero address.
978      * - `tokenId` token must exist and be owned by `from`.
979      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _safeTransfer(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) internal virtual {
989         _transfer(from, to, tokenId);
990         require(
991             _checkOnERC721Received(from, to, tokenId, _data),
992             "ERC721: transfer to non ERC721Receiver implementer"
993         );
994     }
995 
996     /**
997      * @dev Returns whether `tokenId` exists.
998      *
999      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1000      *
1001      * Tokens start existing when they are minted (`_mint`),
1002      * and stop existing when they are burned (`_burn`).
1003      */
1004     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1005         return _owners[tokenId] != address(0);
1006     }
1007 
1008     /**
1009      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1010      *
1011      * Requirements:
1012      *
1013      * - `tokenId` must exist.
1014      */
1015     function _isApprovedOrOwner(address spender, uint256 tokenId)
1016         internal
1017         view
1018         virtual
1019         returns (bool)
1020     {
1021         require(
1022             _exists(tokenId),
1023             "ERC721: operator query for nonexistent token"
1024         );
1025         address owner = ERC721.ownerOf(tokenId);
1026         return (spender == owner ||
1027             getApproved(tokenId) == spender ||
1028             isApprovedForAll(owner, spender));
1029     }
1030 
1031     /**
1032      * @dev Safely mints `tokenId` and transfers it to `to`.
1033      *
1034      * Requirements:
1035      *
1036      * - `tokenId` must not exist.
1037      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function _safeMint(address to, uint256 tokenId) internal virtual {
1042         _safeMint(to, tokenId, "");
1043     }
1044 
1045     /**
1046      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1047      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1048      */
1049     function _safeMint(
1050         address to,
1051         uint256 tokenId,
1052         bytes memory _data
1053     ) internal virtual {
1054         _mint(to, tokenId);
1055         require(
1056             _checkOnERC721Received(address(0), to, tokenId, _data),
1057             "ERC721: transfer to non ERC721Receiver implementer"
1058         );
1059     }
1060 
1061     /**
1062      * @dev Mints `tokenId` and transfers it to `to`.
1063      *
1064      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1065      *
1066      * Requirements:
1067      *
1068      * - `tokenId` must not exist.
1069      * - `to` cannot be the zero address.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _mint(address to, uint256 tokenId) internal virtual {
1074         require(to != address(0), "ERC721: mint to the zero address");
1075         require(!_exists(tokenId), "ERC721: token already minted");
1076 
1077         _beforeTokenTransfer(address(0), to, tokenId);
1078 
1079         _balances[to] += 1;
1080         _owners[tokenId] = to;
1081 
1082         emit Transfer(address(0), to, tokenId);
1083     }
1084 
1085     /**
1086      * @dev Destroys `tokenId`.
1087      * The approval is cleared when the token is burned.
1088      *
1089      * Requirements:
1090      *
1091      * - `tokenId` must exist.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function _burn(uint256 tokenId) internal virtual {
1096         address owner = ERC721.ownerOf(tokenId);
1097 
1098         _beforeTokenTransfer(owner, address(0), tokenId);
1099 
1100         // Clear approvals
1101         _approve(address(0), tokenId);
1102 
1103         _balances[owner] -= 1;
1104         delete _owners[tokenId];
1105 
1106         emit Transfer(owner, address(0), tokenId);
1107     }
1108 
1109     /**
1110      * @dev Transfers `tokenId` from `from` to `to`.
1111      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1112      *
1113      * Requirements:
1114      *
1115      * - `to` cannot be the zero address.
1116      * - `tokenId` token must be owned by `from`.
1117      *
1118      * Emits a {Transfer} event.
1119      */
1120     function _transfer(
1121         address from,
1122         address to,
1123         uint256 tokenId
1124     ) internal virtual {
1125         require(
1126             ERC721.ownerOf(tokenId) == from,
1127             "ERC721: transfer of token that is not own"
1128         );
1129         require(to != address(0), "ERC721: transfer to the zero address");
1130 
1131         _beforeTokenTransfer(from, to, tokenId);
1132 
1133         // Clear approvals from the previous owner
1134         _approve(address(0), tokenId);
1135 
1136         _balances[from] -= 1;
1137         _balances[to] += 1;
1138         _owners[tokenId] = to;
1139 
1140         emit Transfer(from, to, tokenId);
1141     }
1142 
1143     /**
1144      * @dev Approve `to` to operate on `tokenId`
1145      *
1146      * Emits a {Approval} event.
1147      */
1148     function _approve(address to, uint256 tokenId) internal virtual {
1149         _tokenApprovals[tokenId] = to;
1150         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1151     }
1152 
1153     /**
1154      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1155      * The call is not executed if the target address is not a contract.
1156      *
1157      * @param from address representing the previous owner of the given token ID
1158      * @param to target address that will receive the tokens
1159      * @param tokenId uint256 ID of the token to be transferred
1160      * @param _data bytes optional data to send along with the call
1161      * @return bool whether the call correctly returned the expected magic value
1162      */
1163     function _checkOnERC721Received(
1164         address from,
1165         address to,
1166         uint256 tokenId,
1167         bytes memory _data
1168     ) private returns (bool) {
1169         if (to.isContract()) {
1170             try
1171                 IERC721Receiver(to).onERC721Received(
1172                     _msgSender(),
1173                     from,
1174                     tokenId,
1175                     _data
1176                 )
1177             returns (bytes4 retval) {
1178                 return retval == IERC721Receiver.onERC721Received.selector;
1179             } catch (bytes memory reason) {
1180                 if (reason.length == 0) {
1181                     revert(
1182                         "ERC721: transfer to non ERC721Receiver implementer"
1183                     );
1184                 } else {
1185                     assembly {
1186                         revert(add(32, reason), mload(reason))
1187                     }
1188                 }
1189             }
1190         } else {
1191             return true;
1192         }
1193     }
1194 
1195     /**
1196      * @dev Hook that is called before any token transfer. This includes minting
1197      * and burning.
1198      *
1199      * Calling conditions:
1200      *
1201      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1202      * transferred to `to`.
1203      * - When `from` is zero, `tokenId` will be minted for `to`.
1204      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1205      * - `from` and `to` are never both zero.
1206      *
1207      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1208      */
1209     function _beforeTokenTransfer(
1210         address from,
1211         address to,
1212         uint256 tokenId
1213     ) internal virtual {}
1214 }
1215 
1216 // File: tests/LeanWTPhunks.sol
1217 
1218 //SPDX-License-Identifier: MIT
1219 
1220 pragma solidity ^0.8.7;
1221 
1222 
1223 
1224 contract WTPhunks is ERC721, Ownable {
1225     using Strings for uint256;
1226 
1227     string public baseURI;
1228     string public baseExtension = ".json";
1229     uint256 public cost = 0 ether;
1230     uint256 public bulkCost = 0 ether;
1231     uint256 public bulkNum = 10;
1232     uint256 public maxSupply = 10000;
1233     uint256 public maxMintAmount = 20;
1234     uint256 public saleLimit = 1000;
1235     bool public paused = false;
1236     uint16 public totalSupply = 0;
1237 
1238     constructor(
1239         string memory _name,
1240         string memory _symbol,
1241         string memory _initBaseURI
1242     ) ERC721(_name, _symbol) {
1243         setBaseURI(_initBaseURI);
1244         mint(msg.sender, 1);
1245     }
1246 
1247     // internal
1248     function _baseURI() internal view virtual override returns (string memory) {
1249         return baseURI;
1250     }
1251 
1252     // public
1253     function mint(address _to, uint256 _mintAmount) public payable {
1254         require(!paused);
1255         require(_mintAmount > 0);
1256         require(_mintAmount <= maxMintAmount);
1257         require(totalSupply + _mintAmount <= saleLimit);
1258 
1259         if (msg.sender != owner()) {
1260             if(_mintAmount >= bulkNum) {
1261                 require(msg.value >= bulkCost * _mintAmount);
1262             } else {
1263                 require(msg.value >= cost * _mintAmount);
1264             }
1265         }
1266 
1267         for (uint256 i = 1; i <= _mintAmount; i++) {
1268             _safeMint(_to, totalSupply + 1);
1269             totalSupply += 1;
1270         }
1271     }
1272 
1273     function tokenURI(uint256 tokenId)
1274         public
1275         view
1276         virtual
1277         override
1278         returns (string memory)
1279     {
1280         require(
1281             _exists(tokenId),
1282             "ERC721Metadata: URI query for nonexistent token"
1283         );
1284 
1285         string memory currentBaseURI = _baseURI();
1286         return
1287             bytes(currentBaseURI).length > 0
1288                 ? string(
1289                     abi.encodePacked(
1290                         currentBaseURI,
1291                         tokenId.toString(),
1292                         baseExtension
1293                     )
1294                 )
1295                 : "";
1296     }
1297 
1298     //only owner
1299     function setCost(uint256 _newCost) public onlyOwner {
1300         cost = _newCost;
1301     }
1302 
1303     function setBulkCost(uint256 _newBulkCost) public onlyOwner {
1304         bulkCost = _newBulkCost;
1305     }
1306 
1307     function setBulkNum(uint256 _newBulkNum) public onlyOwner {
1308         bulkNum = _newBulkNum;
1309     }
1310 
1311     function setSaleLimit(uint256 _saleLimit) public onlyOwner {
1312         require(_saleLimit <= maxSupply);
1313         saleLimit = _saleLimit;
1314     }
1315 
1316     function updateSalePhase(uint256 _saleLimit, uint256 _cost, uint256 _bulkCost) public onlyOwner {
1317         setSaleLimit(_saleLimit);
1318         setCost(_cost);
1319         setBulkCost(_bulkCost);
1320     }
1321 
1322     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1323         maxMintAmount = _newmaxMintAmount;
1324     }
1325 
1326     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1327         baseURI = _newBaseURI;
1328     }
1329 
1330     function setBaseExtension(string memory _newBaseExtension)
1331         public
1332         onlyOwner
1333     {
1334         baseExtension = _newBaseExtension;
1335     }
1336 
1337     function pause(bool _state) public onlyOwner {
1338         paused = _state;
1339     }
1340 
1341     function withdraw() public payable onlyOwner {
1342         (bool success, ) = payable(msg.sender).call{
1343             value: address(this).balance
1344         }("");
1345         require(success);
1346     }
1347 }