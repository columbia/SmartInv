1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Interface of the ERC165 standard, as defined in the
33  * https://eips.ethereum.org/EIPS/eip-165[EIP].
34  *
35  * Implementers can declare support of contract interfaces, which can then be
36  * queried by others ({ERC165Checker}).
37  *
38  * For an implementation, see {ERC165}.
39  */
40 interface IERC165 {
41     /**
42      * @dev Returns true if this contract implements the interface defined by
43      * `interfaceId`. See the corresponding
44      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
45      * to learn more about how these ids are created.
46      *
47      * This function call must use less than 30 000 gas.
48      */
49     function supportsInterface(bytes4 interfaceId) external view returns (bool);
50 }
51 
52 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
53 
54 pragma solidity ^0.8.0;
55 
56 /**
57  * @dev Required interface of an ERC721 compliant contract.
58  */
59 interface IERC721 is IERC165 {
60     /**
61      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
62      */
63     event Transfer(
64         address indexed from,
65         address indexed to,
66         uint256 indexed tokenId
67     );
68 
69     /**
70      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
71      */
72     event Approval(
73         address indexed owner,
74         address indexed approved,
75         uint256 indexed tokenId
76     );
77 
78     /**
79      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
80      */
81     event ApprovalForAll(
82         address indexed owner,
83         address indexed operator,
84         bool approved
85     );
86 
87     /**
88      * @dev Returns the number of tokens in ``owner``'s account.
89      */
90     function balanceOf(address owner) external view returns (uint256 balance);
91 
92     /**
93      * @dev Returns the owner of the `tokenId` token.
94      *
95      * Requirements:
96      *
97      * - `tokenId` must exist.
98      */
99     function ownerOf(uint256 tokenId) external view returns (address owner);
100 
101     /**
102      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
103      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
104      *
105      * Requirements:
106      *
107      * - `from` cannot be the zero address.
108      * - `to` cannot be the zero address.
109      * - `tokenId` token must exist and be owned by `from`.
110      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
111      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
112      *
113      * Emits a {Transfer} event.
114      */
115     function safeTransferFrom(
116         address from,
117         address to,
118         uint256 tokenId
119     ) external;
120 
121     /**
122      * @dev Transfers `tokenId` token from `from` to `to`.
123      *
124      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
125      *
126      * Requirements:
127      *
128      * - `from` cannot be the zero address.
129      * - `to` cannot be the zero address.
130      * - `tokenId` token must be owned by `from`.
131      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
132      *
133      * Emits a {Transfer} event.
134      */
135     function transferFrom(
136         address from,
137         address to,
138         uint256 tokenId
139     ) external;
140 
141     /**
142      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
143      * The approval is cleared when the token is transferred.
144      *
145      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
146      *
147      * Requirements:
148      *
149      * - The caller must own the token or be an approved operator.
150      * - `tokenId` must exist.
151      *
152      * Emits an {Approval} event.
153      */
154     function approve(address to, uint256 tokenId) external;
155 
156     /**
157      * @dev Returns the account approved for `tokenId` token.
158      *
159      * Requirements:
160      *
161      * - `tokenId` must exist.
162      */
163     function getApproved(uint256 tokenId)
164         external
165         view
166         returns (address operator);
167 
168     /**
169      * @dev Approve or remove `operator` as an operator for the caller.
170      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
171      *
172      * Requirements:
173      *
174      * - The `operator` cannot be the caller.
175      *
176      * Emits an {ApprovalForAll} event.
177      */
178     function setApprovalForAll(address operator, bool _approved) external;
179 
180     /**
181      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
182      *
183      * See {setApprovalForAll}
184      */
185     function isApprovedForAll(address owner, address operator)
186         external
187         view
188         returns (bool);
189 
190     /**
191      * @dev Safely transfers `tokenId` token from `from` to `to`.
192      *
193      * Requirements:
194      *
195      * - `from` cannot be the zero address.
196      * - `to` cannot be the zero address.
197      * - `tokenId` token must exist and be owned by `from`.
198      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
199      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
200      *
201      * Emits a {Transfer} event.
202      */
203     function safeTransferFrom(
204         address from,
205         address to,
206         uint256 tokenId,
207         bytes calldata data
208     ) external;
209 }
210 
211 // File: @openzeppelin/contracts/access/Ownable.sol
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @dev Contract module which provides a basic access control mechanism, where
217  * there is an account (an owner) that can be granted exclusive access to
218  * specific functions.
219  *
220  * By default, the owner account will be the one that deploys the contract. This
221  * can later be changed with {transferOwnership}.
222  *
223  * This module is used through inheritance. It will make available the modifier
224  * `onlyOwner`, which can be applied to your functions to restrict their use to
225  * the owner.
226  */
227 abstract contract Ownable is Context {
228     address private _owner;
229 
230     event OwnershipTransferred(
231         address indexed previousOwner,
232         address indexed newOwner
233     );
234 
235     /**
236      * @dev Initializes the contract setting the deployer as the initial owner.
237      */
238     constructor() {
239         _setOwner(_msgSender());
240     }
241 
242     /**
243      * @dev Returns the address of the current owner.
244      */
245     function owner() public view virtual returns (address) {
246         return _owner;
247     }
248 
249     /**
250      * @dev Throws if called by any account other than the owner.
251      */
252     modifier onlyOwner() {
253         require(owner() == _msgSender(), "Ownable: caller is not the owner");
254         _;
255     }
256 
257     /**
258      * @dev Leaves the contract without owner. It will not be possible to call
259      * `onlyOwner` functions anymore. Can only be called by the current owner.
260      *
261      * NOTE: Renouncing ownership will leave the contract without an owner,
262      * thereby removing any functionality that is only available to the owner.
263      */
264     function renounceOwnership() public virtual onlyOwner {
265         _setOwner(address(0));
266     }
267 
268     /**
269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
270      * Can only be called by the current owner.
271      */
272     function transferOwnership(address newOwner) public virtual onlyOwner {
273         require(
274             newOwner != address(0),
275             "Ownable: new owner is the zero address"
276         );
277         _setOwner(newOwner);
278     }
279 
280     function _setOwner(address newOwner) private {
281         address oldOwner = _owner;
282         _owner = newOwner;
283         emit OwnershipTransferred(oldOwner, newOwner);
284     }
285 }
286 
287 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
288 
289 pragma solidity ^0.8.0;
290 
291 /**
292  * @dev Implementation of the {IERC165} interface.
293  *
294  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
295  * for the additional interface id that will be supported. For example:
296  *
297  * ```solidity
298  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
299  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
300  * }
301  * ```
302  *
303  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
304  */
305 abstract contract ERC165 is IERC165 {
306     /**
307      * @dev See {IERC165-supportsInterface}.
308      */
309     function supportsInterface(bytes4 interfaceId)
310         public
311         view
312         virtual
313         override
314         returns (bool)
315     {
316         return interfaceId == type(IERC165).interfaceId;
317     }
318 }
319 
320 // File: @openzeppelin/contracts/utils/Strings.sol
321 
322 pragma solidity ^0.8.0;
323 
324 /**
325  * @dev String operations.
326  */
327 library Strings {
328     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
329 
330     /**
331      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
332      */
333     function toString(uint256 value) internal pure returns (string memory) {
334         // Inspired by OraclizeAPI's implementation - MIT licence
335         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
336 
337         if (value == 0) {
338             return "0";
339         }
340         uint256 temp = value;
341         uint256 digits;
342         while (temp != 0) {
343             digits++;
344             temp /= 10;
345         }
346         bytes memory buffer = new bytes(digits);
347         while (value != 0) {
348             digits -= 1;
349             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
350             value /= 10;
351         }
352         return string(buffer);
353     }
354 
355     /**
356      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
357      */
358     function toHexString(uint256 value) internal pure returns (string memory) {
359         if (value == 0) {
360             return "0x00";
361         }
362         uint256 temp = value;
363         uint256 length = 0;
364         while (temp != 0) {
365             length++;
366             temp >>= 8;
367         }
368         return toHexString(value, length);
369     }
370 
371     /**
372      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
373      */
374     function toHexString(uint256 value, uint256 length)
375         internal
376         pure
377         returns (string memory)
378     {
379         bytes memory buffer = new bytes(2 * length + 2);
380         buffer[0] = "0";
381         buffer[1] = "x";
382         for (uint256 i = 2 * length + 1; i > 1; --i) {
383             buffer[i] = _HEX_SYMBOLS[value & 0xf];
384             value >>= 4;
385         }
386         require(value == 0, "Strings: hex length insufficient");
387         return string(buffer);
388     }
389 }
390 
391 // File: @openzeppelin/contracts/utils/Address.sol
392 
393 pragma solidity ^0.8.0;
394 
395 /**
396  * @dev Collection of functions related to the address type
397  */
398 library Address {
399     /**
400      * @dev Returns true if `account` is a contract.
401      *
402      * [IMPORTANT]
403      * ====
404      * It is unsafe to assume that an address for which this function returns
405      * false is an externally-owned account (EOA) and not a contract.
406      *
407      * Among others, `isContract` will return false for the following
408      * types of addresses:
409      *
410      *  - an externally-owned account
411      *  - a contract in construction
412      *  - an address where a contract will be created
413      *  - an address where a contract lived, but was destroyed
414      * ====
415      */
416     function isContract(address account) internal view returns (bool) {
417         // This method relies on extcodesize, which returns 0 for contracts in
418         // construction, since the code is only stored at the end of the
419         // constructor execution.
420 
421         uint256 size;
422         assembly {
423             size := extcodesize(account)
424         }
425         return size > 0;
426     }
427 
428     /**
429      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
430      * `recipient`, forwarding all available gas and reverting on errors.
431      *
432      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
433      * of certain opcodes, possibly making contracts go over the 2300 gas limit
434      * imposed by `transfer`, making them unable to receive funds via
435      * `transfer`. {sendValue} removes this limitation.
436      *
437      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
438      *
439      * IMPORTANT: because control is transferred to `recipient`, care must be
440      * taken to not create reentrancy vulnerabilities. Consider using
441      * {ReentrancyGuard} or the
442      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
443      */
444     function sendValue(address payable recipient, uint256 amount) internal {
445         require(
446             address(this).balance >= amount,
447             "Address: insufficient balance"
448         );
449 
450         (bool success, ) = recipient.call{value: amount}("");
451         require(
452             success,
453             "Address: unable to send value, recipient may have reverted"
454         );
455     }
456 
457     /**
458      * @dev Performs a Solidity function call using a low level `call`. A
459      * plain `call` is an unsafe replacement for a function call: use this
460      * function instead.
461      *
462      * If `target` reverts with a revert reason, it is bubbled up by this
463      * function (like regular Solidity function calls).
464      *
465      * Returns the raw returned data. To convert to the expected return value,
466      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
467      *
468      * Requirements:
469      *
470      * - `target` must be a contract.
471      * - calling `target` with `data` must not revert.
472      *
473      * _Available since v3.1._
474      */
475     function functionCall(address target, bytes memory data)
476         internal
477         returns (bytes memory)
478     {
479         return functionCall(target, data, "Address: low-level call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
484      * `errorMessage` as a fallback revert reason when `target` reverts.
485      *
486      * _Available since v3.1._
487      */
488     function functionCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         return functionCallWithValue(target, data, 0, errorMessage);
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
498      * but also transferring `value` wei to `target`.
499      *
500      * Requirements:
501      *
502      * - the calling contract must have an ETH balance of at least `value`.
503      * - the called Solidity function must be `payable`.
504      *
505      * _Available since v3.1._
506      */
507     function functionCallWithValue(
508         address target,
509         bytes memory data,
510         uint256 value
511     ) internal returns (bytes memory) {
512         return
513             functionCallWithValue(
514                 target,
515                 data,
516                 value,
517                 "Address: low-level call with value failed"
518             );
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
523      * with `errorMessage` as a fallback revert reason when `target` reverts.
524      *
525      * _Available since v3.1._
526      */
527     function functionCallWithValue(
528         address target,
529         bytes memory data,
530         uint256 value,
531         string memory errorMessage
532     ) internal returns (bytes memory) {
533         require(
534             address(this).balance >= value,
535             "Address: insufficient balance for call"
536         );
537         require(isContract(target), "Address: call to non-contract");
538 
539         (bool success, bytes memory returndata) = target.call{value: value}(
540             data
541         );
542         return _verifyCallResult(success, returndata, errorMessage);
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
547      * but performing a static call.
548      *
549      * _Available since v3.3._
550      */
551     function functionStaticCall(address target, bytes memory data)
552         internal
553         view
554         returns (bytes memory)
555     {
556         return
557             functionStaticCall(
558                 target,
559                 data,
560                 "Address: low-level static call failed"
561             );
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
566      * but performing a static call.
567      *
568      * _Available since v3.3._
569      */
570     function functionStaticCall(
571         address target,
572         bytes memory data,
573         string memory errorMessage
574     ) internal view returns (bytes memory) {
575         require(isContract(target), "Address: static call to non-contract");
576 
577         (bool success, bytes memory returndata) = target.staticcall(data);
578         return _verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but performing a delegate call.
584      *
585      * _Available since v3.4._
586      */
587     function functionDelegateCall(address target, bytes memory data)
588         internal
589         returns (bytes memory)
590     {
591         return
592             functionDelegateCall(
593                 target,
594                 data,
595                 "Address: low-level delegate call failed"
596             );
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
601      * but performing a delegate call.
602      *
603      * _Available since v3.4._
604      */
605     function functionDelegateCall(
606         address target,
607         bytes memory data,
608         string memory errorMessage
609     ) internal returns (bytes memory) {
610         require(isContract(target), "Address: delegate call to non-contract");
611 
612         (bool success, bytes memory returndata) = target.delegatecall(data);
613         return _verifyCallResult(success, returndata, errorMessage);
614     }
615 
616     function _verifyCallResult(
617         bool success,
618         bytes memory returndata,
619         string memory errorMessage
620     ) private pure returns (bytes memory) {
621         if (success) {
622             return returndata;
623         } else {
624             // Look for revert reason and bubble it up if present
625             if (returndata.length > 0) {
626                 // The easiest way to bubble the revert reason is using memory via assembly
627 
628                 assembly {
629                     let returndata_size := mload(returndata)
630                     revert(add(32, returndata), returndata_size)
631                 }
632             } else {
633                 revert(errorMessage);
634             }
635         }
636     }
637 }
638 
639 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
640 
641 pragma solidity ^0.8.0;
642 
643 /**
644  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
645  * @dev See https://eips.ethereum.org/EIPS/eip-721
646  */
647 interface IERC721Metadata is IERC721 {
648     /**
649      * @dev Returns the token collection name.
650      */
651     function name() external view returns (string memory);
652 
653     /**
654      * @dev Returns the token collection symbol.
655      */
656     function symbol() external view returns (string memory);
657 
658     /**
659      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
660      */
661     function tokenURI(uint256 tokenId) external view returns (string memory);
662 }
663 
664 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
665 
666 pragma solidity ^0.8.0;
667 
668 /**
669  * @title ERC721 token receiver interface
670  * @dev Interface for any contract that wants to support safeTransfers
671  * from ERC721 asset contracts.
672  */
673 interface IERC721Receiver {
674     /**
675      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
676      * by `operator` from `from`, this function is called.
677      *
678      * It must return its Solidity selector to confirm the token transfer.
679      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
680      *
681      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
682      */
683     function onERC721Received(
684         address operator,
685         address from,
686         uint256 tokenId,
687         bytes calldata data
688     ) external returns (bytes4);
689 }
690 
691 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
692 
693 pragma solidity ^0.8.0;
694 
695 /**
696  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
697  * the Metadata extension, but not including the Enumerable extension, which is available separately as
698  * {ERC721Enumerable}.
699  */
700 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
701     using Address for address;
702     using Strings for uint256;
703 
704     // Token name
705     string private _name;
706 
707     // Token symbol
708     string private _symbol;
709 
710     // Mapping from token ID to owner address
711     mapping(uint256 => address) private _owners;
712 
713     // Mapping owner address to token count
714     mapping(address => uint256) private _balances;
715 
716     // Mapping from token ID to approved address
717     mapping(uint256 => address) private _tokenApprovals;
718 
719     // Mapping from owner to operator approvals
720     mapping(address => mapping(address => bool)) private _operatorApprovals;
721 
722     /**
723      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
724      */
725     constructor(string memory name_, string memory symbol_) {
726         _name = name_;
727         _symbol = symbol_;
728     }
729 
730     /**
731      * @dev See {IERC165-supportsInterface}.
732      */
733     function supportsInterface(bytes4 interfaceId)
734         public
735         view
736         virtual
737         override(ERC165, IERC165)
738         returns (bool)
739     {
740         return
741             interfaceId == type(IERC721).interfaceId ||
742             interfaceId == type(IERC721Metadata).interfaceId ||
743             super.supportsInterface(interfaceId);
744     }
745 
746     /**
747      * @dev See {IERC721-balanceOf}.
748      */
749     function balanceOf(address owner)
750         public
751         view
752         virtual
753         override
754         returns (uint256)
755     {
756         require(
757             owner != address(0),
758             "ERC721: balance query for the zero address"
759         );
760         return _balances[owner];
761     }
762 
763     /**
764      * @dev See {IERC721-ownerOf}.
765      */
766     function ownerOf(uint256 tokenId)
767         public
768         view
769         virtual
770         override
771         returns (address)
772     {
773         address owner = _owners[tokenId];
774         require(
775             owner != address(0),
776             "ERC721: owner query for nonexistent token"
777         );
778         return owner;
779     }
780 
781     /**
782      * @dev See {IERC721Metadata-name}.
783      */
784     function name() public view virtual override returns (string memory) {
785         return _name;
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-symbol}.
790      */
791     function symbol() public view virtual override returns (string memory) {
792         return _symbol;
793     }
794 
795     /**
796      * @dev See {IERC721Metadata-tokenURI}.
797      */
798     function tokenURI(uint256 tokenId)
799         public
800         view
801         virtual
802         override
803         returns (string memory)
804     {
805         require(
806             _exists(tokenId),
807             "ERC721Metadata: URI query for nonexistent token"
808         );
809 
810         string memory baseURI = _baseURI();
811         return
812             bytes(baseURI).length > 0
813                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
814                 : "";
815     }
816 
817     /**
818      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
819      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
820      * by default, can be overriden in child contracts.
821      */
822     function _baseURI() internal view virtual returns (string memory) {
823         return "";
824     }
825 
826     /**
827      * @dev See {IERC721-approve}.
828      */
829     function approve(address to, uint256 tokenId) public virtual override {
830         address owner = ERC721.ownerOf(tokenId);
831         require(to != owner, "ERC721: approval to current owner");
832 
833         require(
834             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
835             "ERC721: approve caller is not owner nor approved for all"
836         );
837 
838         _approve(to, tokenId);
839     }
840 
841     /**
842      * @dev See {IERC721-getApproved}.
843      */
844     function getApproved(uint256 tokenId)
845         public
846         view
847         virtual
848         override
849         returns (address)
850     {
851         require(
852             _exists(tokenId),
853             "ERC721: approved query for nonexistent token"
854         );
855 
856         return _tokenApprovals[tokenId];
857     }
858 
859     /**
860      * @dev See {IERC721-setApprovalForAll}.
861      */
862     function setApprovalForAll(address operator, bool approved)
863         public
864         virtual
865         override
866     {
867         require(operator != _msgSender(), "ERC721: approve to caller");
868 
869         _operatorApprovals[_msgSender()][operator] = approved;
870         emit ApprovalForAll(_msgSender(), operator, approved);
871     }
872 
873     /**
874      * @dev See {IERC721-isApprovedForAll}.
875      */
876     function isApprovedForAll(address owner, address operator)
877         public
878         view
879         virtual
880         override
881         returns (bool)
882     {
883         return _operatorApprovals[owner][operator];
884     }
885 
886     /**
887      * @dev See {IERC721-transferFrom}.
888      */
889     function transferFrom(
890         address from,
891         address to,
892         uint256 tokenId
893     ) public virtual override {
894         //solhint-disable-next-line max-line-length
895         require(
896             _isApprovedOrOwner(_msgSender(), tokenId),
897             "ERC721: transfer caller is not owner nor approved"
898         );
899 
900         _transfer(from, to, tokenId);
901     }
902 
903     /**
904      * @dev See {IERC721-safeTransferFrom}.
905      */
906     function safeTransferFrom(
907         address from,
908         address to,
909         uint256 tokenId
910     ) public virtual override {
911         safeTransferFrom(from, to, tokenId, "");
912     }
913 
914     /**
915      * @dev See {IERC721-safeTransferFrom}.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes memory _data
922     ) public virtual override {
923         require(
924             _isApprovedOrOwner(_msgSender(), tokenId),
925             "ERC721: transfer caller is not owner nor approved"
926         );
927         _safeTransfer(from, to, tokenId, _data);
928     }
929 
930     /**
931      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
932      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
933      *
934      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
935      *
936      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
937      * implement alternative mechanisms to perform token transfer, such as signature-based.
938      *
939      * Requirements:
940      *
941      * - `from` cannot be the zero address.
942      * - `to` cannot be the zero address.
943      * - `tokenId` token must exist and be owned by `from`.
944      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _safeTransfer(
949         address from,
950         address to,
951         uint256 tokenId,
952         bytes memory _data
953     ) internal virtual {
954         _transfer(from, to, tokenId);
955         require(
956             _checkOnERC721Received(from, to, tokenId, _data),
957             "ERC721: transfer to non ERC721Receiver implementer"
958         );
959     }
960 
961     /**
962      * @dev Returns whether `tokenId` exists.
963      *
964      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
965      *
966      * Tokens start existing when they are minted (`_mint`),
967      * and stop existing when they are burned (`_burn`).
968      */
969     function _exists(uint256 tokenId) internal view virtual returns (bool) {
970         return _owners[tokenId] != address(0);
971     }
972 
973     /**
974      * @dev Returns whether `spender` is allowed to manage `tokenId`.
975      *
976      * Requirements:
977      *
978      * - `tokenId` must exist.
979      */
980     function _isApprovedOrOwner(address spender, uint256 tokenId)
981         internal
982         view
983         virtual
984         returns (bool)
985     {
986         require(
987             _exists(tokenId),
988             "ERC721: operator query for nonexistent token"
989         );
990         address owner = ERC721.ownerOf(tokenId);
991         return (spender == owner ||
992             getApproved(tokenId) == spender ||
993             isApprovedForAll(owner, spender));
994     }
995 
996     /**
997      * @dev Safely mints `tokenId` and transfers it to `to`.
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must not exist.
1002      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _safeMint(address to, uint256 tokenId) internal virtual {
1007         _safeMint(to, tokenId, "");
1008     }
1009 
1010     /**
1011      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1012      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1013      */
1014     function _safeMint(
1015         address to,
1016         uint256 tokenId,
1017         bytes memory _data
1018     ) internal virtual {
1019         _mint(to, tokenId);
1020         require(
1021             _checkOnERC721Received(address(0), to, tokenId, _data),
1022             "ERC721: transfer to non ERC721Receiver implementer"
1023         );
1024     }
1025 
1026     /**
1027      * @dev Mints `tokenId` and transfers it to `to`.
1028      *
1029      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1030      *
1031      * Requirements:
1032      *
1033      * - `tokenId` must not exist.
1034      * - `to` cannot be the zero address.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _mint(address to, uint256 tokenId) internal virtual {
1039         require(to != address(0), "ERC721: mint to the zero address");
1040         require(!_exists(tokenId), "ERC721: token already minted");
1041 
1042         _beforeTokenTransfer(address(0), to, tokenId);
1043 
1044         _balances[to] += 1;
1045         _owners[tokenId] = to;
1046 
1047         emit Transfer(address(0), to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev Destroys `tokenId`.
1052      * The approval is cleared when the token is burned.
1053      *
1054      * Requirements:
1055      *
1056      * - `tokenId` must exist.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function _burn(uint256 tokenId) internal virtual {
1061         address owner = ERC721.ownerOf(tokenId);
1062 
1063         _beforeTokenTransfer(owner, address(0), tokenId);
1064 
1065         // Clear approvals
1066         _approve(address(0), tokenId);
1067 
1068         _balances[owner] -= 1;
1069         delete _owners[tokenId];
1070 
1071         emit Transfer(owner, address(0), tokenId);
1072     }
1073 
1074     /**
1075      * @dev Transfers `tokenId` from `from` to `to`.
1076      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1077      *
1078      * Requirements:
1079      *
1080      * - `to` cannot be the zero address.
1081      * - `tokenId` token must be owned by `from`.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _transfer(
1086         address from,
1087         address to,
1088         uint256 tokenId
1089     ) internal virtual {
1090         require(
1091             ERC721.ownerOf(tokenId) == from,
1092             "ERC721: transfer of token that is not own"
1093         );
1094         require(to != address(0), "ERC721: transfer to the zero address");
1095 
1096         _beforeTokenTransfer(from, to, tokenId);
1097 
1098         // Clear approvals from the previous owner
1099         _approve(address(0), tokenId);
1100 
1101         _balances[from] -= 1;
1102         _balances[to] += 1;
1103         _owners[tokenId] = to;
1104 
1105         emit Transfer(from, to, tokenId);
1106     }
1107 
1108     /**
1109      * @dev Approve `to` to operate on `tokenId`
1110      *
1111      * Emits a {Approval} event.
1112      */
1113     function _approve(address to, uint256 tokenId) internal virtual {
1114         _tokenApprovals[tokenId] = to;
1115         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1116     }
1117 
1118     /**
1119      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1120      * The call is not executed if the target address is not a contract.
1121      *
1122      * @param from address representing the previous owner of the given token ID
1123      * @param to target address that will receive the tokens
1124      * @param tokenId uint256 ID of the token to be transferred
1125      * @param _data bytes optional data to send along with the call
1126      * @return bool whether the call correctly returned the expected magic value
1127      */
1128     function _checkOnERC721Received(
1129         address from,
1130         address to,
1131         uint256 tokenId,
1132         bytes memory _data
1133     ) private returns (bool) {
1134         if (to.isContract()) {
1135             try
1136                 IERC721Receiver(to).onERC721Received(
1137                     _msgSender(),
1138                     from,
1139                     tokenId,
1140                     _data
1141                 )
1142             returns (bytes4 retval) {
1143                 return retval == IERC721Receiver(to).onERC721Received.selector;
1144             } catch (bytes memory reason) {
1145                 if (reason.length == 0) {
1146                     revert(
1147                         "ERC721: transfer to non ERC721Receiver implementer"
1148                     );
1149                 } else {
1150                     assembly {
1151                         revert(add(32, reason), mload(reason))
1152                     }
1153                 }
1154             }
1155         } else {
1156             return true;
1157         }
1158     }
1159 
1160     /**
1161      * @dev Hook that is called before any token transfer. This includes minting
1162      * and burning.
1163      *
1164      * Calling conditions:
1165      *
1166      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1167      * transferred to `to`.
1168      * - When `from` is zero, `tokenId` will be minted for `to`.
1169      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1170      * - `from` and `to` are never both zero.
1171      *
1172      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1173      */
1174     function _beforeTokenTransfer(
1175         address from,
1176         address to,
1177         uint256 tokenId
1178     ) internal virtual {}
1179 }
1180 
1181 pragma solidity ^0.8.0;
1182 
1183 contract SocialCoolCats is ERC721, Ownable {
1184     uint256 public constant MAX_SUPPLY = 876;
1185     uint16 private mintCount = 0;
1186 
1187     uint256 public price = 87600000000000000;
1188     string baseTokenURI;
1189     bool public saleOpen = false;
1190 
1191     event Minted(uint256 totalMinted);
1192 
1193     constructor(string memory baseURI) ERC721("Social Cool Cats", "SCA") {
1194         setBaseURI(baseURI);
1195     }
1196 
1197     function totalSupply() public view returns (uint16) {
1198         return mintCount;
1199     }
1200 
1201     function setBaseURI(string memory baseURI) public onlyOwner {
1202         baseTokenURI = baseURI;
1203     }
1204 
1205     function changePrice(uint256 _newPrice) external onlyOwner {
1206         price = _newPrice;
1207     }
1208 
1209     function toggleSale() external onlyOwner {
1210         saleOpen = !saleOpen;
1211     }
1212 
1213     function withdraw() external onlyOwner {
1214         (bool success, ) = payable(msg.sender).call{
1215             value: address(this).balance
1216         }("");
1217         require(success, "Transfer failed.");
1218     }
1219 
1220     function mint(address _to,uint16 _count) external payable {
1221         uint16 supply = totalSupply();
1222 
1223         require(supply + _count <= MAX_SUPPLY, "Exceeds maximum supply");
1224         require(_count > 0, "Minimum 1 NFT has to be minted per transaction");
1225 
1226         if (msg.sender != owner()) {
1227             require(saleOpen, "Sale is not open yet");
1228             require(
1229                 _count <= 5,
1230                 "Maximum 5 NFTs can be minted per transaction"
1231             );
1232             require(
1233                 msg.value >= price * _count,
1234                 "Ether sent with this transaction is not correct"
1235             );
1236         }
1237 
1238         mintCount += _count;
1239 
1240         for (uint256 i = 0; i < _count; i++) {
1241             _safeMint(_to, ++supply);
1242             emit Minted(supply);
1243         }
1244     }
1245 
1246     function _baseURI() internal view virtual override returns (string memory) {
1247         return baseTokenURI;
1248     }
1249 }