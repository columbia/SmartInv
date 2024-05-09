1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev String operations.
8  */
9 library Strings {
10     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
11 
12     /**
13      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
14      */
15     function toString(uint256 value) internal pure returns (string memory) {
16         // Inspired by OraclizeAPI's implementation - MIT licence
17         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
18 
19         if (value == 0) {
20             return "0";
21         }
22         uint256 temp = value;
23         uint256 digits;
24         while (temp != 0) {
25             digits++;
26             temp /= 10;
27         }
28         bytes memory buffer = new bytes(digits);
29         while (value != 0) {
30             digits -= 1;
31             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
32             value /= 10;
33         }
34         return string(buffer);
35     }
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
39      */
40     function toHexString(uint256 value) internal pure returns (string memory) {
41         if (value == 0) {
42             return "0x00";
43         }
44         uint256 temp = value;
45         uint256 length = 0;
46         while (temp != 0) {
47             length++;
48             temp >>= 8;
49         }
50         return toHexString(value, length);
51     }
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
55      */
56     function toHexString(uint256 value, uint256 length)
57         internal
58         pure
59         returns (string memory)
60     {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Context.sol
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @dev Provides information about the current execution context, including the
79  * sender of the transaction and its data. While these are generally available
80  * via msg.sender and msg.data, they should not be accessed in such a direct
81  * manner, since when dealing with meta-transactions the account sending and
82  * paying for execution may not be the actual sender (as far as an application
83  * is concerned).
84  *
85  * This contract is only required for intermediate, library-like contracts.
86  */
87 abstract contract Context {
88     function _msgSender() internal view virtual returns (address) {
89         return msg.sender;
90     }
91 
92     function _msgData() internal view virtual returns (bytes calldata) {
93         return msg.data;
94     }
95 }
96 
97 // File: @openzeppelin/contracts/access/Ownable.sol
98 
99 pragma solidity ^0.8.0;
100 
101 /**
102  * @dev Contract module which provides a basic access control mechanism, where
103  * there is an account (an owner) that can be granted exclusive access to
104  * specific functions.
105  *
106  * By default, the owner account will be the one that deploys the contract. This
107  * can later be changed with {transferOwnership}.
108  *
109  * This module is used through inheritance. It will make available the modifier
110  * `onlyOwner`, which can be applied to your functions to restrict their use to
111  * the owner.
112  */
113 abstract contract Ownable is Context {
114     address private _owner;
115 
116     event OwnershipTransferred(
117         address indexed previousOwner,
118         address indexed newOwner
119     );
120 
121     /**
122      * @dev Initializes the contract setting the deployer as the initial owner.
123      */
124     constructor() {
125         _setOwner(_msgSender());
126     }
127 
128     /**
129      * @dev Returns the address of the current owner.
130      */
131     function owner() public view virtual returns (address) {
132         return _owner;
133     }
134 
135     /**
136      * @dev Throws if called by any account other than the owner.
137      */
138     modifier onlyOwner() {
139         require(owner() == _msgSender(), "Ownable: caller is not the owner");
140         _;
141     }
142 
143     /**
144      * @dev Leaves the contract without owner. It will not be possible to call
145      * `onlyOwner` functions anymore. Can only be called by the current owner.
146      *
147      * NOTE: Renouncing ownership will leave the contract without an owner,
148      * thereby removing any functionality that is only available to the owner.
149      */
150     function renounceOwnership() public virtual onlyOwner {
151         _setOwner(address(0));
152     }
153 
154     /**
155      * @dev Transfers ownership of the contract to a new account (`newOwner`).
156      * Can only be called by the current owner.
157      */
158     function transferOwnership(address newOwner) public virtual onlyOwner {
159         require(
160             newOwner != address(0),
161             "Ownable: new owner is the zero address"
162         );
163         _setOwner(newOwner);
164     }
165 
166     function _setOwner(address newOwner) private {
167         address oldOwner = _owner;
168         _owner = newOwner;
169         emit OwnershipTransferred(oldOwner, newOwner);
170     }
171 }
172 
173 // File: @openzeppelin/contracts/utils/Address.sol
174 
175 pragma solidity ^0.8.0;
176 
177 /**
178  * @dev Collection of functions related to the address type
179  */
180 library Address {
181     /**
182      * @dev Returns true if `account` is a contract.
183      *
184      * [IMPORTANT]
185      * ====
186      * It is unsafe to assume that an address for which this function returns
187      * false is an externally-owned account (EOA) and not a contract.
188      *
189      * Among others, `isContract` will return false for the following
190      * types of addresses:
191      *
192      *  - an externally-owned account
193      *  - a contract in construction
194      *  - an address where a contract will be created
195      *  - an address where a contract lived, but was destroyed
196      * ====
197      */
198     function isContract(address account) internal view returns (bool) {
199         // This method relies on extcodesize, which returns 0 for contracts in
200         // construction, since the code is only stored at the end of the
201         // constructor execution.
202 
203         uint256 size;
204         assembly {
205             size := extcodesize(account)
206         }
207         return size > 0;
208     }
209 
210     /**
211      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
212      * `recipient`, forwarding all available gas and reverting on errors.
213      *
214      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
215      * of certain opcodes, possibly making contracts go over the 2300 gas limit
216      * imposed by `transfer`, making them unable to receive funds via
217      * `transfer`. {sendValue} removes this limitation.
218      *
219      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
220      *
221      * IMPORTANT: because control is transferred to `recipient`, care must be
222      * taken to not create reentrancy vulnerabilities. Consider using
223      * {ReentrancyGuard} or the
224      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
225      */
226     function sendValue(address payable recipient, uint256 amount) internal {
227         require(
228             address(this).balance >= amount,
229             "Address: insufficient balance"
230         );
231 
232         (bool success, ) = recipient.call{value: amount}("");
233         require(
234             success,
235             "Address: unable to send value, recipient may have reverted"
236         );
237     }
238 
239     /**
240      * @dev Performs a Solidity function call using a low level `call`. A
241      * plain `call` is an unsafe replacement for a function call: use this
242      * function instead.
243      *
244      * If `target` reverts with a revert reason, it is bubbled up by this
245      * function (like regular Solidity function calls).
246      *
247      * Returns the raw returned data. To convert to the expected return value,
248      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
249      *
250      * Requirements:
251      *
252      * - `target` must be a contract.
253      * - calling `target` with `data` must not revert.
254      *
255      * _Available since v3.1._
256      */
257     function functionCall(address target, bytes memory data)
258         internal
259         returns (bytes memory)
260     {
261         return functionCall(target, data, "Address: low-level call failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
266      * `errorMessage` as a fallback revert reason when `target` reverts.
267      *
268      * _Available since v3.1._
269      */
270     function functionCall(
271         address target,
272         bytes memory data,
273         string memory errorMessage
274     ) internal returns (bytes memory) {
275         return functionCallWithValue(target, data, 0, errorMessage);
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
280      * but also transferring `value` wei to `target`.
281      *
282      * Requirements:
283      *
284      * - the calling contract must have an ETH balance of at least `value`.
285      * - the called Solidity function must be `payable`.
286      *
287      * _Available since v3.1._
288      */
289     function functionCallWithValue(
290         address target,
291         bytes memory data,
292         uint256 value
293     ) internal returns (bytes memory) {
294         return
295             functionCallWithValue(
296                 target,
297                 data,
298                 value,
299                 "Address: low-level call with value failed"
300             );
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
305      * with `errorMessage` as a fallback revert reason when `target` reverts.
306      *
307      * _Available since v3.1._
308      */
309     function functionCallWithValue(
310         address target,
311         bytes memory data,
312         uint256 value,
313         string memory errorMessage
314     ) internal returns (bytes memory) {
315         require(
316             address(this).balance >= value,
317             "Address: insufficient balance for call"
318         );
319         require(isContract(target), "Address: call to non-contract");
320 
321         (bool success, bytes memory returndata) = target.call{value: value}(
322             data
323         );
324         return verifyCallResult(success, returndata, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but performing a static call.
330      *
331      * _Available since v3.3._
332      */
333     function functionStaticCall(address target, bytes memory data)
334         internal
335         view
336         returns (bytes memory)
337     {
338         return
339             functionStaticCall(
340                 target,
341                 data,
342                 "Address: low-level static call failed"
343             );
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
348      * but performing a static call.
349      *
350      * _Available since v3.3._
351      */
352     function functionStaticCall(
353         address target,
354         bytes memory data,
355         string memory errorMessage
356     ) internal view returns (bytes memory) {
357         require(isContract(target), "Address: static call to non-contract");
358 
359         (bool success, bytes memory returndata) = target.staticcall(data);
360         return verifyCallResult(success, returndata, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but performing a delegate call.
366      *
367      * _Available since v3.4._
368      */
369     function functionDelegateCall(address target, bytes memory data)
370         internal
371         returns (bytes memory)
372     {
373         return
374             functionDelegateCall(
375                 target,
376                 data,
377                 "Address: low-level delegate call failed"
378             );
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
383      * but performing a delegate call.
384      *
385      * _Available since v3.4._
386      */
387     function functionDelegateCall(
388         address target,
389         bytes memory data,
390         string memory errorMessage
391     ) internal returns (bytes memory) {
392         require(isContract(target), "Address: delegate call to non-contract");
393 
394         (bool success, bytes memory returndata) = target.delegatecall(data);
395         return verifyCallResult(success, returndata, errorMessage);
396     }
397 
398     /**
399      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
400      * revert reason using the provided one.
401      *
402      * _Available since v4.3._
403      */
404     function verifyCallResult(
405         bool success,
406         bytes memory returndata,
407         string memory errorMessage
408     ) internal pure returns (bytes memory) {
409         if (success) {
410             return returndata;
411         } else {
412             // Look for revert reason and bubble it up if present
413             if (returndata.length > 0) {
414                 // The easiest way to bubble the revert reason is using memory via assembly
415 
416                 assembly {
417                     let returndata_size := mload(returndata)
418                     revert(add(32, returndata), returndata_size)
419                 }
420             } else {
421                 revert(errorMessage);
422             }
423         }
424     }
425 }
426 
427 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
428 
429 pragma solidity ^0.8.0;
430 
431 /**
432  * @title ERC721 token receiver interface
433  * @dev Interface for any contract that wants to support safeTransfers
434  * from ERC721 asset contracts.
435  */
436 interface IERC721Receiver {
437     /**
438      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
439      * by `operator` from `from`, this function is called.
440      *
441      * It must return its Solidity selector to confirm the token transfer.
442      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
443      *
444      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
445      */
446     function onERC721Received(
447         address operator,
448         address from,
449         uint256 tokenId,
450         bytes calldata data
451     ) external returns (bytes4);
452 }
453 
454 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @dev Interface of the ERC165 standard, as defined in the
460  * https://eips.ethereum.org/EIPS/eip-165[EIP].
461  *
462  * Implementers can declare support of contract interfaces, which can then be
463  * queried by others ({ERC165Checker}).
464  *
465  * For an implementation, see {ERC165}.
466  */
467 interface IERC165 {
468     /**
469      * @dev Returns true if this contract implements the interface defined by
470      * `interfaceId`. See the corresponding
471      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
472      * to learn more about how these ids are created.
473      *
474      * This function call must use less than 30 000 gas.
475      */
476     function supportsInterface(bytes4 interfaceId) external view returns (bool);
477 }
478 
479 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
480 
481 pragma solidity ^0.8.0;
482 
483 /**
484  * @dev Implementation of the {IERC165} interface.
485  *
486  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
487  * for the additional interface id that will be supported. For example:
488  *
489  * ```solidity
490  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
491  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
492  * }
493  * ```
494  *
495  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
496  */
497 abstract contract ERC165 is IERC165 {
498     /**
499      * @dev See {IERC165-supportsInterface}.
500      */
501     function supportsInterface(bytes4 interfaceId)
502         public
503         view
504         virtual
505         override
506         returns (bool)
507     {
508         return interfaceId == type(IERC165).interfaceId;
509     }
510 }
511 
512 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
513 
514 pragma solidity ^0.8.0;
515 
516 /**
517  * @dev Required interface of an ERC721 compliant contract.
518  */
519 interface IERC721 is IERC165 {
520     /**
521      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
522      */
523     event Transfer(
524         address indexed from,
525         address indexed to,
526         uint256 indexed tokenId
527     );
528 
529     /**
530      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
531      */
532     event Approval(
533         address indexed owner,
534         address indexed approved,
535         uint256 indexed tokenId
536     );
537 
538     /**
539      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
540      */
541     event ApprovalForAll(
542         address indexed owner,
543         address indexed operator,
544         bool approved
545     );
546 
547     /**
548      * @dev Returns the number of tokens in ``owner``'s account.
549      */
550     function balanceOf(address owner) external view returns (uint256 balance);
551 
552     /**
553      * @dev Returns the owner of the `tokenId` token.
554      *
555      * Requirements:
556      *
557      * - `tokenId` must exist.
558      */
559     function ownerOf(uint256 tokenId) external view returns (address owner);
560 
561     /**
562      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
563      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
564      *
565      * Requirements:
566      *
567      * - `from` cannot be the zero address.
568      * - `to` cannot be the zero address.
569      * - `tokenId` token must exist and be owned by `from`.
570      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
571      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
572      *
573      * Emits a {Transfer} event.
574      */
575     function safeTransferFrom(
576         address from,
577         address to,
578         uint256 tokenId
579     ) external;
580 
581     /**
582      * @dev Transfers `tokenId` token from `from` to `to`.
583      *
584      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
585      *
586      * Requirements:
587      *
588      * - `from` cannot be the zero address.
589      * - `to` cannot be the zero address.
590      * - `tokenId` token must be owned by `from`.
591      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
592      *
593      * Emits a {Transfer} event.
594      */
595     function transferFrom(
596         address from,
597         address to,
598         uint256 tokenId
599     ) external;
600 
601     /**
602      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
603      * The approval is cleared when the token is transferred.
604      *
605      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
606      *
607      * Requirements:
608      *
609      * - The caller must own the token or be an approved operator.
610      * - `tokenId` must exist.
611      *
612      * Emits an {Approval} event.
613      */
614     function approve(address to, uint256 tokenId) external;
615 
616     /**
617      * @dev Returns the account approved for `tokenId` token.
618      *
619      * Requirements:
620      *
621      * - `tokenId` must exist.
622      */
623     function getApproved(uint256 tokenId)
624         external
625         view
626         returns (address operator);
627 
628     /**
629      * @dev Approve or remove `operator` as an operator for the caller.
630      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
631      *
632      * Requirements:
633      *
634      * - The `operator` cannot be the caller.
635      *
636      * Emits an {ApprovalForAll} event.
637      */
638     function setApprovalForAll(address operator, bool _approved) external;
639 
640     /**
641      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
642      *
643      * See {setApprovalForAll}
644      */
645     function isApprovedForAll(address owner, address operator)
646         external
647         view
648         returns (bool);
649 
650     /**
651      * @dev Safely transfers `tokenId` token from `from` to `to`.
652      *
653      * Requirements:
654      *
655      * - `from` cannot be the zero address.
656      * - `to` cannot be the zero address.
657      * - `tokenId` token must exist and be owned by `from`.
658      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
659      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
660      *
661      * Emits a {Transfer} event.
662      */
663     function safeTransferFrom(
664         address from,
665         address to,
666         uint256 tokenId,
667         bytes calldata data
668     ) external;
669 }
670 
671 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
672 
673 pragma solidity ^0.8.0;
674 
675 /**
676  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
677  * @dev See https://eips.ethereum.org/EIPS/eip-721
678  */
679 interface IERC721Enumerable is IERC721 {
680     /**
681      * @dev Returns the total amount of tokens stored by the contract.
682      */
683     function totalSupply() external view returns (uint256);
684 
685     /**
686      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
687      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
688      */
689     function tokenOfOwnerByIndex(address owner, uint256 index)
690         external
691         view
692         returns (uint256 tokenId);
693 
694     /**
695      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
696      * Use along with {totalSupply} to enumerate all tokens.
697      */
698     function tokenByIndex(uint256 index) external view returns (uint256);
699 }
700 
701 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
702 
703 pragma solidity ^0.8.0;
704 
705 /**
706  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
707  * @dev See https://eips.ethereum.org/EIPS/eip-721
708  */
709 interface IERC721Metadata is IERC721 {
710     /**
711      * @dev Returns the token collection name.
712      */
713     function name() external view returns (string memory);
714 
715     /**
716      * @dev Returns the token collection symbol.
717      */
718     function symbol() external view returns (string memory);
719 
720     /**
721      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
722      */
723     function tokenURI(uint256 tokenId) external view returns (string memory);
724 }
725 
726 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
727 
728 pragma solidity ^0.8.0;
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
1216 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1217 
1218 pragma solidity ^0.8.0;
1219 
1220 /**
1221  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1222  * enumerability of all the token ids in the contract as well as all token ids owned by each
1223  * account.
1224  */
1225 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1226     // Mapping from owner to list of owned token IDs
1227     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1228 
1229     // Mapping from token ID to index of the owner tokens list
1230     mapping(uint256 => uint256) private _ownedTokensIndex;
1231 
1232     // Array with all token ids, used for enumeration
1233     uint256[] private _allTokens;
1234 
1235     // Mapping from token id to position in the allTokens array
1236     mapping(uint256 => uint256) private _allTokensIndex;
1237 
1238     /**
1239      * @dev See {IERC165-supportsInterface}.
1240      */
1241     function supportsInterface(bytes4 interfaceId)
1242         public
1243         view
1244         virtual
1245         override(IERC165, ERC721)
1246         returns (bool)
1247     {
1248         return
1249             interfaceId == type(IERC721Enumerable).interfaceId ||
1250             super.supportsInterface(interfaceId);
1251     }
1252 
1253     /**
1254      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1255      */
1256     function tokenOfOwnerByIndex(address owner, uint256 index)
1257         public
1258         view
1259         virtual
1260         override
1261         returns (uint256)
1262     {
1263         require(
1264             index < ERC721.balanceOf(owner),
1265             "ERC721Enumerable: owner index out of bounds"
1266         );
1267         return _ownedTokens[owner][index];
1268     }
1269 
1270     /**
1271      * @dev See {IERC721Enumerable-totalSupply}.
1272      */
1273     function totalSupply() public view virtual override returns (uint256) {
1274         return _allTokens.length;
1275     }
1276 
1277     /**
1278      * @dev See {IERC721Enumerable-tokenByIndex}.
1279      */
1280     function tokenByIndex(uint256 index)
1281         public
1282         view
1283         virtual
1284         override
1285         returns (uint256)
1286     {
1287         require(
1288             index < ERC721Enumerable.totalSupply(),
1289             "ERC721Enumerable: global index out of bounds"
1290         );
1291         return _allTokens[index];
1292     }
1293 
1294     /**
1295      * @dev Hook that is called before any token transfer. This includes minting
1296      * and burning.
1297      *
1298      * Calling conditions:
1299      *
1300      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1301      * transferred to `to`.
1302      * - When `from` is zero, `tokenId` will be minted for `to`.
1303      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1304      * - `from` cannot be the zero address.
1305      * - `to` cannot be the zero address.
1306      *
1307      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1308      */
1309     function _beforeTokenTransfer(
1310         address from,
1311         address to,
1312         uint256 tokenId
1313     ) internal virtual override {
1314         super._beforeTokenTransfer(from, to, tokenId);
1315 
1316         if (from == address(0)) {
1317             _addTokenToAllTokensEnumeration(tokenId);
1318         } else if (from != to) {
1319             _removeTokenFromOwnerEnumeration(from, tokenId);
1320         }
1321         if (to == address(0)) {
1322             _removeTokenFromAllTokensEnumeration(tokenId);
1323         } else if (to != from) {
1324             _addTokenToOwnerEnumeration(to, tokenId);
1325         }
1326     }
1327 
1328     /**
1329      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1330      * @param to address representing the new owner of the given token ID
1331      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1332      */
1333     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1334         uint256 length = ERC721.balanceOf(to);
1335         _ownedTokens[to][length] = tokenId;
1336         _ownedTokensIndex[tokenId] = length;
1337     }
1338 
1339     /**
1340      * @dev Private function to add a token to this extension's token tracking data structures.
1341      * @param tokenId uint256 ID of the token to be added to the tokens list
1342      */
1343     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1344         _allTokensIndex[tokenId] = _allTokens.length;
1345         _allTokens.push(tokenId);
1346     }
1347 
1348     /**
1349      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1350      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1351      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1352      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1353      * @param from address representing the previous owner of the given token ID
1354      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1355      */
1356     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1357         private
1358     {
1359         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1360         // then delete the last slot (swap and pop).
1361 
1362         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1363         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1364 
1365         // When the token to delete is the last token, the swap operation is unnecessary
1366         if (tokenIndex != lastTokenIndex) {
1367             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1368 
1369             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1370             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1371         }
1372 
1373         // This also deletes the contents at the last position of the array
1374         delete _ownedTokensIndex[tokenId];
1375         delete _ownedTokens[from][lastTokenIndex];
1376     }
1377 
1378     /**
1379      * @dev Private function to remove a token from this extension's token tracking data structures.
1380      * This has O(1) time complexity, but alters the order of the _allTokens array.
1381      * @param tokenId uint256 ID of the token to be removed from the tokens list
1382      */
1383     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1384         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1385         // then delete the last slot (swap and pop).
1386 
1387         uint256 lastTokenIndex = _allTokens.length - 1;
1388         uint256 tokenIndex = _allTokensIndex[tokenId];
1389 
1390         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1391         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1392         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1393         uint256 lastTokenId = _allTokens[lastTokenIndex];
1394 
1395         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1396         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1397 
1398         // This also deletes the contents at the last position of the array
1399         delete _allTokensIndex[tokenId];
1400         _allTokens.pop();
1401     }
1402 }
1403 
1404 
1405 pragma solidity >=0.7.0 <0.9.0;
1406 
1407 contract MutantHumanClub is ERC721Enumerable, Ownable {
1408     using Strings for uint256;
1409 
1410     string baseURI;
1411     string public baseExtension = ".json";
1412     uint256 public cost = 90000000000000000;
1413     uint256 public maxSupply = 6666;
1414     uint256 public maxMintAmount = 5;
1415     uint256 public reservedForTeam = 30;
1416 
1417     string private signature;
1418 
1419     bool public paused = false;
1420     bool public revealed = false;
1421 
1422     // Whitelist
1423     uint256 public whitelistMintAmount = 3;
1424     uint256 public whitelistReserved = 4500;
1425     uint256 public whitelistCost = 90000000000000000;
1426 
1427     bool private whitelistedSale = true;
1428     string public notRevealedUri;
1429 
1430     constructor(
1431         string memory _name,
1432         string memory _symbol,
1433         string memory _initBaseURI,
1434         string memory _initNotRevealedUri
1435     ) ERC721(_name, _symbol) {
1436         setBaseURI(_initBaseURI);
1437         setNotRevealedURI(_initNotRevealedUri);
1438     }
1439 
1440     // internal
1441     function _baseURI() internal view virtual override returns (string memory) {
1442         return baseURI;
1443     }
1444 
1445     function presaleMint(uint256 _mintAmount, string memory _signature)
1446         public
1447         payable
1448     {
1449         require(!paused, "Contract is paused");
1450         require(whitelistedSale);
1451         require(
1452             keccak256(abi.encodePacked((signature))) ==
1453                 keccak256(abi.encodePacked((_signature))),
1454             "Invalid signature"
1455         );
1456         require(msg.sender != owner());
1457 
1458         uint256 supply = totalSupply();
1459         uint256 totalAmount;
1460 
1461         uint256 tokenCount = balanceOf(msg.sender);
1462 
1463         require(
1464             tokenCount + _mintAmount <= maxMintAmount,
1465             string(abi.encodePacked("Limit token ", tokenCount.toString()))
1466         );
1467         require(
1468             supply + _mintAmount <= maxSupply - reservedForTeam,
1469             "Max Supply"
1470         );
1471 
1472         // Whitelist
1473         require(whitelistReserved - _mintAmount >= 0);
1474         require(tokenCount + _mintAmount <= whitelistMintAmount);
1475 
1476         totalAmount = whitelistCost * _mintAmount;
1477 
1478         require(
1479             msg.value >= totalAmount,
1480             string(
1481                 abi.encodePacked(
1482                     "Incorrect amount ",
1483                     totalAmount.toString(),
1484                     " ",
1485                     msg.value.toString()
1486                 )
1487             )
1488         );
1489 
1490         whitelistReserved -= _mintAmount;
1491 
1492         for (uint256 i = 1; i <= _mintAmount; i++) {
1493             _safeMint(msg.sender, supply + i);
1494         }
1495     }
1496 
1497     // public
1498     function mint(uint256 _mintAmount) public payable {
1499         uint256 supply = totalSupply();
1500         uint256 totalAmount;
1501 
1502         require(!paused);
1503         require(_mintAmount > 0);
1504 
1505         // Owner
1506         if (msg.sender == owner()) {
1507             require(reservedForTeam >= _mintAmount);
1508             reservedForTeam -= _mintAmount;
1509         }
1510 
1511         if (msg.sender != owner()) {
1512             require(!whitelistedSale);
1513             uint256 tokenCount = balanceOf(msg.sender);
1514 
1515             require(
1516                 tokenCount + _mintAmount <= maxMintAmount,
1517                 string(abi.encodePacked("Limit token ", tokenCount.toString()))
1518             );
1519             require(
1520                 supply + _mintAmount <= maxSupply - reservedForTeam,
1521                 "Max Supply"
1522             );
1523 
1524             totalAmount = cost * _mintAmount;
1525 
1526             require(
1527                 msg.value >= totalAmount,
1528                 string(
1529                     abi.encodePacked(
1530                         "Incorrect amount ",
1531                         totalAmount.toString(),
1532                         " ",
1533                         msg.value.toString()
1534                     )
1535                 )
1536             );
1537         }
1538 
1539         for (uint256 i = 1; i <= _mintAmount; i++) {
1540             _safeMint(msg.sender, supply + i);
1541         }
1542     }
1543 
1544     function walletOfOwner(address _owner)
1545         public
1546         view
1547         returns (uint256[] memory)
1548     {
1549         uint256 ownerTokenCount = balanceOf(_owner);
1550         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1551 
1552         for (uint256 i; i < ownerTokenCount; i++) {
1553             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1554         }
1555         return tokenIds;
1556     }
1557 
1558     function tokenURI(uint256 tokenId)
1559         public
1560         view
1561         virtual
1562         override
1563         returns (string memory)
1564     {
1565         require(
1566             _exists(tokenId),
1567             "ERC721Metadata: URI query for nonexistent token"
1568         );
1569 
1570         if (revealed == false) {
1571             return notRevealedUri;
1572         }
1573 
1574         string memory currentBaseURI = _baseURI();
1575         return
1576             bytes(currentBaseURI).length > 0
1577                 ? string(
1578                     abi.encodePacked(
1579                         currentBaseURI,
1580                         tokenId.toString(),
1581                         baseExtension
1582                     )
1583                 )
1584                 : "";
1585     }
1586 
1587     //only owner
1588     function reveal() public onlyOwner {
1589         revealed = true;
1590     }
1591 
1592     function setReserved(uint256 _reserved) public onlyOwner {
1593         reservedForTeam = _reserved;
1594     }
1595 
1596     function setCost(uint256 _newCost) public onlyOwner {
1597         cost = _newCost;
1598     }
1599 
1600     function setWhitelistCost(uint256 _newCost) public onlyOwner {
1601         whitelistCost = _newCost;
1602     }
1603 
1604     function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1605         maxMintAmount = _newmaxMintAmount;
1606     }
1607 
1608     function setWhitelistMintAmount(uint256 _newmaxMintAmount)
1609         public
1610         onlyOwner
1611     {
1612         whitelistMintAmount = _newmaxMintAmount;
1613     }
1614 
1615     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1616         notRevealedUri = _notRevealedURI;
1617     }
1618 
1619     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1620         baseURI = _newBaseURI;
1621     }
1622 
1623     function setBaseExtension(string memory _newBaseExtension)
1624         public
1625         onlyOwner
1626     {
1627         baseExtension = _newBaseExtension;
1628     }
1629 
1630     function pause(bool _state) public onlyOwner {
1631         paused = _state;
1632     }
1633 
1634     function whitelistSale(bool _state) public onlyOwner {
1635         require(whitelistReserved > 0);
1636         whitelistedSale = _state;
1637     }
1638 
1639     function setSignature(string memory _signature) public onlyOwner {
1640         signature = _signature;
1641     }
1642 
1643     function setWhitelistReserved(uint256 _count) public onlyOwner {
1644         uint256 totalSupply = totalSupply();
1645         require(_count < maxSupply - totalSupply);
1646         whitelistReserved = _count;
1647     }
1648 
1649     function withdraw() public payable onlyOwner {
1650         (bool oa, ) = payable(owner()).call{value: address(this).balance}("");
1651         require(oa);
1652     }
1653 
1654     function getBalance() public view onlyOwner returns (uint256) {
1655         return address(this).balance;
1656     }
1657 
1658     function isWhitelisted() public view returns (bool) {
1659         return whitelistedSale;
1660     }
1661 }