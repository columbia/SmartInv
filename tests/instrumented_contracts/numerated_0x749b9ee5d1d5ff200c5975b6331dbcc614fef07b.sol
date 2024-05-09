1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
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
671 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
672 
673 pragma solidity ^0.8.0;
674 
675 /**
676  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
677  * @dev See https://eips.ethereum.org/EIPS/eip-721
678  */
679 interface IERC721Metadata is IERC721 {
680     /**
681      * @dev Returns the token collection name.
682      */
683     function name() external view returns (string memory);
684 
685     /**
686      * @dev Returns the token collection symbol.
687      */
688     function symbol() external view returns (string memory);
689 
690     /**
691      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
692      */
693     function tokenURI(uint256 tokenId) external view returns (string memory);
694 }
695 
696 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
697 
698 pragma solidity ^0.8.0;
699 
700 /**
701  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
702  * the Metadata extension, but not including the Enumerable extension, which is available separately as
703  * {ERC721Enumerable}.
704  */
705 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
706     using Address for address;
707     using Strings for uint256;
708 
709     // Token name
710     string private _name;
711 
712     // Token symbol
713     string private _symbol;
714 
715     // Mapping from token ID to owner address
716     mapping(uint256 => address) private _owners;
717 
718     // Mapping owner address to token count
719     mapping(address => uint256) private _balances;
720 
721     // Mapping from token ID to approved address
722     mapping(uint256 => address) private _tokenApprovals;
723 
724     // Mapping from owner to operator approvals
725     mapping(address => mapping(address => bool)) private _operatorApprovals;
726 
727     /**
728      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
729      */
730     constructor(string memory name_, string memory symbol_) {
731         _name = name_;
732         _symbol = symbol_;
733     }
734 
735     /**
736      * @dev See {IERC165-supportsInterface}.
737      */
738     function supportsInterface(bytes4 interfaceId)
739         public
740         view
741         virtual
742         override(ERC165, IERC165)
743         returns (bool)
744     {
745         return
746             interfaceId == type(IERC721).interfaceId ||
747             interfaceId == type(IERC721Metadata).interfaceId ||
748             super.supportsInterface(interfaceId);
749     }
750 
751     /**
752      * @dev See {IERC721-balanceOf}.
753      */
754     function balanceOf(address owner)
755         public
756         view
757         virtual
758         override
759         returns (uint256)
760     {
761         require(
762             owner != address(0),
763             "ERC721: balance query for the zero address"
764         );
765         return _balances[owner];
766     }
767 
768     /**
769      * @dev See {IERC721-ownerOf}.
770      */
771     function ownerOf(uint256 tokenId)
772         public
773         view
774         virtual
775         override
776         returns (address)
777     {
778         address owner = _owners[tokenId];
779         require(
780             owner != address(0),
781             "ERC721: owner query for nonexistent token"
782         );
783         return owner;
784     }
785 
786     /**
787      * @dev See {IERC721Metadata-name}.
788      */
789     function name() public view virtual override returns (string memory) {
790         return _name;
791     }
792 
793     /**
794      * @dev See {IERC721Metadata-symbol}.
795      */
796     function symbol() public view virtual override returns (string memory) {
797         return _symbol;
798     }
799 
800     /**
801      * @dev See {IERC721Metadata-tokenURI}.
802      */
803     function tokenURI(uint256 tokenId)
804         public
805         view
806         virtual
807         override
808         returns (string memory)
809     {
810         require(
811             _exists(tokenId),
812             "ERC721Metadata: URI query for nonexistent token"
813         );
814 
815         string memory baseURI = _baseURI();
816         return
817             bytes(baseURI).length > 0
818                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
819                 : "";
820     }
821 
822     /**
823      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
824      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
825      * by default, can be overriden in child contracts.
826      */
827     function _baseURI() internal view virtual returns (string memory) {
828         return "";
829     }
830 
831     /**
832      * @dev See {IERC721-approve}.
833      */
834     function approve(address to, uint256 tokenId) public virtual override {
835         address owner = ERC721.ownerOf(tokenId);
836         require(to != owner, "ERC721: approval to current owner");
837 
838         require(
839             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
840             "ERC721: approve caller is not owner nor approved for all"
841         );
842 
843         _approve(to, tokenId);
844     }
845 
846     /**
847      * @dev See {IERC721-getApproved}.
848      */
849     function getApproved(uint256 tokenId)
850         public
851         view
852         virtual
853         override
854         returns (address)
855     {
856         require(
857             _exists(tokenId),
858             "ERC721: approved query for nonexistent token"
859         );
860 
861         return _tokenApprovals[tokenId];
862     }
863 
864     /**
865      * @dev See {IERC721-setApprovalForAll}.
866      */
867     function setApprovalForAll(address operator, bool approved)
868         public
869         virtual
870         override
871     {
872         require(operator != _msgSender(), "ERC721: approve to caller");
873 
874         _operatorApprovals[_msgSender()][operator] = approved;
875         emit ApprovalForAll(_msgSender(), operator, approved);
876     }
877 
878     /**
879      * @dev See {IERC721-isApprovedForAll}.
880      */
881     function isApprovedForAll(address owner, address operator)
882         public
883         view
884         virtual
885         override
886         returns (bool)
887     {
888         return _operatorApprovals[owner][operator];
889     }
890 
891     /**
892      * @dev See {IERC721-transferFrom}.
893      */
894     function transferFrom(
895         address from,
896         address to,
897         uint256 tokenId
898     ) public virtual override {
899         //solhint-disable-next-line max-line-length
900         require(
901             _isApprovedOrOwner(_msgSender(), tokenId),
902             "ERC721: transfer caller is not owner nor approved"
903         );
904 
905         _transfer(from, to, tokenId);
906     }
907 
908     /**
909      * @dev See {IERC721-safeTransferFrom}.
910      */
911     function safeTransferFrom(
912         address from,
913         address to,
914         uint256 tokenId
915     ) public virtual override {
916         safeTransferFrom(from, to, tokenId, "");
917     }
918 
919     /**
920      * @dev See {IERC721-safeTransferFrom}.
921      */
922     function safeTransferFrom(
923         address from,
924         address to,
925         uint256 tokenId,
926         bytes memory _data
927     ) public virtual override {
928         require(
929             _isApprovedOrOwner(_msgSender(), tokenId),
930             "ERC721: transfer caller is not owner nor approved"
931         );
932         _safeTransfer(from, to, tokenId, _data);
933     }
934 
935     /**
936      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
937      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
938      *
939      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
940      *
941      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
942      * implement alternative mechanisms to perform token transfer, such as signature-based.
943      *
944      * Requirements:
945      *
946      * - `from` cannot be the zero address.
947      * - `to` cannot be the zero address.
948      * - `tokenId` token must exist and be owned by `from`.
949      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
950      *
951      * Emits a {Transfer} event.
952      */
953     function _safeTransfer(
954         address from,
955         address to,
956         uint256 tokenId,
957         bytes memory _data
958     ) internal virtual {
959         _transfer(from, to, tokenId);
960         require(
961             _checkOnERC721Received(from, to, tokenId, _data),
962             "ERC721: transfer to non ERC721Receiver implementer"
963         );
964     }
965 
966     /**
967      * @dev Returns whether `tokenId` exists.
968      *
969      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
970      *
971      * Tokens start existing when they are minted (`_mint`),
972      * and stop existing when they are burned (`_burn`).
973      */
974     function _exists(uint256 tokenId) internal view virtual returns (bool) {
975         return _owners[tokenId] != address(0);
976     }
977 
978     /**
979      * @dev Returns whether `spender` is allowed to manage `tokenId`.
980      *
981      * Requirements:
982      *
983      * - `tokenId` must exist.
984      */
985     function _isApprovedOrOwner(address spender, uint256 tokenId)
986         internal
987         view
988         virtual
989         returns (bool)
990     {
991         require(
992             _exists(tokenId),
993             "ERC721: operator query for nonexistent token"
994         );
995         address owner = ERC721.ownerOf(tokenId);
996         return (spender == owner ||
997             getApproved(tokenId) == spender ||
998             isApprovedForAll(owner, spender));
999     }
1000 
1001     /**
1002      * @dev Safely mints `tokenId` and transfers it to `to`.
1003      *
1004      * Requirements:
1005      *
1006      * - `tokenId` must not exist.
1007      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _safeMint(address to, uint256 tokenId) internal virtual {
1012         _safeMint(to, tokenId, "");
1013     }
1014 
1015     /**
1016      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1017      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1018      */
1019     function _safeMint(
1020         address to,
1021         uint256 tokenId,
1022         bytes memory _data
1023     ) internal virtual {
1024         _mint(to, tokenId);
1025         require(
1026             _checkOnERC721Received(address(0), to, tokenId, _data),
1027             "ERC721: transfer to non ERC721Receiver implementer"
1028         );
1029     }
1030 
1031     /**
1032      * @dev Mints `tokenId` and transfers it to `to`.
1033      *
1034      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1035      *
1036      * Requirements:
1037      *
1038      * - `tokenId` must not exist.
1039      * - `to` cannot be the zero address.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function _mint(address to, uint256 tokenId) internal virtual {
1044         require(to != address(0), "ERC721: mint to the zero address");
1045         require(!_exists(tokenId), "ERC721: token already minted");
1046 
1047         _beforeTokenTransfer(address(0), to, tokenId);
1048 
1049         _balances[to] += 1;
1050         _owners[tokenId] = to;
1051 
1052         emit Transfer(address(0), to, tokenId);
1053     }
1054 
1055     /**
1056      * @dev Destroys `tokenId`.
1057      * The approval is cleared when the token is burned.
1058      *
1059      * Requirements:
1060      *
1061      * - `tokenId` must exist.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function _burn(uint256 tokenId) internal virtual {
1066         address owner = ERC721.ownerOf(tokenId);
1067 
1068         _beforeTokenTransfer(owner, address(0), tokenId);
1069 
1070         // Clear approvals
1071         _approve(address(0), tokenId);
1072 
1073         _balances[owner] -= 1;
1074         delete _owners[tokenId];
1075 
1076         emit Transfer(owner, address(0), tokenId);
1077     }
1078 
1079     /**
1080      * @dev Transfers `tokenId` from `from` to `to`.
1081      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1082      *
1083      * Requirements:
1084      *
1085      * - `to` cannot be the zero address.
1086      * - `tokenId` token must be owned by `from`.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function _transfer(
1091         address from,
1092         address to,
1093         uint256 tokenId
1094     ) internal virtual {
1095         require(
1096             ERC721.ownerOf(tokenId) == from,
1097             "ERC721: transfer of token that is not own"
1098         );
1099         require(to != address(0), "ERC721: transfer to the zero address");
1100 
1101         _beforeTokenTransfer(from, to, tokenId);
1102 
1103         // Clear approvals from the previous owner
1104         _approve(address(0), tokenId);
1105 
1106         _balances[from] -= 1;
1107         _balances[to] += 1;
1108         _owners[tokenId] = to;
1109 
1110         emit Transfer(from, to, tokenId);
1111     }
1112 
1113     /**
1114      * @dev Approve `to` to operate on `tokenId`
1115      *
1116      * Emits a {Approval} event.
1117      */
1118     function _approve(address to, uint256 tokenId) internal virtual {
1119         _tokenApprovals[tokenId] = to;
1120         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1121     }
1122 
1123     /**
1124      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1125      * The call is not executed if the target address is not a contract.
1126      *
1127      * @param from address representing the previous owner of the given token ID
1128      * @param to target address that will receive the tokens
1129      * @param tokenId uint256 ID of the token to be transferred
1130      * @param _data bytes optional data to send along with the call
1131      * @return bool whether the call correctly returned the expected magic value
1132      */
1133     function _checkOnERC721Received(
1134         address from,
1135         address to,
1136         uint256 tokenId,
1137         bytes memory _data
1138     ) private returns (bool) {
1139         if (to.isContract()) {
1140             try
1141                 IERC721Receiver(to).onERC721Received(
1142                     _msgSender(),
1143                     from,
1144                     tokenId,
1145                     _data
1146                 )
1147             returns (bytes4 retval) {
1148                 return retval == IERC721Receiver.onERC721Received.selector;
1149             } catch (bytes memory reason) {
1150                 if (reason.length == 0) {
1151                     revert(
1152                         "ERC721: transfer to non ERC721Receiver implementer"
1153                     );
1154                 } else {
1155                     assembly {
1156                         revert(add(32, reason), mload(reason))
1157                     }
1158                 }
1159             }
1160         } else {
1161             return true;
1162         }
1163     }
1164 
1165     /**
1166      * @dev Hook that is called before any token transfer. This includes minting
1167      * and burning.
1168      *
1169      * Calling conditions:
1170      *
1171      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1172      * transferred to `to`.
1173      * - When `from` is zero, `tokenId` will be minted for `to`.
1174      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1175      * - `from` and `to` are never both zero.
1176      *
1177      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1178      */
1179     function _beforeTokenTransfer(
1180         address from,
1181         address to,
1182         uint256 tokenId
1183     ) internal virtual {}
1184 }
1185 
1186 pragma solidity ^0.8.5;
1187 
1188 contract Badaliensocialclub is ERC721, Ownable {
1189     using Strings for uint256;
1190     uint256 public cost = 0.09 ether;
1191     uint256 public maxSupply = 3333;
1192     uint256 public maxMintAmount = 100;
1193     uint256 public tokenCount = 0;
1194     bool public paused = false;
1195     string public baseURI;
1196 
1197     mapping(address => uint256) public addressMintedBalance;
1198 
1199     constructor(string memory _initBaseURI)
1200         ERC721("Badaliensocialclub", "BASC")
1201     {
1202         baseURI = _initBaseURI;
1203     }
1204 
1205     function tokenURI(uint256 tokenId)
1206         public
1207         view
1208         override
1209         returns (string memory)
1210     {
1211         require(_exists(tokenId), "ERC721Metadata: Token ID does not exist");
1212         return
1213             bytes(baseURI).length > 0
1214                 ? string(
1215                     abi.encodePacked(baseURI, "/", tokenId.toString(), ".json")
1216                 )
1217                 : "";
1218     }
1219 
1220     function mint(uint256 _amount) external payable {
1221         require(!paused, "badaliensocialclub - The Contract is Paused");
1222         require(
1223             tokenCount + _amount <= maxSupply,
1224             "badaliensocialclub - max NFT limit exceeded"
1225         );
1226         if (msg.sender != owner()) {
1227             require(
1228                 _amount <= maxMintAmount,
1229                 "badaliensocialclub - max mint amount limit exceeded"
1230             );
1231             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1232             require(
1233                 ownerMintedCount + _amount <= maxMintAmount,
1234                 "badaliensocialclub - max NFT per address exceeded"
1235             );
1236             require(
1237                 msg.value >= cost * _amount,
1238                 "badaliensocialclub - insufficient ethers"
1239             );
1240         }
1241         for (uint256 i = 1; i <= _amount; i++) {
1242             addressMintedBalance[msg.sender]++;
1243             _safeMint(msg.sender, ++tokenCount);
1244         }
1245     }
1246 
1247     //only owner
1248     function setCost(uint256 _newCost) public onlyOwner {
1249         cost = _newCost;
1250     }
1251 
1252     function setMaxMintAmount(uint256 _maxMintAmount) public onlyOwner {
1253         maxMintAmount = _maxMintAmount;
1254     }
1255 
1256     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1257         maxSupply = _maxSupply;
1258     }
1259 
1260     function setBaseURI(string memory _baseURI) public onlyOwner {
1261         baseURI = _baseURI;
1262     }
1263 
1264     function pause() public onlyOwner {
1265         paused = !paused;
1266     }
1267 
1268     function withdraw() public onlyOwner {
1269         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1270         require(os);
1271     }
1272 }