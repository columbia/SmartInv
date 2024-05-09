1 // File: contracts/CryptoTribe.sol
2 
3 /**
4    ___                 _          _____      _ _          
5   / __\ __ _   _ _ __ | |_ ___   /__   \_ __(_) |__   ___ 
6  / / | '__| | | | '_ \| __/ _ \    / /\/ '__| | '_ \ / _ \
7 / /__| |  | |_| | |_) | || (_) |  / /  | |  | | |_) |  __/
8 \____/_|   \__, | .__/ \__\___/   \/   |_|  |_|_.__/ \___|
9            |___/|_|                                       
10  */
11 
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         return msg.data;
32     }
33 }
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev String operations.
38  */
39 library Strings {
40     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
44      */
45     function toString(uint256 value) internal pure returns (string memory) {
46         // Inspired by OraclizeAPI's implementation - MIT licence
47         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
48 
49         if (value == 0) {
50             return "0";
51         }
52         uint256 temp = value;
53         uint256 digits;
54         while (temp != 0) {
55             digits++;
56             temp /= 10;
57         }
58         bytes memory buffer = new bytes(digits);
59         while (value != 0) {
60             digits -= 1;
61             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
62             value /= 10;
63         }
64         return string(buffer);
65     }
66 
67     /**
68      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
69      */
70     function toHexString(uint256 value) internal pure returns (string memory) {
71         if (value == 0) {
72             return "0x00";
73         }
74         uint256 temp = value;
75         uint256 length = 0;
76         while (temp != 0) {
77             length++;
78             temp >>= 8;
79         }
80         return toHexString(value, length);
81     }
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
85      */
86     function toHexString(uint256 value, uint256 length)
87         internal
88         pure
89         returns (string memory)
90     {
91         bytes memory buffer = new bytes(2 * length + 2);
92         buffer[0] = "0";
93         buffer[1] = "x";
94         for (uint256 i = 2 * length + 1; i > 1; --i) {
95             buffer[i] = _HEX_SYMBOLS[value & 0xf];
96             value >>= 4;
97         }
98         require(value == 0, "Strings: hex length insufficient");
99         return string(buffer);
100     }
101 }
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev Collection of functions related to the address type
106  */
107 library Address {
108     /**
109      * @dev Returns true if `account` is a contract.
110      *
111      * [IMPORTANT]
112      * ====
113      * It is unsafe to assume that an address for which this function returns
114      * false is an externally-owned account (EOA) and not a contract.
115      *
116      * Among others, `isContract` will return false for the following
117      * types of addresses:
118      *
119      *  - an externally-owned account
120      *  - a contract in construction
121      *  - an address where a contract will be created
122      *  - an address where a contract lived, but was destroyed
123      * ====
124      */
125     function isContract(address account) internal view returns (bool) {
126         // This method relies on extcodesize, which returns 0 for contracts in
127         // construction, since the code is only stored at the end of the
128         // constructor execution.
129 
130         uint256 size;
131         assembly {
132             size := extcodesize(account)
133         }
134         return size > 0;
135     }
136 
137     /**
138      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
139      * `recipient`, forwarding all available gas and reverting on errors.
140      *
141      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
142      * of certain opcodes, possibly making contracts go over the 2300 gas limit
143      * imposed by `transfer`, making them unable to receive funds via
144      * `transfer`. {sendValue} removes this limitation.
145      *
146      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
147      *
148      * IMPORTANT: because control is transferred to `recipient`, care must be
149      * taken to not create reentrancy vulnerabilities. Consider using
150      * {ReentrancyGuard} or the
151      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
152      */
153     function sendValue(address payable recipient, uint256 amount) internal {
154         require(
155             address(this).balance >= amount,
156             "Address: insufficient balance"
157         );
158 
159         (bool success, ) = recipient.call{value: amount}("");
160         require(
161             success,
162             "Address: unable to send value, recipient may have reverted"
163         );
164     }
165 
166     /**
167      * @dev Performs a Solidity function call using a low level `call`. A
168      * plain `call` is an unsafe replacement for a function call: use this
169      * function instead.
170      *
171      * If `target` reverts with a revert reason, it is bubbled up by this
172      * function (like regular Solidity function calls).
173      *
174      * Returns the raw returned data. To convert to the expected return value,
175      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
176      *
177      * Requirements:
178      *
179      * - `target` must be a contract.
180      * - calling `target` with `data` must not revert.
181      *
182      * _Available since v3.1._
183      */
184     function functionCall(address target, bytes memory data)
185         internal
186         returns (bytes memory)
187     {
188         return functionCall(target, data, "Address: low-level call failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
193      * `errorMessage` as a fallback revert reason when `target` reverts.
194      *
195      * _Available since v3.1._
196      */
197     function functionCall(
198         address target,
199         bytes memory data,
200         string memory errorMessage
201     ) internal returns (bytes memory) {
202         return functionCallWithValue(target, data, 0, errorMessage);
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
207      * but also transferring `value` wei to `target`.
208      *
209      * Requirements:
210      *
211      * - the calling contract must have an ETH balance of at least `value`.
212      * - the called Solidity function must be `payable`.
213      *
214      * _Available since v3.1._
215      */
216     function functionCallWithValue(
217         address target,
218         bytes memory data,
219         uint256 value
220     ) internal returns (bytes memory) {
221         return
222             functionCallWithValue(
223                 target,
224                 data,
225                 value,
226                 "Address: low-level call with value failed"
227             );
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
232      * with `errorMessage` as a fallback revert reason when `target` reverts.
233      *
234      * _Available since v3.1._
235      */
236     function functionCallWithValue(
237         address target,
238         bytes memory data,
239         uint256 value,
240         string memory errorMessage
241     ) internal returns (bytes memory) {
242         require(
243             address(this).balance >= value,
244             "Address: insufficient balance for call"
245         );
246         require(isContract(target), "Address: call to non-contract");
247 
248         (bool success, bytes memory returndata) = target.call{value: value}(
249             data
250         );
251         return verifyCallResult(success, returndata, errorMessage);
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
256      * but performing a static call.
257      *
258      * _Available since v3.3._
259      */
260     function functionStaticCall(address target, bytes memory data)
261         internal
262         view
263         returns (bytes memory)
264     {
265         return
266             functionStaticCall(
267                 target,
268                 data,
269                 "Address: low-level static call failed"
270             );
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
275      * but performing a static call.
276      *
277      * _Available since v3.3._
278      */
279     function functionStaticCall(
280         address target,
281         bytes memory data,
282         string memory errorMessage
283     ) internal view returns (bytes memory) {
284         require(isContract(target), "Address: static call to non-contract");
285 
286         (bool success, bytes memory returndata) = target.staticcall(data);
287         return verifyCallResult(success, returndata, errorMessage);
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
292      * but performing a delegate call.
293      *
294      * _Available since v3.4._
295      */
296     function functionDelegateCall(address target, bytes memory data)
297         internal
298         returns (bytes memory)
299     {
300         return
301             functionDelegateCall(
302                 target,
303                 data,
304                 "Address: low-level delegate call failed"
305             );
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
310      * but performing a delegate call.
311      *
312      * _Available since v3.4._
313      */
314     function functionDelegateCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         require(isContract(target), "Address: delegate call to non-contract");
320 
321         (bool success, bytes memory returndata) = target.delegatecall(data);
322         return verifyCallResult(success, returndata, errorMessage);
323     }
324 
325     /**
326      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
327      * revert reason using the provided one.
328      *
329      * _Available since v4.3._
330      */
331     function verifyCallResult(
332         bool success,
333         bytes memory returndata,
334         string memory errorMessage
335     ) internal pure returns (bytes memory) {
336         if (success) {
337             return returndata;
338         } else {
339             // Look for revert reason and bubble it up if present
340             if (returndata.length > 0) {
341                 // The easiest way to bubble the revert reason is using memory via assembly
342 
343                 assembly {
344                     let returndata_size := mload(returndata)
345                     revert(add(32, returndata), returndata_size)
346                 }
347             } else {
348                 revert(errorMessage);
349             }
350         }
351     }
352 }
353 pragma solidity ^0.8.0;
354 
355 /**
356  * @dev Interface of the ERC165 standard, as defined in the
357  * https://eips.ethereum.org/EIPS/eip-165[EIP].
358  *
359  * Implementers can declare support of contract interfaces, which can then be
360  * queried by others ({ERC165Checker}).
361  *
362  * For an implementation, see {ERC165}.
363  */
364 interface IERC165 {
365     /**
366      * @dev Returns true if this contract implements the interface defined by
367      * `interfaceId`. See the corresponding
368      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
369      * to learn more about how these ids are created.
370      *
371      * This function call must use less than 30 000 gas.
372      */
373     function supportsInterface(bytes4 interfaceId) external view returns (bool);
374 }
375 pragma solidity ^0.8.0;
376 
377 /**
378  * @title ERC721 token receiver interface
379  * @dev Interface for any contract that wants to support safeTransfers
380  * from ERC721 asset contracts.
381  */
382 interface IERC721Receiver {
383     /**
384      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
385      * by `operator` from `from`, this function is called.
386      *
387      * It must return its Solidity selector to confirm the token transfer.
388      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
389      *
390      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
391      */
392     function onERC721Received(
393         address operator,
394         address from,
395         uint256 tokenId,
396         bytes calldata data
397     ) external returns (bytes4);
398 }
399 pragma solidity ^0.8.0;
400 
401 /**
402  * @dev Contract module which provides a basic access control mechanism, where
403  * there is an account (an owner) that can be granted exclusive access to
404  * specific functions.
405  *
406  * By default, the owner account will be the one that deploys the contract. This
407  * can later be changed with {transferOwnership}.
408  *
409  * This module is used through inheritance. It will make available the modifier
410  * `onlyOwner`, which can be applied to your functions to restrict their use to
411  * the owner.
412  */
413 abstract contract Ownable is Context {
414     address private _owner;
415 
416     event OwnershipTransferred(
417         address indexed previousOwner,
418         address indexed newOwner
419     );
420 
421     /**
422      * @dev Initializes the contract setting the deployer as the initial owner.
423      */
424     constructor() {
425         _setOwner(_msgSender());
426     }
427 
428     /**
429      * @dev Returns the address of the current owner.
430      */
431     function owner() public view virtual returns (address) {
432         return _owner;
433     }
434 
435     /**
436      * @dev Throws if called by any account other than the owner.
437      */
438     modifier onlyOwner() {
439         require(owner() == _msgSender(), "Ownable: caller is not the owner");
440         _;
441     }
442 
443     /**
444      * @dev Leaves the contract without owner. It will not be possible to call
445      * `onlyOwner` functions anymore. Can only be called by the current owner.
446      *
447      * NOTE: Renouncing ownership will leave the contract without an owner,
448      * thereby removing any functionality that is only available to the owner.
449      */
450     function renounceOwnership() public virtual onlyOwner {
451         _setOwner(address(0));
452     }
453 
454     /**
455      * @dev Transfers ownership of the contract to a new account (`newOwner`).
456      * Can only be called by the current owner.
457      */
458     function transferOwnership(address newOwner) public virtual onlyOwner {
459         require(
460             newOwner != address(0),
461             "Ownable: new owner is the zero address"
462         );
463         _setOwner(newOwner);
464     }
465 
466     function _setOwner(address newOwner) private {
467         address oldOwner = _owner;
468         _owner = newOwner;
469         emit OwnershipTransferred(oldOwner, newOwner);
470     }
471 }
472 pragma solidity ^0.8.0;
473 
474 /**
475  * @dev Implementation of the {IERC165} interface.
476  *
477  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
478  * for the additional interface id that will be supported. For example:
479  *
480  * ```solidity
481  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
482  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
483  * }
484  * ```
485  *
486  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
487  */
488 abstract contract ERC165 is IERC165 {
489     /**
490      * @dev See {IERC165-supportsInterface}.
491      */
492     function supportsInterface(bytes4 interfaceId)
493         public
494         view
495         virtual
496         override
497         returns (bool)
498     {
499         return interfaceId == type(IERC165).interfaceId;
500     }
501 }
502 pragma solidity ^0.8.0;
503 
504 /**
505  * @dev Required interface of an ERC721 compliant contract.
506  */
507 interface IERC721 is IERC165 {
508     /**
509      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
510      */
511     event Transfer(
512         address indexed from,
513         address indexed to,
514         uint256 indexed tokenId
515     );
516 
517     /**
518      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
519      */
520     event Approval(
521         address indexed owner,
522         address indexed approved,
523         uint256 indexed tokenId
524     );
525 
526     /**
527      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
528      */
529     event ApprovalForAll(
530         address indexed owner,
531         address indexed operator,
532         bool approved
533     );
534 
535     /**
536      * @dev Returns the number of tokens in ``owner``'s account.
537      */
538     function balanceOf(address owner) external view returns (uint256 balance);
539 
540     /**
541      * @dev Returns the owner of the `tokenId` token.
542      *
543      * Requirements:
544      *
545      * - `tokenId` must exist.
546      */
547     function ownerOf(uint256 tokenId) external view returns (address owner);
548 
549     /**
550      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
551      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
552      *
553      * Requirements:
554      *
555      * - `from` cannot be the zero address.
556      * - `to` cannot be the zero address.
557      * - `tokenId` token must exist and be owned by `from`.
558      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
559      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
560      *
561      * Emits a {Transfer} event.
562      */
563     function safeTransferFrom(
564         address from,
565         address to,
566         uint256 tokenId
567     ) external;
568 
569     /**
570      * @dev Transfers `tokenId` token from `from` to `to`.
571      *
572      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
573      *
574      * Requirements:
575      *
576      * - `from` cannot be the zero address.
577      * - `to` cannot be the zero address.
578      * - `tokenId` token must be owned by `from`.
579      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
580      *
581      * Emits a {Transfer} event.
582      */
583     function transferFrom(
584         address from,
585         address to,
586         uint256 tokenId
587     ) external;
588 
589     /**
590      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
591      * The approval is cleared when the token is transferred.
592      *
593      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
594      *
595      * Requirements:
596      *
597      * - The caller must own the token or be an approved operator.
598      * - `tokenId` must exist.
599      *
600      * Emits an {Approval} event.
601      */
602     function approve(address to, uint256 tokenId) external;
603 
604     /**
605      * @dev Returns the account approved for `tokenId` token.
606      *
607      * Requirements:
608      *
609      * - `tokenId` must exist.
610      */
611     function getApproved(uint256 tokenId)
612         external
613         view
614         returns (address operator);
615 
616     /**
617      * @dev Approve or remove `operator` as an operator for the caller.
618      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
619      *
620      * Requirements:
621      *
622      * - The `operator` cannot be the caller.
623      *
624      * Emits an {ApprovalForAll} event.
625      */
626     function setApprovalForAll(address operator, bool _approved) external;
627 
628     /**
629      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
630      *
631      * See {setApprovalForAll}
632      */
633     function isApprovedForAll(address owner, address operator)
634         external
635         view
636         returns (bool);
637 
638     /**
639      * @dev Safely transfers `tokenId` token from `from` to `to`.
640      *
641      * Requirements:
642      *
643      * - `from` cannot be the zero address.
644      * - `to` cannot be the zero address.
645      * - `tokenId` token must exist and be owned by `from`.
646      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
647      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
648      *
649      * Emits a {Transfer} event.
650      */
651     function safeTransferFrom(
652         address from,
653         address to,
654         uint256 tokenId,
655         bytes calldata data
656     ) external;
657 }
658 pragma solidity ^0.8.0;
659 
660 /**
661  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
662  * @dev See https://eips.ethereum.org/EIPS/eip-721
663  */
664 interface IERC721Metadata is IERC721 {
665     /**
666      * @dev Returns the token collection name.
667      */
668     function name() external view returns (string memory);
669 
670     /**
671      * @dev Returns the token collection symbol.
672      */
673     function symbol() external view returns (string memory);
674 
675     /**
676      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
677      */
678     function tokenURI(uint256 tokenId) external view returns (string memory);
679 }
680 pragma solidity ^0.8.0;
681 
682 /**
683  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
684  * the Metadata extension, but not including the Enumerable extension, which is available separately as
685  * {ERC721Enumerable}.
686  */
687 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
688     using Address for address;
689     using Strings for uint256;
690 
691     // Token name
692     string private _name;
693 
694     // Token symbol
695     string private _symbol;
696 
697     // Mapping from token ID to owner address
698     mapping(uint256 => address) private _owners;
699 
700     // Mapping owner address to token count
701     mapping(address => uint256) private _balances;
702 
703     // Mapping from token ID to approved address
704     mapping(uint256 => address) private _tokenApprovals;
705 
706     // Mapping from owner to operator approvals
707     mapping(address => mapping(address => bool)) private _operatorApprovals;
708 
709     /**
710      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
711      */
712     constructor(string memory name_, string memory symbol_) {
713         _name = name_;
714         _symbol = symbol_;
715     }
716 
717     /**
718      * @dev See {IERC165-supportsInterface}.
719      */
720     function supportsInterface(bytes4 interfaceId)
721         public
722         view
723         virtual
724         override(ERC165, IERC165)
725         returns (bool)
726     {
727         return
728             interfaceId == type(IERC721).interfaceId ||
729             interfaceId == type(IERC721Metadata).interfaceId ||
730             super.supportsInterface(interfaceId);
731     }
732 
733     /**
734      * @dev See {IERC721-balanceOf}.
735      */
736     function balanceOf(address owner)
737         public
738         view
739         virtual
740         override
741         returns (uint256)
742     {
743         require(
744             owner != address(0),
745             "ERC721: balance query for the zero address"
746         );
747         return _balances[owner];
748     }
749 
750     /**
751      * @dev See {IERC721-ownerOf}.
752      */
753     function ownerOf(uint256 tokenId)
754         public
755         view
756         virtual
757         override
758         returns (address)
759     {
760         address owner = _owners[tokenId];
761         require(
762             owner != address(0),
763             "ERC721: owner query for nonexistent token"
764         );
765         return owner;
766     }
767 
768     /**
769      * @dev See {IERC721Metadata-name}.
770      */
771     function name() public view virtual override returns (string memory) {
772         return _name;
773     }
774 
775     /**
776      * @dev See {IERC721Metadata-symbol}.
777      */
778     function symbol() public view virtual override returns (string memory) {
779         return _symbol;
780     }
781 
782     /**
783      * @dev See {IERC721Metadata-tokenURI}.
784      */
785     function tokenURI(uint256 tokenId)
786         public
787         view
788         virtual
789         override
790         returns (string memory)
791     {
792         require(
793             _exists(tokenId),
794             "ERC721Metadata: URI query for nonexistent token"
795         );
796 
797         string memory baseURI = _baseURI();
798         return
799             bytes(baseURI).length > 0
800                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
801                 : "";
802     }
803 
804     /**
805      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
806      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
807      * by default, can be overriden in child contracts.
808      */
809     function _baseURI() internal view virtual returns (string memory) {
810         return "";
811     }
812 
813     /**
814      * @dev See {IERC721-approve}.
815      */
816     function approve(address to, uint256 tokenId) public virtual override {
817         address owner = ERC721.ownerOf(tokenId);
818         require(to != owner, "ERC721: approval to current owner");
819 
820         require(
821             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
822             "ERC721: approve caller is not owner nor approved for all"
823         );
824 
825         _approve(to, tokenId);
826     }
827 
828     /**
829      * @dev See {IERC721-getApproved}.
830      */
831     function getApproved(uint256 tokenId)
832         public
833         view
834         virtual
835         override
836         returns (address)
837     {
838         require(
839             _exists(tokenId),
840             "ERC721: approved query for nonexistent token"
841         );
842 
843         return _tokenApprovals[tokenId];
844     }
845 
846     /**
847      * @dev See {IERC721-setApprovalForAll}.
848      */
849     function setApprovalForAll(address operator, bool approved)
850         public
851         virtual
852         override
853     {
854         require(operator != _msgSender(), "ERC721: approve to caller");
855 
856         _operatorApprovals[_msgSender()][operator] = approved;
857         emit ApprovalForAll(_msgSender(), operator, approved);
858     }
859 
860     /**
861      * @dev See {IERC721-isApprovedForAll}.
862      */
863     function isApprovedForAll(address owner, address operator)
864         public
865         view
866         virtual
867         override
868         returns (bool)
869     {
870         return _operatorApprovals[owner][operator];
871     }
872 
873     /**
874      * @dev See {IERC721-transferFrom}.
875      */
876     function transferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) public virtual override {
881         //solhint-disable-next-line max-line-length
882         require(
883             _isApprovedOrOwner(_msgSender(), tokenId),
884             "ERC721: transfer caller is not owner nor approved"
885         );
886 
887         _transfer(from, to, tokenId);
888     }
889 
890     /**
891      * @dev See {IERC721-safeTransferFrom}.
892      */
893     function safeTransferFrom(
894         address from,
895         address to,
896         uint256 tokenId
897     ) public virtual override {
898         safeTransferFrom(from, to, tokenId, "");
899     }
900 
901     /**
902      * @dev See {IERC721-safeTransferFrom}.
903      */
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId,
908         bytes memory _data
909     ) public virtual override {
910         require(
911             _isApprovedOrOwner(_msgSender(), tokenId),
912             "ERC721: transfer caller is not owner nor approved"
913         );
914         _safeTransfer(from, to, tokenId, _data);
915     }
916 
917     /**
918      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
919      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
920      *
921      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
922      *
923      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
924      * implement alternative mechanisms to perform token transfer, such as signature-based.
925      *
926      * Requirements:
927      *
928      * - `from` cannot be the zero address.
929      * - `to` cannot be the zero address.
930      * - `tokenId` token must exist and be owned by `from`.
931      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
932      *
933      * Emits a {Transfer} event.
934      */
935     function _safeTransfer(
936         address from,
937         address to,
938         uint256 tokenId,
939         bytes memory _data
940     ) internal virtual {
941         _transfer(from, to, tokenId);
942         require(
943             _checkOnERC721Received(from, to, tokenId, _data),
944             "ERC721: transfer to non ERC721Receiver implementer"
945         );
946     }
947 
948     /**
949      * @dev Returns whether `tokenId` exists.
950      *
951      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
952      *
953      * Tokens start existing when they are minted (`_mint`),
954      * and stop existing when they are burned (`_burn`).
955      */
956     function _exists(uint256 tokenId) internal view virtual returns (bool) {
957         return _owners[tokenId] != address(0);
958     }
959 
960     /**
961      * @dev Returns whether `spender` is allowed to manage `tokenId`.
962      *
963      * Requirements:
964      *
965      * - `tokenId` must exist.
966      */
967     function _isApprovedOrOwner(address spender, uint256 tokenId)
968         internal
969         view
970         virtual
971         returns (bool)
972     {
973         require(
974             _exists(tokenId),
975             "ERC721: operator query for nonexistent token"
976         );
977         address owner = ERC721.ownerOf(tokenId);
978         return (spender == owner ||
979             getApproved(tokenId) == spender ||
980             isApprovedForAll(owner, spender));
981     }
982 
983     /**
984      * @dev Safely mints `tokenId` and transfers it to `to`.
985      *
986      * Requirements:
987      *
988      * - `tokenId` must not exist.
989      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _safeMint(address to, uint256 tokenId) internal virtual {
994         _safeMint(to, tokenId, "");
995     }
996 
997     /**
998      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
999      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1000      */
1001     function _safeMint(
1002         address to,
1003         uint256 tokenId,
1004         bytes memory _data
1005     ) internal virtual {
1006         _mint(to, tokenId);
1007         require(
1008             _checkOnERC721Received(address(0), to, tokenId, _data),
1009             "ERC721: transfer to non ERC721Receiver implementer"
1010         );
1011     }
1012 
1013     /**
1014      * @dev Mints `tokenId` and transfers it to `to`.
1015      *
1016      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1017      *
1018      * Requirements:
1019      *
1020      * - `tokenId` must not exist.
1021      * - `to` cannot be the zero address.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _mint(address to, uint256 tokenId) internal virtual {
1026         require(to != address(0), "ERC721: mint to the zero address");
1027         require(!_exists(tokenId), "ERC721: token already minted");
1028 
1029         _beforeTokenTransfer(address(0), to, tokenId);
1030 
1031         _balances[to] += 1;
1032         _owners[tokenId] = to;
1033 
1034         emit Transfer(address(0), to, tokenId);
1035     }
1036 
1037     /**
1038      * @dev Destroys `tokenId`.
1039      * The approval is cleared when the token is burned.
1040      *
1041      * Requirements:
1042      *
1043      * - `tokenId` must exist.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function _burn(uint256 tokenId) internal virtual {
1048         address owner = ERC721.ownerOf(tokenId);
1049 
1050         _beforeTokenTransfer(owner, address(0), tokenId);
1051 
1052         // Clear approvals
1053         _approve(address(0), tokenId);
1054 
1055         _balances[owner] -= 1;
1056         delete _owners[tokenId];
1057 
1058         emit Transfer(owner, address(0), tokenId);
1059     }
1060 
1061     /**
1062      * @dev Transfers `tokenId` from `from` to `to`.
1063      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1064      *
1065      * Requirements:
1066      *
1067      * - `to` cannot be the zero address.
1068      * - `tokenId` token must be owned by `from`.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _transfer(
1073         address from,
1074         address to,
1075         uint256 tokenId
1076     ) internal virtual {
1077         require(
1078             ERC721.ownerOf(tokenId) == from,
1079             "ERC721: transfer of token that is not own"
1080         );
1081         require(to != address(0), "ERC721: transfer to the zero address");
1082 
1083         _beforeTokenTransfer(from, to, tokenId);
1084 
1085         // Clear approvals from the previous owner
1086         _approve(address(0), tokenId);
1087 
1088         _balances[from] -= 1;
1089         _balances[to] += 1;
1090         _owners[tokenId] = to;
1091 
1092         emit Transfer(from, to, tokenId);
1093     }
1094 
1095     /**
1096      * @dev Approve `to` to operate on `tokenId`
1097      *
1098      * Emits a {Approval} event.
1099      */
1100     function _approve(address to, uint256 tokenId) internal virtual {
1101         _tokenApprovals[tokenId] = to;
1102         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1103     }
1104 
1105     /**
1106      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1107      * The call is not executed if the target address is not a contract.
1108      *
1109      * @param from address representing the previous owner of the given token ID
1110      * @param to target address that will receive the tokens
1111      * @param tokenId uint256 ID of the token to be transferred
1112      * @param _data bytes optional data to send along with the call
1113      * @return bool whether the call correctly returned the expected magic value
1114      */
1115     function _checkOnERC721Received(
1116         address from,
1117         address to,
1118         uint256 tokenId,
1119         bytes memory _data
1120     ) private returns (bool) {
1121         if (to.isContract()) {
1122             try
1123                 IERC721Receiver(to).onERC721Received(
1124                     _msgSender(),
1125                     from,
1126                     tokenId,
1127                     _data
1128                 )
1129             returns (bytes4 retval) {
1130                 return retval == IERC721Receiver.onERC721Received.selector;
1131             } catch (bytes memory reason) {
1132                 if (reason.length == 0) {
1133                     revert(
1134                         "ERC721: transfer to non ERC721Receiver implementer"
1135                     );
1136                 } else {
1137                     assembly {
1138                         revert(add(32, reason), mload(reason))
1139                     }
1140                 }
1141             }
1142         } else {
1143             return true;
1144         }
1145     }
1146 
1147     /**
1148      * @dev Hook that is called before any token transfer. This includes minting
1149      * and burning.
1150      *
1151      * Calling conditions:
1152      *
1153      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1154      * transferred to `to`.
1155      * - When `from` is zero, `tokenId` will be minted for `to`.
1156      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1157      * - `from` and `to` are never both zero.
1158      *
1159      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1160      */
1161     function _beforeTokenTransfer(
1162         address from,
1163         address to,
1164         uint256 tokenId
1165     ) internal virtual {}
1166 }
1167 
1168 pragma solidity ^0.8.0;
1169 
1170 contract CryptoTribe is Ownable, ERC721 {
1171     using Strings for uint256;
1172     string public baseExtension = ".json";
1173     // presale cost
1174     uint256 public preSaleCost = 0.07 ether;
1175     // public cost
1176     uint256 public publicCost = 0.1 ether;
1177     // max nft minted by address for presale
1178     uint256 public nftPerAddressLimitPresale = 9;
1179     // max nft minted by address for presale DC
1180     uint256 public nftPerAddressLimitPresaleDC = 9;
1181     // max nft minted by address for presale alpha
1182     uint256 public nftPerAddressLimitPresaleAlpha = 9;
1183     // max mint amount per transaction for presale
1184     uint256 public maxMintAmountPresale = 3;
1185     // max mint amount per transaction for presale DC
1186     uint256 public maxMintAmountPresaleDC = 5;
1187     // max mint amount per transaction for presale alpha
1188     uint256 public maxMintAmountPresaleAlpha = 8;
1189     // max nft minted by address for public
1190     uint256 public nftPerAddressLimitPublic = 9;
1191     // max mint amount per transaction for public
1192     uint256 public maxMintAmountPublic = 5;
1193     // max supply
1194     uint256 constant maxSupply = 7070;
1195     uint256 public presaleMaxSupply = 1500;
1196     // total supply
1197     uint256 public totalSupply = 0;
1198     bool public public_sale_status = false;
1199     bool public pre_sale_status = false;
1200     string public baseURI;
1201     mapping(address => bool) whitelistedAddresses;
1202     mapping(address => bool) DCWhitelistedAddresses;
1203     mapping(address => bool) alphaWhitelistedAddresses;
1204     mapping(address => uint256) public addressMintedBalance;
1205 
1206     constructor() ERC721("Crypto Tribe", "TRB") {}
1207 
1208     function buy(uint256 _count) public payable {
1209         require(public_sale_status == true, "Sale is Paused.");
1210         require(_count > 0, "mint at least one token");
1211         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1212         require(
1213             ownerMintedCount + _count <= nftPerAddressLimitPublic,
1214             "max NFT per address exceeded"
1215         );
1216         require(
1217             _count <= maxMintAmountPublic,
1218             "max mint amount per transaction exceeded"
1219         );
1220         require(totalSupply + _count <= maxSupply, "Not enough tokens left");
1221         require(msg.value >= publicCost * _count, "incorrect ether amount");
1222         for (uint256 i = 0; i < _count; i++)
1223             _safeMint(msg.sender, totalSupply + 1 + i);
1224         addressMintedBalance[msg.sender] += _count;
1225         totalSupply += _count;
1226     }
1227 
1228     function presale(uint256 _count) public payable {
1229         require(pre_sale_status == true, "Sale is Paused.");
1230         require(_count > 0, "mint at least one token");
1231         bool isWhitelist = isWhitelisted(msg.sender);
1232         bool isDCWhitelist = isDCWhitelisted(msg.sender);
1233         bool isAlphaWhitelist = isAlphaWhitelisted(msg.sender);
1234         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1235         require(
1236             isWhitelist || isDCWhitelist || isAlphaWhitelist,
1237             "user is not whitelisted"
1238         );
1239         require(
1240             isAlphaWhitelist
1241                 ? ownerMintedCount + _count <= nftPerAddressLimitPresaleAlpha
1242                 : isDCWhitelist
1243                 ? ownerMintedCount + _count <= nftPerAddressLimitPresaleDC
1244                 : ownerMintedCount + _count <= nftPerAddressLimitPresale,
1245             "max NFT per address exceeded for presale"
1246         );
1247         require(
1248             isAlphaWhitelist
1249                 ? _count <= maxMintAmountPresaleAlpha
1250                 : isDCWhitelist
1251                 ? _count <= maxMintAmountPresaleDC
1252                 : _count <= maxMintAmountPresale,
1253             "max mint amount per transaction exceeded"
1254         );
1255         require(
1256             totalSupply + _count <= presaleMaxSupply,
1257             "Not enough tokens left"
1258         );
1259         require(totalSupply + _count <= maxSupply, "Not enough tokens left");
1260         require(msg.value >= preSaleCost * _count, "incorrect ether amount");
1261         for (uint256 i = 0; i < _count; i++)
1262             _safeMint(msg.sender, totalSupply + 1 + i);
1263         addressMintedBalance[msg.sender] = ownerMintedCount + _count;
1264         totalSupply += _count;
1265     }
1266 
1267     function sendGifts(address[] memory _wallets) public onlyOwner {
1268         require(
1269             totalSupply + _wallets.length <= maxSupply,
1270             "not enough tokens left"
1271         );
1272         for (uint256 i = 0; i < _wallets.length; i++) {
1273             _safeMint(_wallets[i], totalSupply + 1 + i);
1274         }
1275         totalSupply += _wallets.length;
1276     }
1277 
1278     function gift(uint256 _mintAmount, address destination) public onlyOwner {
1279         require(_mintAmount > 0, "need to mint at least 1 NFT");
1280         require(
1281             totalSupply + _mintAmount <= maxSupply,
1282             "max NFT limit exceeded"
1283         );
1284 
1285         for (uint256 i = 0; i < _mintAmount; i++) {
1286             _safeMint(destination, totalSupply + 1 + i);
1287         }
1288         totalSupply += _mintAmount;
1289     }
1290 
1291     function setPresaleCost(uint256 temp) external onlyOwner {
1292         preSaleCost = temp;
1293     }
1294 
1295     function setPublicCost(uint256 temp) external onlyOwner {
1296         publicCost = temp;
1297     }
1298 
1299     function setBaseUri(string memory _uri) external onlyOwner {
1300         baseURI = _uri;
1301     }
1302 
1303     function publicSale_status(bool temp) external onlyOwner {
1304         public_sale_status = temp;
1305     }
1306 
1307     function preSale_status(bool temp) external onlyOwner {
1308         pre_sale_status = temp;
1309     }
1310 
1311     function Update_preSale_max_supply(uint256 temp) external onlyOwner {
1312         presaleMaxSupply = temp;
1313     }
1314 
1315     function _baseURI() internal view virtual override returns (string memory) {
1316         return baseURI;
1317     }
1318 
1319     function whitelistUsers(address[] memory addresses) public onlyOwner {
1320         for (uint256 i = 0; i < addresses.length; i++) {
1321             whitelistedAddresses[addresses[i]] = true;
1322         }
1323     }
1324 
1325     function whitelistDCUsers(address[] memory addresses) public onlyOwner {
1326         for (uint256 i = 0; i < addresses.length; i++) {
1327             DCWhitelistedAddresses[addresses[i]] = true;
1328         }
1329     }
1330 
1331     function whitelistAlphaUsers(address[] memory addresses) public onlyOwner {
1332         for (uint256 i = 0; i < addresses.length; i++) {
1333             alphaWhitelistedAddresses[addresses[i]] = true;
1334         }
1335     }
1336 
1337     function removeWhitelistUsers(address[] memory addresses) public onlyOwner {
1338         for (uint256 i = 0; i < addresses.length; i++) {
1339             whitelistedAddresses[addresses[i]] = false;
1340         }
1341     }
1342 
1343     function removeWhitelistDCUsers(address[] memory addresses)
1344         public
1345         onlyOwner
1346     {
1347         for (uint256 i = 0; i < addresses.length; i++) {
1348             DCWhitelistedAddresses[addresses[i]] = false;
1349         }
1350     }
1351 
1352     function removeAlphaWhitelistUsers(address[] memory addresses)
1353         public
1354         onlyOwner
1355     {
1356         for (uint256 i = 0; i < addresses.length; i++) {
1357             alphaWhitelistedAddresses[addresses[i]] = false;
1358         }
1359     }
1360 
1361     function setmaxMintAmountPreSale(uint256 _newmaxMintAmount)
1362         public
1363         onlyOwner
1364     {
1365         maxMintAmountPresale = _newmaxMintAmount;
1366     }
1367 
1368     function setmaxMintAmountPreSaleDC(uint256 _newmaxMintAmount)
1369         public
1370         onlyOwner
1371     {
1372         maxMintAmountPresaleDC = _newmaxMintAmount;
1373     }
1374 
1375     function setmaxMintAmountPreSaleAlpha(uint256 _newmaxMintAmount)
1376         public
1377         onlyOwner
1378     {
1379         maxMintAmountPresaleAlpha = _newmaxMintAmount;
1380     }
1381 
1382     function setNftPerAddressLimitPreSale(uint256 _limit) public onlyOwner {
1383         nftPerAddressLimitPresale = _limit;
1384     }
1385 
1386     function setNftPerAddressLimitPreSaleDC(uint256 _limit) public onlyOwner {
1387         nftPerAddressLimitPresaleDC = _limit;
1388     }
1389 
1390     function setNftPerAddressLimitPreSaleAlpha(uint256 _limit)
1391         public
1392         onlyOwner
1393     {
1394         nftPerAddressLimitPresaleAlpha = _limit;
1395     }
1396 
1397     function setNftPerAddressLimitPublic(uint256 _limit) public onlyOwner {
1398         nftPerAddressLimitPublic = _limit;
1399     }
1400 
1401     function setMaxMintAmountPublic(uint256 _newmaxMintAmount)
1402         public
1403         onlyOwner
1404     {
1405         maxMintAmountPublic = _newmaxMintAmount;
1406     }
1407 
1408     function setBaseExtension(string memory _newBaseExtension)
1409         public
1410         onlyOwner
1411     {
1412         baseExtension = _newBaseExtension;
1413     }
1414 
1415     //PUBLIC VIEWS
1416     function isWhitelisted(address _user) public view returns (bool) {
1417         return whitelistedAddresses[_user];
1418     }
1419 
1420     function isDCWhitelisted(address _user) public view returns (bool) {
1421         return DCWhitelistedAddresses[_user];
1422     }
1423 
1424     function isAlphaWhitelisted(address _user) public view returns (bool) {
1425         return alphaWhitelistedAddresses[_user];
1426     }
1427 
1428     function tokenURI(uint256 tokenId)
1429         public
1430         view
1431         virtual
1432         override
1433         returns (string memory)
1434     {
1435         require(
1436             _exists(tokenId),
1437             "ERC721Metadata: URI query for nonexistent token"
1438         );
1439 
1440         string memory currentURI = _baseURI();
1441 
1442         return
1443             bytes(baseURI).length > 0
1444                 ? string(
1445                     abi.encodePacked(
1446                         currentURI,
1447                         tokenId.toString(),
1448                         baseExtension
1449                     )
1450                 )
1451                 : "";
1452     }
1453 
1454     function withdraw() external onlyOwner {
1455         uint256 _balance = address(this).balance;
1456         payable(0xB0766AA5DEfa703b6B1B2087837d4Edc46fCE0d4).transfer(_balance);
1457     }
1458 }