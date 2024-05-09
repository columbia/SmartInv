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
716 // File: contracts/token/ERC721/ERC721.sol
717 
718 
719 
720 pragma solidity ^0.8.0;
721 
722 
723 
724 
725 
726 
727 
728 
729 /**
730  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
731  * the Metadata extension, but not including the Enumerable extension, which is available separately as
732  * {ERC721Enumerable}.
733  */
734 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
735     using Address for address;
736     using Strings for uint256;
737 
738     // Token name
739     string private _name;
740 
741     // Token symbol
742     string private _symbol;
743 
744     // Mapping from token ID to owner address
745     mapping(uint256 => address) private _owners;
746 
747     // Mapping owner address to token count
748     mapping(address => uint256) private _balances;
749 
750     // Mapping from token ID to approved address
751     mapping(uint256 => address) private _tokenApprovals;
752 
753     // Mapping from owner to operator approvals
754     mapping(address => mapping(address => bool)) private _operatorApprovals;
755 
756     /**
757      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
758      */
759     constructor(string memory name_, string memory symbol_) {
760         _name = name_;
761         _symbol = symbol_;
762     }
763 
764     /**
765      * @dev See {IERC165-supportsInterface}.
766      */
767     function supportsInterface(bytes4 interfaceId)
768         public
769         view
770         virtual
771         override(ERC165, IERC165)
772         returns (bool)
773     {
774         return
775             interfaceId == type(IERC721).interfaceId ||
776             interfaceId == type(IERC721Metadata).interfaceId ||
777             super.supportsInterface(interfaceId);
778     }
779 
780     /**
781      * @dev See {IERC721-balanceOf}.
782      */
783     function balanceOf(address owner)
784         public
785         view
786         virtual
787         override
788         returns (uint256)
789     {
790         require(
791             owner != address(0),
792             "ERC721: balance query for the zero address"
793         );
794         return _balances[owner];
795     }
796 
797     /**
798      * @dev See {IERC721-ownerOf}.
799      */
800     function ownerOf(uint256 tokenId)
801         public
802         view
803         virtual
804         override
805         returns (address)
806     {
807         address owner = _owners[tokenId];
808         require(
809             owner != address(0),
810             "ERC721: owner query for nonexistent token"
811         );
812         return owner;
813     }
814 
815     /**
816      * @dev See {IERC721Metadata-name}.
817      */
818     function name() public view virtual override returns (string memory) {
819         return _name;
820     }
821 
822     /**
823      * @dev See {IERC721Metadata-symbol}.
824      */
825     function symbol() public view virtual override returns (string memory) {
826         return _symbol;
827     }
828 
829     /**
830      * @dev See {IERC721Metadata-tokenURI}.
831      */
832     function tokenURI(uint256 tokenId)
833         public
834         view
835         virtual
836         override
837         returns (string memory)
838     {
839         require(
840             _exists(tokenId),
841             "ERC721Metadata: URI query for nonexistent token"
842         );
843 
844         string memory baseURI = _baseURI();
845         return
846             bytes(baseURI).length > 0
847                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
848                 : "";
849     }
850 
851     /**
852      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
853      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
854      * by default, can be overriden in child contracts.
855      */
856     function _baseURI() internal view virtual returns (string memory) {
857         return "";
858     }
859 
860     /**
861      * @dev See {IERC721-approve}.
862      */
863     function approve(address to, uint256 tokenId) public virtual override {
864         address owner = ERC721.ownerOf(tokenId);
865         require(to != owner, "ERC721: approval to current owner");
866 
867         require(
868             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
869             "ERC721: approve caller is not owner nor approved for all"
870         );
871 
872         _approve(to, tokenId);
873     }
874 
875     /**
876      * @dev See {IERC721-getApproved}.
877      */
878     function getApproved(uint256 tokenId)
879         public
880         view
881         virtual
882         override
883         returns (address)
884     {
885         require(
886             _exists(tokenId),
887             "ERC721: approved query for nonexistent token"
888         );
889 
890         return _tokenApprovals[tokenId];
891     }
892 
893     /**
894      * @dev See {IERC721-setApprovalForAll}.
895      */
896     function setApprovalForAll(address operator, bool approved)
897         public
898         virtual
899         override
900     {
901         require(operator != _msgSender(), "ERC721: approve to caller");
902 
903         _operatorApprovals[_msgSender()][operator] = approved;
904         emit ApprovalForAll(_msgSender(), operator, approved);
905     }
906 
907     /**
908      * @dev See {IERC721-isApprovedForAll}.
909      */
910     function isApprovedForAll(address owner, address operator)
911         public
912         view
913         virtual
914         override
915         returns (bool)
916     {
917         return _operatorApprovals[owner][operator];
918     }
919 
920     /**
921      * @dev See {IERC721-transferFrom}.
922      */
923     function transferFrom(
924         address from,
925         address to,
926         uint256 tokenId
927     ) public virtual override {
928         //solhint-disable-next-line max-line-length
929         require(
930             _isApprovedOrOwner(_msgSender(), tokenId),
931             "ERC721: transfer caller is not owner nor approved"
932         );
933 
934         _transfer(from, to, tokenId);
935     }
936 
937     /**
938      * @dev See {IERC721-safeTransferFrom}.
939      */
940     function safeTransferFrom(
941         address from,
942         address to,
943         uint256 tokenId
944     ) public virtual override {
945         safeTransferFrom(from, to, tokenId, "");
946     }
947 
948     /**
949      * @dev See {IERC721-safeTransferFrom}.
950      */
951     function safeTransferFrom(
952         address from,
953         address to,
954         uint256 tokenId,
955         bytes memory _data
956     ) public virtual override {
957         require(
958             _isApprovedOrOwner(_msgSender(), tokenId),
959             "ERC721: transfer caller is not owner nor approved"
960         );
961         _safeTransfer(from, to, tokenId, _data);
962     }
963 
964     /**
965      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
966      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
967      *
968      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
969      *
970      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
971      * implement alternative mechanisms to perform token transfer, such as signature-based.
972      *
973      * Requirements:
974      *
975      * - `from` cannot be the zero address.
976      * - `to` cannot be the zero address.
977      * - `tokenId` token must exist and be owned by `from`.
978      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _safeTransfer(
983         address from,
984         address to,
985         uint256 tokenId,
986         bytes memory _data
987     ) internal virtual {
988         _transfer(from, to, tokenId);
989         require(
990             _checkOnERC721Received(from, to, tokenId, _data),
991             "ERC721: transfer to non ERC721Receiver implementer"
992         );
993     }
994 
995     /**
996      * @dev Returns whether `tokenId` exists.
997      *
998      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
999      *
1000      * Tokens start existing when they are minted (`_mint`),
1001      * and stop existing when they are burned (`_burn`).
1002      */
1003     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1004         return _owners[tokenId] != address(0);
1005     }
1006 
1007     /**
1008      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1009      *
1010      * Requirements:
1011      *
1012      * - `tokenId` must exist.
1013      */
1014     function _isApprovedOrOwner(address spender, uint256 tokenId)
1015         internal
1016         view
1017         virtual
1018         returns (bool)
1019     {
1020         require(
1021             _exists(tokenId),
1022             "ERC721: operator query for nonexistent token"
1023         );
1024         address owner = ERC721.ownerOf(tokenId);
1025         return (spender == owner ||
1026             getApproved(tokenId) == spender ||
1027             isApprovedForAll(owner, spender));
1028     }
1029 
1030     /**
1031      * @dev Safely mints `tokenId` and transfers it to `to`.
1032      *
1033      * Requirements:
1034      *
1035      * - `tokenId` must not exist.
1036      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function _safeMint(address to, uint256 tokenId) internal virtual {
1041         _safeMint(to, tokenId, "");
1042     }
1043 
1044     /**
1045      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1046      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1047      */
1048     function _safeMint(
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) internal virtual {
1053         _mint(to, tokenId);
1054         require(
1055             _checkOnERC721Received(address(0), to, tokenId, _data),
1056             "ERC721: transfer to non ERC721Receiver implementer"
1057         );
1058     }
1059 
1060     /**
1061      * @dev Mints `tokenId` and transfers it to `to`.
1062      *
1063      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1064      *
1065      * Requirements:
1066      *
1067      * - `tokenId` must not exist.
1068      * - `to` cannot be the zero address.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _mint(address to, uint256 tokenId) internal virtual {
1073         require(to != address(0), "ERC721: mint to the zero address");
1074         require(!_exists(tokenId), "ERC721: token already minted");
1075 
1076         _beforeTokenTransfer(address(0), to, tokenId);
1077 
1078         _balances[to] += 1;
1079         _owners[tokenId] = to;
1080 
1081         emit Transfer(address(0), to, tokenId);
1082     }
1083 
1084     /**
1085      * @dev Destroys `tokenId`.
1086      * The approval is cleared when the token is burned.
1087      *
1088      * Requirements:
1089      *
1090      * - `tokenId` must exist.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function _burn(uint256 tokenId) internal virtual {
1095         address owner = ERC721.ownerOf(tokenId);
1096 
1097         _beforeTokenTransfer(owner, address(0), tokenId);
1098 
1099         // Clear approvals
1100         _approve(address(0), tokenId);
1101 
1102         _balances[owner] -= 1;
1103         delete _owners[tokenId];
1104 
1105         emit Transfer(owner, address(0), tokenId);
1106     }
1107 
1108     /**
1109      * @dev Transfers `tokenId` from `from` to `to`.
1110      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1111      *
1112      * Requirements:
1113      *
1114      * - `to` cannot be the zero address.
1115      * - `tokenId` token must be owned by `from`.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _transfer(
1120         address from,
1121         address to,
1122         uint256 tokenId
1123     ) internal virtual {
1124         require(
1125             ERC721.ownerOf(tokenId) == from,
1126             "ERC721: transfer of token that is not own"
1127         );
1128         require(to != address(0), "ERC721: transfer to the zero address");
1129 
1130         _beforeTokenTransfer(from, to, tokenId);
1131 
1132         // Clear approvals from the previous owner
1133         _approve(address(0), tokenId);
1134 
1135         _balances[from] -= 1;
1136         _balances[to] += 1;
1137         _owners[tokenId] = to;
1138 
1139         emit Transfer(from, to, tokenId);
1140     }
1141 
1142     /**
1143      * @dev Approve `to` to operate on `tokenId`
1144      *
1145      * Emits a {Approval} event.
1146      */
1147     function _approve(address to, uint256 tokenId) internal virtual {
1148         _tokenApprovals[tokenId] = to;
1149         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1150     }
1151 
1152     /**
1153      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1154      * The call is not executed if the target address is not a contract.
1155      *
1156      * @param from address representing the previous owner of the given token ID
1157      * @param to target address that will receive the tokens
1158      * @param tokenId uint256 ID of the token to be transferred
1159      * @param _data bytes optional data to send along with the call
1160      * @return bool whether the call correctly returned the expected magic value
1161      */
1162     function _checkOnERC721Received(
1163         address from,
1164         address to,
1165         uint256 tokenId,
1166         bytes memory _data
1167     ) private returns (bool) {
1168         if (to.isContract()) {
1169             try
1170                 IERC721Receiver(to).onERC721Received(
1171                     _msgSender(),
1172                     from,
1173                     tokenId,
1174                     _data
1175                 )
1176             returns (bytes4 retval) {
1177                 return retval == IERC721Receiver.onERC721Received.selector;
1178             } catch (bytes memory reason) {
1179                 if (reason.length == 0) {
1180                     revert(
1181                         "ERC721: transfer to non ERC721Receiver implementer"
1182                     );
1183                 } else {
1184                     assembly {
1185                         revert(add(32, reason), mload(reason))
1186                     }
1187                 }
1188             }
1189         } else {
1190             return true;
1191         }
1192     }
1193 
1194     /**
1195      * @dev Hook that is called before any token transfer. This includes minting
1196      * and burning.
1197      *
1198      * Calling conditions:
1199      *
1200      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1201      * transferred to `to`.
1202      * - When `from` is zero, `tokenId` will be minted for `to`.
1203      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1204      * - `from` and `to` are never both zero.
1205      *
1206      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1207      */
1208     function _beforeTokenTransfer(
1209         address from,
1210         address to,
1211         uint256 tokenId
1212     ) internal virtual {}
1213 }
1214 
1215 // File: CryptOgres.sol
1216 
1217 /* SPDX-License-Identifier: MIT
1218                                      @&***@                                     
1219                                  @*************                                 
1220                       @*%      ****#%************      @**                      
1221                       ****@   **####@*******#####*@   **#*@                     
1222                            *#**********************@/                           
1223                             #***********************@                           
1224                            #***************%********#                           
1225                            **************************#                          
1226                           #*************#************#                          
1227                           @#************************##                          
1228                            @#**********************##                           
1229                              @#*******************#@                            
1230                               #@##**,*******,**\###                             
1231                             ######@###########@#####@                           
1232                       @##********###############*******\##@                     
1233                     ##*************************************##                   
1234                   @#*****************************************#@                 
1235                  #(*******************************************##                
1236                @#***********************************************#@              
1237               ##*********#*****************************#*********##             
1238              ##********* #*****************************# *********#&            
1239              @#********* ******************************\@********##(            
1240               %#********@*******************************@*******##@  
1241 
1242 ░█████╗░██████╗░██╗░░░██╗██████╗░████████╗░█████╗░░██████╗░██████╗░███████╗░██████╗
1243 ██╔══██╗██╔══██╗╚██╗░██╔╝██╔══██╗╚══██╔══╝██╔══██╗██╔════╝░██╔══██╗██╔════╝██╔════╝
1244 ██║░░╚═╝██████╔╝░╚████╔╝░██████╔╝░░░██║░░░██║░░██║██║░░██╗░██████╔╝█████╗░░╚█████╗░
1245 ██║░░██╗██╔══██╗░░╚██╔╝░░██╔═══╝░░░░██║░░░██║░░██║██║░░╚██╗██╔══██╗██╔══╝░░░╚═══██╗
1246 ╚█████╔╝██║░░██║░░░██║░░░██║░░░░░░░░██║░░░╚█████╔╝╚██████╔╝██║░░██║███████╗██████╔╝
1247 ░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░░░░╚═╝░░░░╚════╝░░╚═════╝░╚═╝░░╚═╝╚══════╝╚═════╝░
1248 */
1249 pragma solidity ^0.8.7;
1250 
1251 
1252 
1253 contract CryptOgresFTMV is ERC721, Ownable {
1254     using Strings for uint256;
1255 
1256     string public baseURI;
1257     string public baseExtension = ".json";
1258     uint256 public cost = 0.05 ether;
1259     uint256 public presaleStart = 1646157600;
1260     uint256 public publicStart = 1646330400;
1261     uint256 public maxPresaleSupply = 700;
1262     uint256 public maxSupply = 4444;
1263     uint256 public maxPresaleMintAmount = 3;
1264     uint256 public maxMintAmount = 20;
1265     uint16 public totalSupply = 0;
1266     
1267     mapping(address => bool) public presaleWallets;
1268 
1269     constructor(
1270         string memory _name,
1271         string memory _symbol,
1272         string memory _initBaseURI
1273     ) ERC721(_name, _symbol) {
1274         setBaseURI(_initBaseURI);
1275         mintAdmin(msg.sender, 200);
1276     }
1277 
1278     // internal
1279     function _baseURI() internal view virtual override returns (string memory) {
1280         return baseURI;
1281     }
1282 
1283     // public
1284     //PRESALE MINT
1285     function mintPresale(address _to, uint16 _mintAmount) public payable {
1286         //uint256 supply = totalSupply();
1287         require(presaleWallets[msg.sender] == true, "You are not on the presale whitelist.");
1288         require(presaleStart <= block.timestamp && publicStart >= block.timestamp);
1289         require(_mintAmount > 0);
1290         require(_mintAmount <= maxPresaleMintAmount, "You can only mint 3 in presale.");
1291         require(totalSupply + _mintAmount <= maxPresaleSupply, "Purchase would exceed max presale tokens.");
1292         require(msg.value >= cost * _mintAmount, "Ether value sent is not correct.");
1293             for (uint256 i = 1; i <= _mintAmount; i++) {
1294                 _safeMint(_to, totalSupply + i);
1295              }   
1296              totalSupply += _mintAmount;
1297     }
1298 
1299     //PUBLIC MINT
1300     function mintPublic(address _to, uint16 _mintAmount) public payable {
1301         //uint256 supply = totalSupply();
1302         require(_mintAmount > 0);
1303         require (publicStart <= block.timestamp);
1304         require(_mintAmount <= maxMintAmount, "You can only mint 20 per transaction.");
1305         require(totalSupply + _mintAmount <= maxSupply, "Purchase would exceed max tokens.");
1306         require(msg.value >= cost * _mintAmount, "Ether value sent is not correct.");
1307             for (uint256 i = 1; i <= _mintAmount; i++) {
1308                 _safeMint(_to, totalSupply + i);
1309              }   
1310              totalSupply += _mintAmount;
1311     }
1312 
1313     //ADMIN MINT
1314     function mintAdmin(address _to, uint16 _mintAmount) public payable {
1315         //uint256 supply = totalSupply();
1316         require(_mintAmount > 0);
1317             
1318             for (uint256 i = 1; i <= _mintAmount; i++) {
1319                 _safeMint(_to, totalSupply + i);
1320              }
1321              totalSupply += _mintAmount;
1322     }
1323 
1324     function tokenURI(uint256 tokenId)
1325         public
1326         view
1327         virtual
1328         override
1329         returns (string memory)
1330     {
1331         require(
1332             _exists(tokenId),
1333             "ERC721Metadata: URI query for nonexistent token"
1334         );
1335 
1336         string memory currentBaseURI = _baseURI();
1337         return
1338             bytes(currentBaseURI).length > 0
1339                 ? string(
1340                     abi.encodePacked(
1341                         currentBaseURI,
1342                         tokenId.toString(),
1343                         baseExtension
1344                     )
1345                 )
1346                 : "";
1347     }
1348 
1349     function totalSupplyCount() public view returns (uint16) {
1350         return totalSupply;
1351     }
1352 
1353     //only owner
1354     function setCost(uint256 _newCost) public onlyOwner {
1355         cost = _newCost;
1356     }
1357 
1358     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1359         maxMintAmount = _newmaxMintAmount;
1360     }
1361 
1362     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1363         baseURI = _newBaseURI;
1364     }
1365 
1366     function setBaseExtension(string memory _newBaseExtension)
1367         public
1368         onlyOwner
1369     {
1370         baseExtension = _newBaseExtension;
1371     }
1372 
1373     function addPresaleUser(address _user) public onlyOwner {
1374         presaleWallets[_user] = true;
1375     }
1376 
1377     function addArrayOfPresaleUsers(address[] memory _users) public onlyOwner {
1378         for (uint256 i = 0; i < 2; i++) {
1379             presaleWallets[_users[i]] = true;
1380         }
1381     }
1382 
1383     function withdraw() public payable onlyOwner {
1384         (bool success, ) = payable(msg.sender).call{
1385             value: address(this).balance
1386         }("");
1387         require(success);
1388     }
1389 }