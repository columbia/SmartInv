1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length)
56         internal
57         pure
58         returns (string memory)
59     {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Context.sol
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
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev Contract module which provides a basic access control mechanism, where
102  * there is an account (an owner) that can be granted exclusive access to
103  * specific functions.
104  *
105  * By default, the owner account will be the one that deploys the contract. This
106  * can later be changed with {transferOwnership}.
107  *
108  * This module is used through inheritance. It will make available the modifier
109  * `onlyOwner`, which can be applied to your functions to restrict their use to
110  * the owner.
111  */
112 abstract contract Ownable is Context {
113     address private _owner;
114 
115     event OwnershipTransferred(
116         address indexed previousOwner,
117         address indexed newOwner
118     );
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
158         require(
159             newOwner != address(0),
160             "Ownable: new owner is the zero address"
161         );
162         _setOwner(newOwner);
163     }
164 
165     function _setOwner(address newOwner) private {
166         address oldOwner = _owner;
167         _owner = newOwner;
168         emit OwnershipTransferred(oldOwner, newOwner);
169     }
170 }
171 
172 // File: @openzeppelin/contracts/utils/Address.sol
173 
174 pragma solidity ^0.8.0;
175 
176 /**
177  * @dev Collection of functions related to the address type
178  */
179 library Address {
180     /**
181      * @dev Returns true if `account` is a contract.
182      *
183      * [IMPORTANT]
184      * ====
185      * It is unsafe to assume that an address for which this function returns
186      * false is an externally-owned account (EOA) and not a contract.
187      *
188      * Among others, `isContract` will return false for the following
189      * types of addresses:
190      *
191      *  - an externally-owned account
192      *  - a contract in construction
193      *  - an address where a contract will be created
194      *  - an address where a contract lived, but was destroyed
195      * ====
196      */
197     function isContract(address account) internal view returns (bool) {
198         // This method relies on extcodesize, which returns 0 for contracts in
199         // construction, since the code is only stored at the end of the
200         // constructor execution.
201 
202         uint256 size;
203         assembly {
204             size := extcodesize(account)
205         }
206         return size > 0;
207     }
208 
209     /**
210      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
211      * `recipient`, forwarding all available gas and reverting on errors.
212      *
213      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
214      * of certain opcodes, possibly making contracts go over the 2300 gas limit
215      * imposed by `transfer`, making them unable to receive funds via
216      * `transfer`. {sendValue} removes this limitation.
217      *
218      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
219      *
220      * IMPORTANT: because control is transferred to `recipient`, care must be
221      * taken to not create reentrancy vulnerabilities. Consider using
222      * {ReentrancyGuard} or the
223      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
224      */
225     function sendValue(address payable recipient, uint256 amount) internal {
226         require(
227             address(this).balance >= amount,
228             "Address: insufficient balance"
229         );
230 
231         (bool success, ) = recipient.call{value: amount}("");
232         require(
233             success,
234             "Address: unable to send value, recipient may have reverted"
235         );
236     }
237 
238     /**
239      * @dev Performs a Solidity function call using a low level `call`. A
240      * plain `call` is an unsafe replacement for a function call: use this
241      * function instead.
242      *
243      * If `target` reverts with a revert reason, it is bubbled up by this
244      * function (like regular Solidity function calls).
245      *
246      * Returns the raw returned data. To convert to the expected return value,
247      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
248      *
249      * Requirements:
250      *
251      * - `target` must be a contract.
252      * - calling `target` with `data` must not revert.
253      *
254      * _Available since v3.1._
255      */
256     function functionCall(address target, bytes memory data)
257         internal
258         returns (bytes memory)
259     {
260         return functionCall(target, data, "Address: low-level call failed");
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
265      * `errorMessage` as a fallback revert reason when `target` reverts.
266      *
267      * _Available since v3.1._
268      */
269     function functionCall(
270         address target,
271         bytes memory data,
272         string memory errorMessage
273     ) internal returns (bytes memory) {
274         return functionCallWithValue(target, data, 0, errorMessage);
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
279      * but also transferring `value` wei to `target`.
280      *
281      * Requirements:
282      *
283      * - the calling contract must have an ETH balance of at least `value`.
284      * - the called Solidity function must be `payable`.
285      *
286      * _Available since v3.1._
287      */
288     function functionCallWithValue(
289         address target,
290         bytes memory data,
291         uint256 value
292     ) internal returns (bytes memory) {
293         return
294             functionCallWithValue(
295                 target,
296                 data,
297                 value,
298                 "Address: low-level call with value failed"
299             );
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
304      * with `errorMessage` as a fallback revert reason when `target` reverts.
305      *
306      * _Available since v3.1._
307      */
308     function functionCallWithValue(
309         address target,
310         bytes memory data,
311         uint256 value,
312         string memory errorMessage
313     ) internal returns (bytes memory) {
314         require(
315             address(this).balance >= value,
316             "Address: insufficient balance for call"
317         );
318         require(isContract(target), "Address: call to non-contract");
319 
320         (bool success, bytes memory returndata) = target.call{value: value}(
321             data
322         );
323         return verifyCallResult(success, returndata, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but performing a static call.
329      *
330      * _Available since v3.3._
331      */
332     function functionStaticCall(address target, bytes memory data)
333         internal
334         view
335         returns (bytes memory)
336     {
337         return
338             functionStaticCall(
339                 target,
340                 data,
341                 "Address: low-level static call failed"
342             );
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
347      * but performing a static call.
348      *
349      * _Available since v3.3._
350      */
351     function functionStaticCall(
352         address target,
353         bytes memory data,
354         string memory errorMessage
355     ) internal view returns (bytes memory) {
356         require(isContract(target), "Address: static call to non-contract");
357 
358         (bool success, bytes memory returndata) = target.staticcall(data);
359         return verifyCallResult(success, returndata, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but performing a delegate call.
365      *
366      * _Available since v3.4._
367      */
368     function functionDelegateCall(address target, bytes memory data)
369         internal
370         returns (bytes memory)
371     {
372         return
373             functionDelegateCall(
374                 target,
375                 data,
376                 "Address: low-level delegate call failed"
377             );
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a delegate call.
383      *
384      * _Available since v3.4._
385      */
386     function functionDelegateCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         require(isContract(target), "Address: delegate call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.delegatecall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
399      * revert reason using the provided one.
400      *
401      * _Available since v4.3._
402      */
403     function verifyCallResult(
404         bool success,
405         bytes memory returndata,
406         string memory errorMessage
407     ) internal pure returns (bytes memory) {
408         if (success) {
409             return returndata;
410         } else {
411             // Look for revert reason and bubble it up if present
412             if (returndata.length > 0) {
413                 // The easiest way to bubble the revert reason is using memory via assembly
414 
415                 assembly {
416                     let returndata_size := mload(returndata)
417                     revert(add(32, returndata), returndata_size)
418                 }
419             } else {
420                 revert(errorMessage);
421             }
422         }
423     }
424 }
425 
426 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
427 
428 pragma solidity ^0.8.0;
429 
430 /**
431  * @title ERC721 token receiver interface
432  * @dev Interface for any contract that wants to support safeTransfers
433  * from ERC721 asset contracts.
434  */
435 interface IERC721Receiver {
436     /**
437      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
438      * by `operator` from `from`, this function is called.
439      *
440      * It must return its Solidity selector to confirm the token transfer.
441      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
442      *
443      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
444      */
445     function onERC721Received(
446         address operator,
447         address from,
448         uint256 tokenId,
449         bytes calldata data
450     ) external returns (bytes4);
451 }
452 
453 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
454 
455 pragma solidity ^0.8.0;
456 
457 /**
458  * @dev Interface of the ERC165 standard, as defined in the
459  * https://eips.ethereum.org/EIPS/eip-165[EIP].
460  *
461  * Implementers can declare support of contract interfaces, which can then be
462  * queried by others ({ERC165Checker}).
463  *
464  * For an implementation, see {ERC165}.
465  */
466 interface IERC165 {
467     /**
468      * @dev Returns true if this contract implements the interface defined by
469      * `interfaceId`. See the corresponding
470      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
471      * to learn more about how these ids are created.
472      *
473      * This function call must use less than 30 000 gas.
474      */
475     function supportsInterface(bytes4 interfaceId) external view returns (bool);
476 }
477 
478 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
479 
480 pragma solidity ^0.8.0;
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
500     function supportsInterface(bytes4 interfaceId)
501         public
502         view
503         virtual
504         override
505         returns (bool)
506     {
507         return interfaceId == type(IERC165).interfaceId;
508     }
509 }
510 
511 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @dev Required interface of an ERC721 compliant contract.
517  */
518 interface IERC721 is IERC165 {
519     /**
520      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
521      */
522     event Transfer(
523         address indexed from,
524         address indexed to,
525         uint256 indexed tokenId
526     );
527 
528     /**
529      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
530      */
531     event Approval(
532         address indexed owner,
533         address indexed approved,
534         uint256 indexed tokenId
535     );
536 
537     /**
538      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
539      */
540     event ApprovalForAll(
541         address indexed owner,
542         address indexed operator,
543         bool approved
544     );
545 
546     /**
547      * @dev Returns the number of tokens in ``owner``'s account.
548      */
549     function balanceOf(address owner) external view returns (uint256 balance);
550 
551     /**
552      * @dev Returns the owner of the `tokenId` token.
553      *
554      * Requirements:
555      *
556      * - `tokenId` must exist.
557      */
558     function ownerOf(uint256 tokenId) external view returns (address owner);
559 
560     /**
561      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
562      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
563      *
564      * Requirements:
565      *
566      * - `from` cannot be the zero address.
567      * - `to` cannot be the zero address.
568      * - `tokenId` token must exist and be owned by `from`.
569      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
570      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
571      *
572      * Emits a {Transfer} event.
573      */
574     function safeTransferFrom(
575         address from,
576         address to,
577         uint256 tokenId
578     ) external;
579 
580     /**
581      * @dev Transfers `tokenId` token from `from` to `to`.
582      *
583      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
584      *
585      * Requirements:
586      *
587      * - `from` cannot be the zero address.
588      * - `to` cannot be the zero address.
589      * - `tokenId` token must be owned by `from`.
590      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
591      *
592      * Emits a {Transfer} event.
593      */
594     function transferFrom(
595         address from,
596         address to,
597         uint256 tokenId
598     ) external;
599 
600     /**
601      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
602      * The approval is cleared when the token is transferred.
603      *
604      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
605      *
606      * Requirements:
607      *
608      * - The caller must own the token or be an approved operator.
609      * - `tokenId` must exist.
610      *
611      * Emits an {Approval} event.
612      */
613     function approve(address to, uint256 tokenId) external;
614 
615     /**
616      * @dev Returns the account approved for `tokenId` token.
617      *
618      * Requirements:
619      *
620      * - `tokenId` must exist.
621      */
622     function getApproved(uint256 tokenId)
623         external
624         view
625         returns (address operator);
626 
627     /**
628      * @dev Approve or remove `operator` as an operator for the caller.
629      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
630      *
631      * Requirements:
632      *
633      * - The `operator` cannot be the caller.
634      *
635      * Emits an {ApprovalForAll} event.
636      */
637     function setApprovalForAll(address operator, bool _approved) external;
638 
639     /**
640      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
641      *
642      * See {setApprovalForAll}
643      */
644     function isApprovedForAll(address owner, address operator)
645         external
646         view
647         returns (bool);
648 
649     /**
650      * @dev Safely transfers `tokenId` token from `from` to `to`.
651      *
652      * Requirements:
653      *
654      * - `from` cannot be the zero address.
655      * - `to` cannot be the zero address.
656      * - `tokenId` token must exist and be owned by `from`.
657      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
658      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
659      *
660      * Emits a {Transfer} event.
661      */
662     function safeTransferFrom(
663         address from,
664         address to,
665         uint256 tokenId,
666         bytes calldata data
667     ) external;
668 }
669 
670 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
671 
672 pragma solidity ^0.8.0;
673 
674 /**
675  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
676  * @dev See https://eips.ethereum.org/EIPS/eip-721
677  */
678 interface IERC721Enumerable is IERC721 {
679     /**
680      * @dev Returns the total amount of tokens stored by the contract.
681      */
682     function totalSupply() external view returns (uint256);
683 
684     /**
685      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
686      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
687      */
688     function tokenOfOwnerByIndex(address owner, uint256 index)
689         external
690         view
691         returns (uint256 tokenId);
692 
693     /**
694      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
695      * Use along with {totalSupply} to enumerate all tokens.
696      */
697     function tokenByIndex(uint256 index) external view returns (uint256);
698 }
699 
700 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
701 
702 pragma solidity ^0.8.0;
703 
704 /**
705  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
706  * @dev See https://eips.ethereum.org/EIPS/eip-721
707  */
708 interface IERC721Metadata is IERC721 {
709     /**
710      * @dev Returns the token collection name.
711      */
712     function name() external view returns (string memory);
713 
714     /**
715      * @dev Returns the token collection symbol.
716      */
717     function symbol() external view returns (string memory);
718 
719     /**
720      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
721      */
722     function tokenURI(uint256 tokenId) external view returns (string memory);
723 }
724 
725 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
726 
727 pragma solidity ^0.8.0;
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
1215 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1216 
1217 pragma solidity ^0.8.0;
1218 
1219 /**
1220  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1221  * enumerability of all the token ids in the contract as well as all token ids owned by each
1222  * account.
1223  */
1224 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1225     // Mapping from owner to list of owned token IDs
1226     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1227 
1228     // Mapping from token ID to index of the owner tokens list
1229     mapping(uint256 => uint256) private _ownedTokensIndex;
1230 
1231     // Array with all token ids, used for enumeration
1232     uint256[] private _allTokens;
1233 
1234     // Mapping from token id to position in the allTokens array
1235     mapping(uint256 => uint256) private _allTokensIndex;
1236 
1237     /**
1238      * @dev See {IERC165-supportsInterface}.
1239      */
1240     function supportsInterface(bytes4 interfaceId)
1241         public
1242         view
1243         virtual
1244         override(IERC165, ERC721)
1245         returns (bool)
1246     {
1247         return
1248             interfaceId == type(IERC721Enumerable).interfaceId ||
1249             super.supportsInterface(interfaceId);
1250     }
1251 
1252     /**
1253      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1254      */
1255     function tokenOfOwnerByIndex(address owner, uint256 index)
1256         public
1257         view
1258         virtual
1259         override
1260         returns (uint256)
1261     {
1262         require(
1263             index < ERC721.balanceOf(owner),
1264             "ERC721Enumerable: owner index out of bounds"
1265         );
1266         return _ownedTokens[owner][index];
1267     }
1268 
1269     /**
1270      * @dev See {IERC721Enumerable-totalSupply}.
1271      */
1272     function totalSupply() public view virtual override returns (uint256) {
1273         return _allTokens.length;
1274     }
1275 
1276     /**
1277      * @dev See {IERC721Enumerable-tokenByIndex}.
1278      */
1279     function tokenByIndex(uint256 index)
1280         public
1281         view
1282         virtual
1283         override
1284         returns (uint256)
1285     {
1286         require(
1287             index < ERC721Enumerable.totalSupply(),
1288             "ERC721Enumerable: global index out of bounds"
1289         );
1290         return _allTokens[index];
1291     }
1292 
1293     /**
1294      * @dev Hook that is called before any token transfer. This includes minting
1295      * and burning.
1296      *
1297      * Calling conditions:
1298      *
1299      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1300      * transferred to `to`.
1301      * - When `from` is zero, `tokenId` will be minted for `to`.
1302      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1303      * - `from` cannot be the zero address.
1304      * - `to` cannot be the zero address.
1305      *
1306      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1307      */
1308     function _beforeTokenTransfer(
1309         address from,
1310         address to,
1311         uint256 tokenId
1312     ) internal virtual override {
1313         super._beforeTokenTransfer(from, to, tokenId);
1314 
1315         if (from == address(0)) {
1316             _addTokenToAllTokensEnumeration(tokenId);
1317         } else if (from != to) {
1318             _removeTokenFromOwnerEnumeration(from, tokenId);
1319         }
1320         if (to == address(0)) {
1321             _removeTokenFromAllTokensEnumeration(tokenId);
1322         } else if (to != from) {
1323             _addTokenToOwnerEnumeration(to, tokenId);
1324         }
1325     }
1326 
1327     /**
1328      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1329      * @param to address representing the new owner of the given token ID
1330      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1331      */
1332     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1333         uint256 length = ERC721.balanceOf(to);
1334         _ownedTokens[to][length] = tokenId;
1335         _ownedTokensIndex[tokenId] = length;
1336     }
1337 
1338     /**
1339      * @dev Private function to add a token to this extension's token tracking data structures.
1340      * @param tokenId uint256 ID of the token to be added to the tokens list
1341      */
1342     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1343         _allTokensIndex[tokenId] = _allTokens.length;
1344         _allTokens.push(tokenId);
1345     }
1346 
1347     /**
1348      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1349      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1350      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1351      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1352      * @param from address representing the previous owner of the given token ID
1353      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1354      */
1355     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1356         private
1357     {
1358         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1359         // then delete the last slot (swap and pop).
1360 
1361         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1362         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1363 
1364         // When the token to delete is the last token, the swap operation is unnecessary
1365         if (tokenIndex != lastTokenIndex) {
1366             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1367 
1368             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1369             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1370         }
1371 
1372         // This also deletes the contents at the last position of the array
1373         delete _ownedTokensIndex[tokenId];
1374         delete _ownedTokens[from][lastTokenIndex];
1375     }
1376 
1377     /**
1378      * @dev Private function to remove a token from this extension's token tracking data structures.
1379      * This has O(1) time complexity, but alters the order of the _allTokens array.
1380      * @param tokenId uint256 ID of the token to be removed from the tokens list
1381      */
1382     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1383         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1384         // then delete the last slot (swap and pop).
1385 
1386         uint256 lastTokenIndex = _allTokens.length - 1;
1387         uint256 tokenIndex = _allTokensIndex[tokenId];
1388 
1389         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1390         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1391         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1392         uint256 lastTokenId = _allTokens[lastTokenIndex];
1393 
1394         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1395         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1396 
1397         // This also deletes the contents at the last position of the array
1398         delete _allTokensIndex[tokenId];
1399         _allTokens.pop();
1400     }
1401 }
1402 
1403 // File: verified-sources/0x2F8978510827FfE24d1098203DD2c85ca3a0cEbd/sources/contracts/Redneck.sol
1404 
1405 // SPDX-License-Identifier: UNLICENSED
1406 pragma solidity >=0.8.0 <0.9.0;
1407 
1408 contract RanchyRednecks is ERC721Enumerable, Ownable {
1409     using Strings for uint256;
1410 
1411     string public baseURI;
1412     string public notRevealedUri;
1413     uint256 public constant MAX_SUPPLY = 1000;
1414     uint256 public cost = 0.05 ether;
1415     uint256 public maxMintAmount = 3;
1416     bool public isPaused = true;
1417     bool public isRevealed = false;
1418     bool public isOnlyWhitelisted = true;
1419     address public dev = 0x51D8f89Fae2e82c4bAcF6Ec270f36624bc9C6D1E;
1420     address public art = 0x0282d4Dfb211C890a358B38893e8d66786f5a756;
1421     address public hip = 0xB6e6Ba7a8a8F57f918F7F192ef3EaBe2d48E0351;
1422     address[] public whitelistedAddresses;
1423     mapping(address => uint256) public addressMintedBalance;
1424 
1425     event NewRedneckMinted(address sender, uint256 tokenId);
1426 
1427     constructor(
1428         string memory _name,
1429         string memory _symbol,
1430         string memory _initNotRevealedUri
1431     ) ERC721(_name, _symbol) {
1432         setNotRevealedURI(_initNotRevealedUri);
1433     }
1434 
1435     function _baseURI() internal view virtual override returns (string memory) {
1436         return baseURI;
1437     }
1438 
1439     function mint(uint256 _mintAmount) public payable {
1440         require(!isPaused);
1441         require(_mintAmount > 0);
1442         require(_mintAmount <= maxMintAmount || msg.sender == owner());
1443         require(
1444             addressMintedBalance[msg.sender] + _mintAmount <= maxMintAmount ||
1445                 msg.sender == owner()
1446         );
1447         require(totalSupply() + _mintAmount <= MAX_SUPPLY);
1448 
1449         if (msg.sender != owner()) {
1450             if (isOnlyWhitelisted) {
1451                 require(isWhitelisted(msg.sender));
1452             }
1453             require(msg.value >= cost * _mintAmount);
1454         }
1455 
1456         for (uint256 i = 1; i <= _mintAmount; i++) {
1457             uint256 id = totalSupply() + 1;
1458             addressMintedBalance[msg.sender]++;
1459             _safeMint(msg.sender, id);
1460             emit NewRedneckMinted(msg.sender, id);
1461         }
1462     }
1463 
1464     function isWhitelisted(address _user) public view returns (bool) {
1465         for (uint256 i = 0; i < whitelistedAddresses.length; i++) {
1466             if (whitelistedAddresses[i] == _user) {
1467                 return true;
1468             }
1469         }
1470         return false;
1471     }
1472 
1473     function tokenURI(uint256 tokenId)
1474         public
1475         view
1476         virtual
1477         override
1478         returns (string memory)
1479     {
1480         require(_exists(tokenId));
1481 
1482         if (!isRevealed) {
1483             return notRevealedUri;
1484         }
1485 
1486         string memory currentBaseURI = _baseURI();
1487         return
1488             bytes(currentBaseURI).length > 0
1489                 ? string(
1490                     abi.encodePacked(
1491                         currentBaseURI,
1492                         tokenId.toString(),
1493                         ".json"
1494                     )
1495                 )
1496                 : "";
1497     }
1498 
1499     function setIsRevealed(bool _status) public onlyOwner {
1500         if (_status) require(bytes(baseURI).length > 0);
1501         isRevealed = _status;
1502     }
1503 
1504     function setCost(uint256 _newCost) public onlyOwner {
1505         cost = _newCost;
1506     }
1507 
1508     function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1509         maxMintAmount = _newmaxMintAmount;
1510     }
1511 
1512     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1513         notRevealedUri = _notRevealedURI;
1514     }
1515 
1516     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1517         baseURI = _newBaseURI;
1518     }
1519 
1520     function setIsPaused(bool _state) public onlyOwner {
1521         isPaused = _state;
1522     }
1523 
1524     function setIsOnlyWhitelisted(bool _state) public onlyOwner {
1525         isOnlyWhitelisted = _state;
1526     }
1527 
1528     function setWhitelistUsers(address[] calldata _users) public onlyOwner {
1529         delete whitelistedAddresses;
1530         whitelistedAddresses = _users;
1531     }
1532 
1533     function withdraw() public payable onlyOwner {
1534         uint256 balance = address(this).balance;
1535         (bool successA, ) = payable(dev).call{value: (balance / 100) * 15}("");
1536         (bool successB, ) = payable(art).call{value: (balance / 100) * 25}("");
1537         (bool successC, ) = payable(hip).call{value: (balance / 100) * 30}("");
1538         (bool successD, ) = payable(msg.sender).call{
1539             value: (balance / 100) * 30
1540         }("");
1541         require(successA && successB && successC && successD);
1542     }
1543 }