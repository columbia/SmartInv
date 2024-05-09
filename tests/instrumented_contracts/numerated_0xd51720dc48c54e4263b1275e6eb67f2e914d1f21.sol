1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Context.sol
3 
4 pragma solidity ^0.8.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Interface of the ERC165 standard, as defined in the
32  * https://eips.ethereum.org/EIPS/eip-165[EIP].
33  *
34  * Implementers can declare support of contract interfaces, which can then be
35  * queried by others ({ERC165Checker}).
36  *
37  * For an implementation, see {ERC165}.
38  */
39 interface IERC165 {
40     /**
41      * @dev Returns true if this contract implements the interface defined by
42      * `interfaceId`. See the corresponding
43      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
44      * to learn more about how these ids are created.
45      *
46      * This function call must use less than 30 000 gas.
47      */
48     function supportsInterface(bytes4 interfaceId) external view returns (bool);
49 }
50 
51 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev Required interface of an ERC721 compliant contract.
57  */
58 interface IERC721 is IERC165 {
59     /**
60      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
61      */
62     event Transfer(
63         address indexed from,
64         address indexed to,
65         uint256 indexed tokenId
66     );
67 
68     /**
69      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
70      */
71     event Approval(
72         address indexed owner,
73         address indexed approved,
74         uint256 indexed tokenId
75     );
76 
77     /**
78      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
79      */
80     event ApprovalForAll(
81         address indexed owner,
82         address indexed operator,
83         bool approved
84     );
85 
86     /**
87      * @dev Returns the number of tokens in ``owner``'s account.
88      */
89     function balanceOf(address owner) external view returns (uint256 balance);
90 
91     /**
92      * @dev Returns the owner of the `tokenId` token.
93      *
94      * Requirements:
95      *
96      * - `tokenId` must exist.
97      */
98     function ownerOf(uint256 tokenId) external view returns (address owner);
99 
100     /**
101      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
102      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
103      *
104      * Requirements:
105      *
106      * - `from` cannot be the zero address.
107      * - `to` cannot be the zero address.
108      * - `tokenId` token must exist and be owned by `from`.
109      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
110      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
111      *
112      * Emits a {Transfer} event.
113      */
114     function safeTransferFrom(
115         address from,
116         address to,
117         uint256 tokenId
118     ) external;
119 
120     /**
121      * @dev Transfers `tokenId` token from `from` to `to`.
122      *
123      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
124      *
125      * Requirements:
126      *
127      * - `from` cannot be the zero address.
128      * - `to` cannot be the zero address.
129      * - `tokenId` token must be owned by `from`.
130      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transferFrom(
135         address from,
136         address to,
137         uint256 tokenId
138     ) external;
139 
140     /**
141      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
142      * The approval is cleared when the token is transferred.
143      *
144      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
145      *
146      * Requirements:
147      *
148      * - The caller must own the token or be an approved operator.
149      * - `tokenId` must exist.
150      *
151      * Emits an {Approval} event.
152      */
153     function approve(address to, uint256 tokenId) external;
154 
155     /**
156      * @dev Returns the account approved for `tokenId` token.
157      *
158      * Requirements:
159      *
160      * - `tokenId` must exist.
161      */
162     function getApproved(uint256 tokenId)
163         external
164         view
165         returns (address operator);
166 
167     /**
168      * @dev Approve or remove `operator` as an operator for the caller.
169      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
170      *
171      * Requirements:
172      *
173      * - The `operator` cannot be the caller.
174      *
175      * Emits an {ApprovalForAll} event.
176      */
177     function setApprovalForAll(address operator, bool _approved) external;
178 
179     /**
180      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
181      *
182      * See {setApprovalForAll}
183      */
184     function isApprovedForAll(address owner, address operator)
185         external
186         view
187         returns (bool);
188 
189     /**
190      * @dev Safely transfers `tokenId` token from `from` to `to`.
191      *
192      * Requirements:
193      *
194      * - `from` cannot be the zero address.
195      * - `to` cannot be the zero address.
196      * - `tokenId` token must exist and be owned by `from`.
197      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
198      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
199      *
200      * Emits a {Transfer} event.
201      */
202     function safeTransferFrom(
203         address from,
204         address to,
205         uint256 tokenId,
206         bytes calldata data
207     ) external;
208 }
209 
210 // File: @openzeppelin/contracts/access/Ownable.sol
211 
212 pragma solidity ^0.8.0;
213 
214 /**
215  * @dev Contract module which provides a basic access control mechanism, where
216  * there is an account (an owner) that can be granted exclusive access to
217  * specific functions.
218  *
219  * By default, the owner account will be the one that deploys the contract. This
220  * can later be changed with {transferOwnership}.
221  *
222  * This module is used through inheritance. It will make available the modifier
223  * `onlyOwner`, which can be applied to your functions to restrict their use to
224  * the owner.
225  */
226 abstract contract Ownable is Context {
227     address private _owner;
228 
229     event OwnershipTransferred(
230         address indexed previousOwner,
231         address indexed newOwner
232     );
233 
234     /**
235      * @dev Initializes the contract setting the deployer as the initial owner.
236      */
237     constructor() {
238         _setOwner(_msgSender());
239     }
240 
241     /**
242      * @dev Returns the address of the current owner.
243      */
244     function owner() public view virtual returns (address) {
245         return _owner;
246     }
247 
248     /**
249      * @dev Throws if called by any account other than the owner.
250      */
251     modifier onlyOwner() {
252         require(owner() == _msgSender(), "Ownable: caller is not the owner");
253         _;
254     }
255 
256     /**
257      * @dev Leaves the contract without owner. It will not be possible to call
258      * `onlyOwner` functions anymore. Can only be called by the current owner.
259      *
260      * NOTE: Renouncing ownership will leave the contract without an owner,
261      * thereby removing any functionality that is only available to the owner.
262      */
263     function renounceOwnership() public virtual onlyOwner {
264         _setOwner(address(0));
265     }
266 
267     /**
268      * @dev Transfers ownership of the contract to a new account (`newOwner`).
269      * Can only be called by the current owner.
270      */
271     function transferOwnership(address newOwner) public virtual onlyOwner {
272         require(
273             newOwner != address(0),
274             "Ownable: new owner is the zero address"
275         );
276         _setOwner(newOwner);
277     }
278 
279     function _setOwner(address newOwner) private {
280         address oldOwner = _owner;
281         _owner = newOwner;
282         emit OwnershipTransferred(oldOwner, newOwner);
283     }
284 }
285 
286 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
287 
288 pragma solidity ^0.8.0;
289 
290 /**
291  * @dev Implementation of the {IERC165} interface.
292  *
293  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
294  * for the additional interface id that will be supported. For example:
295  *
296  * ```solidity
297  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
298  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
299  * }
300  * ```
301  *
302  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
303  */
304 abstract contract ERC165 is IERC165 {
305     /**
306      * @dev See {IERC165-supportsInterface}.
307      */
308     function supportsInterface(bytes4 interfaceId)
309         public
310         view
311         virtual
312         override
313         returns (bool)
314     {
315         return interfaceId == type(IERC165).interfaceId;
316     }
317 }
318 
319 // File: @openzeppelin/contracts/utils/Strings.sol
320 
321 pragma solidity ^0.8.0;
322 
323 /**
324  * @dev String operations.
325  */
326 library Strings {
327     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
328 
329     /**
330      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
331      */
332     function toString(uint256 value) internal pure returns (string memory) {
333         // Inspired by OraclizeAPI's implementation - MIT licence
334         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
335 
336         if (value == 0) {
337             return "0";
338         }
339         uint256 temp = value;
340         uint256 digits;
341         while (temp != 0) {
342             digits++;
343             temp /= 10;
344         }
345         bytes memory buffer = new bytes(digits);
346         while (value != 0) {
347             digits -= 1;
348             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
349             value /= 10;
350         }
351         return string(buffer);
352     }
353 
354     /**
355      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
356      */
357     function toHexString(uint256 value) internal pure returns (string memory) {
358         if (value == 0) {
359             return "0x00";
360         }
361         uint256 temp = value;
362         uint256 length = 0;
363         while (temp != 0) {
364             length++;
365             temp >>= 8;
366         }
367         return toHexString(value, length);
368     }
369 
370     /**
371      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
372      */
373     function toHexString(uint256 value, uint256 length)
374         internal
375         pure
376         returns (string memory)
377     {
378         bytes memory buffer = new bytes(2 * length + 2);
379         buffer[0] = "0";
380         buffer[1] = "x";
381         for (uint256 i = 2 * length + 1; i > 1; --i) {
382             buffer[i] = _HEX_SYMBOLS[value & 0xf];
383             value >>= 4;
384         }
385         require(value == 0, "Strings: hex length insufficient");
386         return string(buffer);
387     }
388 }
389 
390 // File: @openzeppelin/contracts/utils/Address.sol
391 
392 pragma solidity ^0.8.0;
393 
394 /**
395  * @dev Collection of functions related to the address type
396  */
397 library Address {
398     /**
399      * @dev Returns true if `account` is a contract.
400      *
401      * [IMPORTANT]
402      * ====
403      * It is unsafe to assume that an address for which this function returns
404      * false is an externally-owned account (EOA) and not a contract.
405      *
406      * Among others, `isContract` will return false for the following
407      * types of addresses:
408      *
409      *  - an externally-owned account
410      *  - a contract in construction
411      *  - an address where a contract will be created
412      *  - an address where a contract lived, but was destroyed
413      * ====
414      */
415     function isContract(address account) internal view returns (bool) {
416         // This method relies on extcodesize, which returns 0 for contracts in
417         // construction, since the code is only stored at the end of the
418         // constructor execution.
419 
420         uint256 size;
421         assembly {
422             size := extcodesize(account)
423         }
424         return size > 0;
425     }
426 
427     /**
428      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
429      * `recipient`, forwarding all available gas and reverting on errors.
430      *
431      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
432      * of certain opcodes, possibly making contracts go over the 2300 gas limit
433      * imposed by `transfer`, making them unable to receive funds via
434      * `transfer`. {sendValue} removes this limitation.
435      *
436      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
437      *
438      * IMPORTANT: because control is transferred to `recipient`, care must be
439      * taken to not create reentrancy vulnerabilities. Consider using
440      * {ReentrancyGuard} or the
441      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
442      */
443     function sendValue(address payable recipient, uint256 amount) internal {
444         require(
445             address(this).balance >= amount,
446             "Address: insufficient balance"
447         );
448 
449         (bool success, ) = recipient.call{value: amount}("");
450         require(
451             success,
452             "Address: unable to send value, recipient may have reverted"
453         );
454     }
455 
456     /**
457      * @dev Performs a Solidity function call using a low level `call`. A
458      * plain `call` is an unsafe replacement for a function call: use this
459      * function instead.
460      *
461      * If `target` reverts with a revert reason, it is bubbled up by this
462      * function (like regular Solidity function calls).
463      *
464      * Returns the raw returned data. To convert to the expected return value,
465      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
466      *
467      * Requirements:
468      *
469      * - `target` must be a contract.
470      * - calling `target` with `data` must not revert.
471      *
472      * _Available since v3.1._
473      */
474     function functionCall(address target, bytes memory data)
475         internal
476         returns (bytes memory)
477     {
478         return functionCall(target, data, "Address: low-level call failed");
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
483      * `errorMessage` as a fallback revert reason when `target` reverts.
484      *
485      * _Available since v3.1._
486      */
487     function functionCall(
488         address target,
489         bytes memory data,
490         string memory errorMessage
491     ) internal returns (bytes memory) {
492         return functionCallWithValue(target, data, 0, errorMessage);
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
497      * but also transferring `value` wei to `target`.
498      *
499      * Requirements:
500      *
501      * - the calling contract must have an ETH balance of at least `value`.
502      * - the called Solidity function must be `payable`.
503      *
504      * _Available since v3.1._
505      */
506     function functionCallWithValue(
507         address target,
508         bytes memory data,
509         uint256 value
510     ) internal returns (bytes memory) {
511         return
512             functionCallWithValue(
513                 target,
514                 data,
515                 value,
516                 "Address: low-level call with value failed"
517             );
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
522      * with `errorMessage` as a fallback revert reason when `target` reverts.
523      *
524      * _Available since v3.1._
525      */
526     function functionCallWithValue(
527         address target,
528         bytes memory data,
529         uint256 value,
530         string memory errorMessage
531     ) internal returns (bytes memory) {
532         require(
533             address(this).balance >= value,
534             "Address: insufficient balance for call"
535         );
536         require(isContract(target), "Address: call to non-contract");
537 
538         (bool success, bytes memory returndata) = target.call{value: value}(
539             data
540         );
541         return _verifyCallResult(success, returndata, errorMessage);
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
546      * but performing a static call.
547      *
548      * _Available since v3.3._
549      */
550     function functionStaticCall(address target, bytes memory data)
551         internal
552         view
553         returns (bytes memory)
554     {
555         return
556             functionStaticCall(
557                 target,
558                 data,
559                 "Address: low-level static call failed"
560             );
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
565      * but performing a static call.
566      *
567      * _Available since v3.3._
568      */
569     function functionStaticCall(
570         address target,
571         bytes memory data,
572         string memory errorMessage
573     ) internal view returns (bytes memory) {
574         require(isContract(target), "Address: static call to non-contract");
575 
576         (bool success, bytes memory returndata) = target.staticcall(data);
577         return _verifyCallResult(success, returndata, errorMessage);
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
582      * but performing a delegate call.
583      *
584      * _Available since v3.4._
585      */
586     function functionDelegateCall(address target, bytes memory data)
587         internal
588         returns (bytes memory)
589     {
590         return
591             functionDelegateCall(
592                 target,
593                 data,
594                 "Address: low-level delegate call failed"
595             );
596     }
597 
598     /**
599      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
600      * but performing a delegate call.
601      *
602      * _Available since v3.4._
603      */
604     function functionDelegateCall(
605         address target,
606         bytes memory data,
607         string memory errorMessage
608     ) internal returns (bytes memory) {
609         require(isContract(target), "Address: delegate call to non-contract");
610 
611         (bool success, bytes memory returndata) = target.delegatecall(data);
612         return _verifyCallResult(success, returndata, errorMessage);
613     }
614 
615     function _verifyCallResult(
616         bool success,
617         bytes memory returndata,
618         string memory errorMessage
619     ) private pure returns (bytes memory) {
620         if (success) {
621             return returndata;
622         } else {
623             // Look for revert reason and bubble it up if present
624             if (returndata.length > 0) {
625                 // The easiest way to bubble the revert reason is using memory via assembly
626 
627                 assembly {
628                     let returndata_size := mload(returndata)
629                     revert(add(32, returndata), returndata_size)
630                 }
631             } else {
632                 revert(errorMessage);
633             }
634         }
635     }
636 }
637 
638 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
639 
640 pragma solidity ^0.8.0;
641 
642 /**
643  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
644  * @dev See https://eips.ethereum.org/EIPS/eip-721
645  */
646 interface IERC721Metadata is IERC721 {
647     /**
648      * @dev Returns the token collection name.
649      */
650     function name() external view returns (string memory);
651 
652     /**
653      * @dev Returns the token collection symbol.
654      */
655     function symbol() external view returns (string memory);
656 
657     /**
658      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
659      */
660     function tokenURI(uint256 tokenId) external view returns (string memory);
661 }
662 
663 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
664 
665 pragma solidity ^0.8.0;
666 
667 /**
668  * @title ERC721 token receiver interface
669  * @dev Interface for any contract that wants to support safeTransfers
670  * from ERC721 asset contracts.
671  */
672 interface IERC721Receiver {
673     /**
674      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
675      * by `operator` from `from`, this function is called.
676      *
677      * It must return its Solidity selector to confirm the token transfer.
678      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
679      *
680      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
681      */
682     function onERC721Received(
683         address operator,
684         address from,
685         uint256 tokenId,
686         bytes calldata data
687     ) external returns (bytes4);
688 }
689 
690 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
691 
692 pragma solidity ^0.8.0;
693 
694 /**
695  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
696  * the Metadata extension, but not including the Enumerable extension, which is available separately as
697  * {ERC721Enumerable}.
698  */
699 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
700     using Address for address;
701     using Strings for uint256;
702 
703     // Token name
704     string private _name;
705 
706     // Token symbol
707     string private _symbol;
708 
709     // Mapping from token ID to owner address
710     mapping(uint256 => address) private _owners;
711 
712     // Mapping owner address to token count
713     mapping(address => uint256) private _balances;
714 
715     // Mapping from token ID to approved address
716     mapping(uint256 => address) private _tokenApprovals;
717 
718     // Mapping from owner to operator approvals
719     mapping(address => mapping(address => bool)) private _operatorApprovals;
720 
721     /**
722      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
723      */
724     constructor(string memory name_, string memory symbol_) {
725         _name = name_;
726         _symbol = symbol_;
727     }
728 
729     /**
730      * @dev See {IERC165-supportsInterface}.
731      */
732     function supportsInterface(bytes4 interfaceId)
733         public
734         view
735         virtual
736         override(ERC165, IERC165)
737         returns (bool)
738     {
739         return
740             interfaceId == type(IERC721).interfaceId ||
741             interfaceId == type(IERC721Metadata).interfaceId ||
742             super.supportsInterface(interfaceId);
743     }
744 
745     /**
746      * @dev See {IERC721-balanceOf}.
747      */
748     function balanceOf(address owner)
749         public
750         view
751         virtual
752         override
753         returns (uint256)
754     {
755         require(
756             owner != address(0),
757             "ERC721: balance query for the zero address"
758         );
759         return _balances[owner];
760     }
761 
762     /**
763      * @dev See {IERC721-ownerOf}.
764      */
765     function ownerOf(uint256 tokenId)
766         public
767         view
768         virtual
769         override
770         returns (address)
771     {
772         address owner = _owners[tokenId];
773         require(
774             owner != address(0),
775             "ERC721: owner query for nonexistent token"
776         );
777         return owner;
778     }
779 
780     /**
781      * @dev See {IERC721Metadata-name}.
782      */
783     function name() public view virtual override returns (string memory) {
784         return _name;
785     }
786 
787     /**
788      * @dev See {IERC721Metadata-symbol}.
789      */
790     function symbol() public view virtual override returns (string memory) {
791         return _symbol;
792     }
793 
794     /**
795      * @dev See {IERC721Metadata-tokenURI}.
796      */
797     function tokenURI(uint256 tokenId)
798         public
799         view
800         virtual
801         override
802         returns (string memory)
803     {
804         require(
805             _exists(tokenId),
806             "ERC721Metadata: URI query for nonexistent token"
807         );
808 
809         string memory baseURI = _baseURI();
810         return
811             bytes(baseURI).length > 0
812                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
813                 : "";
814     }
815 
816     /**
817      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
818      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
819      * by default, can be overriden in child contracts.
820      */
821     function _baseURI() internal view virtual returns (string memory) {
822         return "";
823     }
824 
825     /**
826      * @dev See {IERC721-approve}.
827      */
828     function approve(address to, uint256 tokenId) public virtual override {
829         address owner = ERC721.ownerOf(tokenId);
830         require(to != owner, "ERC721: approval to current owner");
831 
832         require(
833             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
834             "ERC721: approve caller is not owner nor approved for all"
835         );
836 
837         _approve(to, tokenId);
838     }
839 
840     /**
841      * @dev See {IERC721-getApproved}.
842      */
843     function getApproved(uint256 tokenId)
844         public
845         view
846         virtual
847         override
848         returns (address)
849     {
850         require(
851             _exists(tokenId),
852             "ERC721: approved query for nonexistent token"
853         );
854 
855         return _tokenApprovals[tokenId];
856     }
857 
858     /**
859      * @dev See {IERC721-setApprovalForAll}.
860      */
861     function setApprovalForAll(address operator, bool approved)
862         public
863         virtual
864         override
865     {
866         require(operator != _msgSender(), "ERC721: approve to caller");
867 
868         _operatorApprovals[_msgSender()][operator] = approved;
869         emit ApprovalForAll(_msgSender(), operator, approved);
870     }
871 
872     /**
873      * @dev See {IERC721-isApprovedForAll}.
874      */
875     function isApprovedForAll(address owner, address operator)
876         public
877         view
878         virtual
879         override
880         returns (bool)
881     {
882         return _operatorApprovals[owner][operator];
883     }
884 
885     /**
886      * @dev See {IERC721-transferFrom}.
887      */
888     function transferFrom(
889         address from,
890         address to,
891         uint256 tokenId
892     ) public virtual override {
893         //solhint-disable-next-line max-line-length
894         require(
895             _isApprovedOrOwner(_msgSender(), tokenId),
896             "ERC721: transfer caller is not owner nor approved"
897         );
898 
899         _transfer(from, to, tokenId);
900     }
901 
902     /**
903      * @dev See {IERC721-safeTransferFrom}.
904      */
905     function safeTransferFrom(
906         address from,
907         address to,
908         uint256 tokenId
909     ) public virtual override {
910         safeTransferFrom(from, to, tokenId, "");
911     }
912 
913     /**
914      * @dev See {IERC721-safeTransferFrom}.
915      */
916     function safeTransferFrom(
917         address from,
918         address to,
919         uint256 tokenId,
920         bytes memory _data
921     ) public virtual override {
922         require(
923             _isApprovedOrOwner(_msgSender(), tokenId),
924             "ERC721: transfer caller is not owner nor approved"
925         );
926         _safeTransfer(from, to, tokenId, _data);
927     }
928 
929     /**
930      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
931      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
932      *
933      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
934      *
935      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
936      * implement alternative mechanisms to perform token transfer, such as signature-based.
937      *
938      * Requirements:
939      *
940      * - `from` cannot be the zero address.
941      * - `to` cannot be the zero address.
942      * - `tokenId` token must exist and be owned by `from`.
943      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
944      *
945      * Emits a {Transfer} event.
946      */
947     function _safeTransfer(
948         address from,
949         address to,
950         uint256 tokenId,
951         bytes memory _data
952     ) internal virtual {
953         _transfer(from, to, tokenId);
954         require(
955             _checkOnERC721Received(from, to, tokenId, _data),
956             "ERC721: transfer to non ERC721Receiver implementer"
957         );
958     }
959 
960     /**
961      * @dev Returns whether `tokenId` exists.
962      *
963      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
964      *
965      * Tokens start existing when they are minted (`_mint`),
966      * and stop existing when they are burned (`_burn`).
967      */
968     function _exists(uint256 tokenId) internal view virtual returns (bool) {
969         return _owners[tokenId] != address(0);
970     }
971 
972     /**
973      * @dev Returns whether `spender` is allowed to manage `tokenId`.
974      *
975      * Requirements:
976      *
977      * - `tokenId` must exist.
978      */
979     function _isApprovedOrOwner(address spender, uint256 tokenId)
980         internal
981         view
982         virtual
983         returns (bool)
984     {
985         require(
986             _exists(tokenId),
987             "ERC721: operator query for nonexistent token"
988         );
989         address owner = ERC721.ownerOf(tokenId);
990         return (spender == owner ||
991             getApproved(tokenId) == spender ||
992             isApprovedForAll(owner, spender));
993     }
994 
995     /**
996      * @dev Safely mints `tokenId` and transfers it to `to`.
997      *
998      * Requirements:
999      *
1000      * - `tokenId` must not exist.
1001      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _safeMint(address to, uint256 tokenId) internal virtual {
1006         _safeMint(to, tokenId, "");
1007     }
1008 
1009     /**
1010      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1011      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1012      */
1013     function _safeMint(
1014         address to,
1015         uint256 tokenId,
1016         bytes memory _data
1017     ) internal virtual {
1018         _mint(to, tokenId);
1019         require(
1020             _checkOnERC721Received(address(0), to, tokenId, _data),
1021             "ERC721: transfer to non ERC721Receiver implementer"
1022         );
1023     }
1024 
1025     /**
1026      * @dev Mints `tokenId` and transfers it to `to`.
1027      *
1028      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1029      *
1030      * Requirements:
1031      *
1032      * - `tokenId` must not exist.
1033      * - `to` cannot be the zero address.
1034      *
1035      * Emits a {Transfer} event.
1036      */
1037     function _mint(address to, uint256 tokenId) internal virtual {
1038         require(to != address(0), "ERC721: mint to the zero address");
1039         require(!_exists(tokenId), "ERC721: token already minted");
1040 
1041         _beforeTokenTransfer(address(0), to, tokenId);
1042 
1043         _balances[to] += 1;
1044         _owners[tokenId] = to;
1045 
1046         emit Transfer(address(0), to, tokenId);
1047     }
1048 
1049     /**
1050      * @dev Destroys `tokenId`.
1051      * The approval is cleared when the token is burned.
1052      *
1053      * Requirements:
1054      *
1055      * - `tokenId` must exist.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _burn(uint256 tokenId) internal virtual {
1060         address owner = ERC721.ownerOf(tokenId);
1061 
1062         _beforeTokenTransfer(owner, address(0), tokenId);
1063 
1064         // Clear approvals
1065         _approve(address(0), tokenId);
1066 
1067         _balances[owner] -= 1;
1068         delete _owners[tokenId];
1069 
1070         emit Transfer(owner, address(0), tokenId);
1071     }
1072 
1073     /**
1074      * @dev Transfers `tokenId` from `from` to `to`.
1075      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1076      *
1077      * Requirements:
1078      *
1079      * - `to` cannot be the zero address.
1080      * - `tokenId` token must be owned by `from`.
1081      *
1082      * Emits a {Transfer} event.
1083      */
1084     function _transfer(
1085         address from,
1086         address to,
1087         uint256 tokenId
1088     ) internal virtual {
1089         require(
1090             ERC721.ownerOf(tokenId) == from,
1091             "ERC721: transfer of token that is not own"
1092         );
1093         require(to != address(0), "ERC721: transfer to the zero address");
1094 
1095         _beforeTokenTransfer(from, to, tokenId);
1096 
1097         // Clear approvals from the previous owner
1098         _approve(address(0), tokenId);
1099 
1100         _balances[from] -= 1;
1101         _balances[to] += 1;
1102         _owners[tokenId] = to;
1103 
1104         emit Transfer(from, to, tokenId);
1105     }
1106 
1107     /**
1108      * @dev Approve `to` to operate on `tokenId`
1109      *
1110      * Emits a {Approval} event.
1111      */
1112     function _approve(address to, uint256 tokenId) internal virtual {
1113         _tokenApprovals[tokenId] = to;
1114         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1115     }
1116 
1117     /**
1118      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1119      * The call is not executed if the target address is not a contract.
1120      *
1121      * @param from address representing the previous owner of the given token ID
1122      * @param to target address that will receive the tokens
1123      * @param tokenId uint256 ID of the token to be transferred
1124      * @param _data bytes optional data to send along with the call
1125      * @return bool whether the call correctly returned the expected magic value
1126      */
1127     function _checkOnERC721Received(
1128         address from,
1129         address to,
1130         uint256 tokenId,
1131         bytes memory _data
1132     ) private returns (bool) {
1133         if (to.isContract()) {
1134             try
1135                 IERC721Receiver(to).onERC721Received(
1136                     _msgSender(),
1137                     from,
1138                     tokenId,
1139                     _data
1140                 )
1141             returns (bytes4 retval) {
1142                 return retval == IERC721Receiver(to).onERC721Received.selector;
1143             } catch (bytes memory reason) {
1144                 if (reason.length == 0) {
1145                     revert(
1146                         "ERC721: transfer to non ERC721Receiver implementer"
1147                     );
1148                 } else {
1149                     assembly {
1150                         revert(add(32, reason), mload(reason))
1151                     }
1152                 }
1153             }
1154         } else {
1155             return true;
1156         }
1157     }
1158 
1159     /**
1160      * @dev Hook that is called before any token transfer. This includes minting
1161      * and burning.
1162      *
1163      * Calling conditions:
1164      *
1165      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1166      * transferred to `to`.
1167      * - When `from` is zero, `tokenId` will be minted for `to`.
1168      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1169      * - `from` and `to` are never both zero.
1170      *
1171      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1172      */
1173     function _beforeTokenTransfer(
1174         address from,
1175         address to,
1176         uint256 tokenId
1177     ) internal virtual {}
1178 }
1179 
1180 pragma solidity ^0.8.0;
1181 
1182 contract MferNFT is ERC721, Ownable {
1183     uint16 public mintCount = 0;
1184     uint16 supply = totalSupply();
1185 
1186     uint256 public MAX_SUPPLY = 8888;
1187     uint256 public OWNER_RESERVED = 150;
1188     uint256 public MAX_ALLOWED = 20;
1189     uint256 public price = 15000000000000000; //0.015 Ether
1190     string baseTokenURI;
1191     
1192     bool public saleOpen = true;
1193     
1194     event NFTMinted(uint256 totalMinted);
1195 
1196     constructor(string memory baseURI) ERC721("Mfer Kids", "MFER") {
1197         setBaseURI(baseURI);
1198     }
1199 
1200     function setBaseURI(string memory baseURI) public onlyOwner {
1201         baseTokenURI = baseURI;
1202     }
1203 
1204     function setPrice(uint256 _newPrice) public onlyOwner {
1205         price = _newPrice;
1206     }
1207 
1208     function setMaxAllowd(uint256 _maxAllowed) public onlyOwner {
1209         MAX_ALLOWED = _maxAllowed;
1210     }
1211 
1212     function setMaxSupply(uint256 _max_supply) public onlyOwner {
1213         MAX_SUPPLY = _max_supply;
1214     }
1215     
1216     function setMintCount(uint16 _mintCount) public onlyOwner {
1217         mintCount = _mintCount;
1218     }
1219 
1220     function setOwnerReserved(uint16 _OwnerReserved) public onlyOwner {
1221         OWNER_RESERVED = _OwnerReserved;
1222     }
1223     
1224     function totalSupply() public view returns (uint16) {
1225         return mintCount;
1226     }
1227 
1228     function burnUnsold() external onlyOwner {
1229         MAX_SUPPLY = totalSupply();
1230     }
1231 
1232     function getPrice() external view returns(uint256){
1233         return price;
1234     }
1235     
1236     //Close sale
1237     function pauseSale() public onlyOwner {
1238         saleOpen = false;
1239     }
1240     
1241     //Open sale
1242     function unpauseSale() public onlyOwner {
1243         saleOpen = true;
1244     }
1245 
1246     function withdrawAll() public onlyOwner {
1247         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1248         require(success, "Transfer failed.");
1249     }
1250     
1251     //mint NFT
1252     function mintNFT(uint16 _count) public payable {
1253         supply = totalSupply();
1254 
1255         if (msg.sender != owner()) {
1256             require((saleOpen == true), "Sale is not open please try again later");
1257         }
1258         
1259         require(
1260             _count > 0 && (balanceOf(msg.sender)+_count) <= MAX_ALLOWED,
1261            "You have reached the NFT minting limit per transaction"
1262         );
1263         
1264         require(balanceOf(msg.sender) < MAX_ALLOWED, "You have reached maximum NFT minting limit per account");
1265         
1266         if (msg.sender != owner()) {
1267             require(
1268                 totalSupply() + _count <= (MAX_SUPPLY - OWNER_RESERVED),
1269                 "All NFTs sold"
1270             );
1271         }
1272         
1273         require(
1274             msg.value >= price * _count,
1275             "Ether sent with this transaction is not correct"
1276         );
1277 
1278         mintCount += _count;
1279 
1280         for (uint256 i = 0; i < _count; i++) {
1281             _safeMint(_msgSender(), ++supply);
1282             emit NFTMinted(supply);
1283         }
1284     }
1285     
1286     function mintReserved(uint16 _count) external onlyOwner{
1287         require(OWNER_RESERVED > 0,"You have already minted all reserved");
1288         for (uint16 i = 0; i < _count; i++) {
1289             _safeMint(msg.sender, ++supply);
1290         }
1291         mintCount = mintCount + _count;
1292         OWNER_RESERVED--;
1293     }
1294 
1295     function airdrop(address[] calldata _recipients) external onlyOwner {
1296         supply = totalSupply();
1297         require(
1298             totalSupply() + _recipients.length <= MAX_SUPPLY,
1299             "Airdrop minting will exceed maximum supply"
1300         );
1301         require(_recipients.length != 0, "Address not found for minting");
1302         for (uint256 i = 0; i < _recipients.length; i++) {
1303             require(_recipients[i] != address(0), "Minting to Null address");
1304             _safeMint(_recipients[i], ++supply);
1305         }
1306         mintCount = mintCount + uint16(_recipients.length);
1307     }
1308 
1309     function _baseURI() internal view virtual override returns (string memory) {
1310         return baseTokenURI;
1311     }
1312 }