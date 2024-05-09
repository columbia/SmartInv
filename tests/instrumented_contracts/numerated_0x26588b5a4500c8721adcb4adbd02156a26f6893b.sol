1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 /// @title Viking
5 /// @author Viking
6 
7 pragma solidity ^0.8.9;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
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
74 
75 
76 pragma solidity ^0.8.9;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/access/Ownable.sol
99 
100 
101 
102 pragma solidity ^0.8.9;
103 
104 
105 /**
106  * @dev Contract module which provides a basic access control mechanism, where
107  * there is an account (an owner) that can be granted exclusive access to
108  * specific functions.
109  *
110  * By default, the owner account will be the one that deploys the contract. This
111  * can later be changed with {transferOwnership}.
112  *
113  * This module is used through inheritance. It will make available the modifier
114  * `onlyOwner`, which can be applied to your functions to restrict their use to
115  * the owner.
116  */
117 abstract contract Ownable is Context {
118     address private _owner;
119 
120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122     /**
123      * @dev Initializes the contract setting the deployer as the initial owner.
124      */
125     constructor() {
126         _setOwner(_msgSender());
127     }
128 
129     /**
130      * @dev Returns the address of the current owner.
131      */
132     function owner() public view virtual returns (address) {
133         return _owner;
134     }
135 
136     /**
137      * @dev Throws if called by any account other than the owner.
138      */
139     modifier onlyOwner() {
140         require(owner() == _msgSender(), "Ownable: caller is not the owner");
141         _;
142     }
143 
144     /**
145      * @dev Leaves the contract without owner. It will not be possible to call
146      * `onlyOwner` functions anymore. Can only be called by the current owner.
147      *
148      * NOTE: Renouncing ownership will leave the contract without an owner,
149      * thereby removing any functionality that is only available to the owner.
150      */
151     function renounceOwnership() public virtual onlyOwner {
152         _setOwner(address(0));
153     }
154 
155     /**
156      * @dev Transfers ownership of the contract to a new account (`newOwner`).
157      * Can only be called by the current owner.
158      */
159     function transferOwnership(address newOwner) public virtual onlyOwner {
160         require(newOwner != address(0), "Ownable: new owner is the zero address");
161         _setOwner(newOwner);
162     }
163 
164     function _setOwner(address newOwner) private {
165         address oldOwner = _owner;
166         _owner = newOwner;
167         emit OwnershipTransferred(oldOwner, newOwner);
168     }
169 }
170 
171 // File: @openzeppelin/contracts/utils/Address.sol
172 
173 
174 
175 pragma solidity ^0.8.9;
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
227         require(address(this).balance >= amount, "Address: insufficient balance");
228 
229         (bool success, ) = recipient.call{value: amount}("");
230         require(success, "Address: unable to send value, recipient may have reverted");
231     }
232 
233     /**
234      * @dev Performs a Solidity function call using a low level `call`. A
235      * plain `call` is an unsafe replacement for a function call: use this
236      * function instead.
237      *
238      * If `target` reverts with a revert reason, it is bubbled up by this
239      * function (like regular Solidity function calls).
240      *
241      * Returns the raw returned data. To convert to the expected return value,
242      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
243      *
244      * Requirements:
245      *
246      * - `target` must be a contract.
247      * - calling `target` with `data` must not revert.
248      *
249      * _Available since v3.1._
250      */
251     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
252         return functionCall(target, data, "Address: low-level call failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
257      * `errorMessage` as a fallback revert reason when `target` reverts.
258      *
259      * _Available since v3.1._
260      */
261     function functionCall(
262         address target,
263         bytes memory data,
264         string memory errorMessage
265     ) internal returns (bytes memory) {
266         return functionCallWithValue(target, data, 0, errorMessage);
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
271      * but also transferring `value` wei to `target`.
272      *
273      * Requirements:
274      *
275      * - the calling contract must have an ETH balance of at least `value`.
276      * - the called Solidity function must be `payable`.
277      *
278      * _Available since v3.1._
279      */
280     function functionCallWithValue(
281         address target,
282         bytes memory data,
283         uint256 value
284     ) internal returns (bytes memory) {
285         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
290      * with `errorMessage` as a fallback revert reason when `target` reverts.
291      *
292      * _Available since v3.1._
293      */
294     function functionCallWithValue(
295         address target,
296         bytes memory data,
297         uint256 value,
298         string memory errorMessage
299     ) internal returns (bytes memory) {
300         require(address(this).balance >= value, "Address: insufficient balance for call");
301         require(isContract(target), "Address: call to non-contract");
302 
303         (bool success, bytes memory returndata) = target.call{value: value}(data);
304         return verifyCallResult(success, returndata, errorMessage);
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
309      * but performing a static call.
310      *
311      * _Available since v3.3._
312      */
313     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
314         return functionStaticCall(target, data, "Address: low-level static call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
319      * but performing a static call.
320      *
321      * _Available since v3.3._
322      */
323     function functionStaticCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal view returns (bytes memory) {
328         require(isContract(target), "Address: static call to non-contract");
329 
330         (bool success, bytes memory returndata) = target.staticcall(data);
331         return verifyCallResult(success, returndata, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but performing a delegate call.
337      *
338      * _Available since v3.4._
339      */
340     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
341         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
346      * but performing a delegate call.
347      *
348      * _Available since v3.4._
349      */
350     function functionDelegateCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         require(isContract(target), "Address: delegate call to non-contract");
356 
357         (bool success, bytes memory returndata) = target.delegatecall(data);
358         return verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
363      * revert reason using the provided one.
364      *
365      * _Available since v4.3._
366      */
367     function verifyCallResult(
368         bool success,
369         bytes memory returndata,
370         string memory errorMessage
371     ) internal pure returns (bytes memory) {
372         if (success) {
373             return returndata;
374         } else {
375             // Look for revert reason and bubble it up if present
376             if (returndata.length > 0) {
377                 // The easiest way to bubble the revert reason is using memory via assembly
378 
379                 assembly {
380                     let returndata_size := mload(returndata)
381                     revert(add(32, returndata), returndata_size)
382                 }
383             } else {
384                 revert(errorMessage);
385             }
386         }
387     }
388 }
389 
390 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
391 
392 pragma solidity ^0.8.9;
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
421 pragma solidity ^0.8.9;
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
444 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
445 
446 
447 
448 pragma solidity ^0.8.9;
449 
450 
451 /**
452  * @dev Implementation of the {IERC165} interface.
453  *
454  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
455  * for the additional interface id that will be supported. For example:
456  *
457  * ```solidity
458  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
459  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
460  * }
461  * ```
462  *
463  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
464  */
465 abstract contract ERC165 is IERC165 {
466     /**
467      * @dev See {IERC165-supportsInterface}.
468      */
469     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
470         return interfaceId == type(IERC165).interfaceId;
471     }
472 }
473 
474 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
475 
476 
477 
478 pragma solidity ^0.8.9;
479 
480 
481 /**
482  * @dev Required interface of an ERC721 compliant contract.
483  */
484 interface IERC721 is IERC165 {
485     /**
486      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
487      */
488     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
489 
490     /**
491      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
492      */
493     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
494 
495     /**
496      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
497      */
498     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
499 
500     /**
501      * @dev Returns the number of tokens in ``owner``'s account.
502      */
503     function balanceOf(address owner) external view returns (uint256 balance);
504 
505     /**
506      * @dev Returns the owner of the `tokenId` token.
507      *
508      * Requirements:
509      *
510      * - `tokenId` must exist.
511      */
512     function ownerOf(uint256 tokenId) external view returns (address owner);
513 
514     /**
515      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
516      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
517      *
518      * Requirements:
519      *
520      * - `from` cannot be the zero address.
521      * - `to` cannot be the zero address.
522      * - `tokenId` token must exist and be owned by `from`.
523      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
524      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
525      *
526      * Emits a {Transfer} event.
527      */
528     function safeTransferFrom(
529         address from,
530         address to,
531         uint256 tokenId
532     ) external;
533 
534     /**
535      * @dev Transfers `tokenId` token from `from` to `to`.
536      *
537      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
538      *
539      * Requirements:
540      *
541      * - `from` cannot be the zero address.
542      * - `to` cannot be the zero address.
543      * - `tokenId` token must be owned by `from`.
544      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
545      *
546      * Emits a {Transfer} event.
547      */
548     function transferFrom(
549         address from,
550         address to,
551         uint256 tokenId
552     ) external;
553 
554     /**
555      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
556      * The approval is cleared when the token is transferred.
557      *
558      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
559      *
560      * Requirements:
561      *
562      * - The caller must own the token or be an approved operator.
563      * - `tokenId` must exist.
564      *
565      * Emits an {Approval} event.
566      */
567     function approve(address to, uint256 tokenId) external;
568 
569     /**
570      * @dev Returns the account approved for `tokenId` token.
571      *
572      * Requirements:
573      *
574      * - `tokenId` must exist.
575      */
576     function getApproved(uint256 tokenId) external view returns (address operator);
577 
578     /**
579      * @dev Approve or remove `operator` as an operator for the caller.
580      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
581      *
582      * Requirements:
583      *
584      * - The `operator` cannot be the caller.
585      *
586      * Emits an {ApprovalForAll} event.
587      */
588     function setApprovalForAll(address operator, bool _approved) external;
589 
590     /**
591      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
592      *
593      * See {setApprovalForAll}
594      */
595     function isApprovedForAll(address owner, address operator) external view returns (bool);
596 
597     /**
598      * @dev Safely transfers `tokenId` token from `from` to `to`.
599      *
600      * Requirements:
601      *
602      * - `from` cannot be the zero address.
603      * - `to` cannot be the zero address.
604      * - `tokenId` token must exist and be owned by `from`.
605      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
606      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
607      *
608      * Emits a {Transfer} event.
609      */
610     function safeTransferFrom(
611         address from,
612         address to,
613         uint256 tokenId,
614         bytes calldata data
615     ) external;
616 }
617 
618 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
619 
620 
621 
622 pragma solidity ^0.8.9;
623 
624 
625 /**
626  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
627  * @dev See https://eips.ethereum.org/EIPS/eip-721
628  */
629 interface IERC721Metadata is IERC721 {
630     /**
631      * @dev Returns the token collection name.
632      */
633     function name() external view returns (string memory);
634 
635     /**
636      * @dev Returns the token collection symbol.
637      */
638     function symbol() external view returns (string memory);
639 
640     /**
641      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
642      */
643     function tokenURI(uint256 tokenId) external view returns (string memory);
644 }
645 
646 
647 pragma solidity >=0.8.9;
648 // to enable certain compiler features
649 
650 
651 
652 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
653     using Address for address;
654     using Strings for uint256;
655 
656     // Token name
657     string private _name;
658 
659     // Token symbol
660     string private _symbol;
661 
662     // Mapping from token ID to owner address
663     mapping(uint256 => address) private _owners;
664 
665     // Mapping owner address to token count
666     mapping(address => uint256) private _balances;
667 
668     // Mapping from token ID to approved address
669     mapping(uint256 => address) private _tokenApprovals;
670 
671     // Mapping from owner to operator approvals
672     mapping(address => mapping(address => bool)) private _operatorApprovals;
673     
674     //Mapping para atribuirle un URI para cada token
675     mapping(uint256 => string) internal id_to_URI;
676 
677     /**
678      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
679      */
680     constructor(string memory name_, string memory symbol_) {
681         _name = name_;
682         _symbol = symbol_;
683     }
684 
685     /**
686      * @dev See {IERC165-supportsInterface}.
687      */
688     
689     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
690         return
691             interfaceId == type(IERC721).interfaceId ||
692             interfaceId == type(IERC721Metadata).interfaceId ||
693             super.supportsInterface(interfaceId);
694     }
695     
696 
697     /**
698      * @dev See {IERC721-balanceOf}.
699      */
700     function balanceOf(address owner) public view virtual override returns (uint256) {
701         require(owner != address(0), "ERC721: balance query for the zero address");
702         return _balances[owner];
703     }
704 
705     /**
706      * @dev See {IERC721-ownerOf}.
707      */
708     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
709         address owner = _owners[tokenId];
710         require(owner != address(0), "ERC721: owner query for nonexistent token");
711         return owner;
712     }
713 
714     /**
715      * @dev See {IERC721Metadata-name}.
716      */
717     function name() public view virtual override returns (string memory) {
718         return _name;
719     }
720 
721     /**
722      * @dev See {IERC721Metadata-symbol}.
723      */
724     function symbol() public view virtual override returns (string memory) {
725         return _symbol;
726     }
727 
728     /**
729      * @dev See {IERC721Metadata-tokenURI}.
730      */
731     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {  }
732 
733     /**
734      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
735      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
736      * by default, can be overriden in child contracts.
737      */
738     function _baseURI() internal view virtual returns (string memory) {
739         return "";
740     }
741 
742     /**
743      * @dev See {IERC721-approve}.
744      */
745     function approve(address to, uint256 tokenId) public virtual override {
746         address owner = ERC721.ownerOf(tokenId);
747         require(to != owner, "ERC721: approval to current owner");
748 
749         require(
750             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
751             "ERC721: approve caller is not owner nor approved for all"
752         );
753 
754         _approve(to, tokenId);
755     }
756 
757     /**
758      * @dev See {IERC721-getApproved}.
759      */
760     function getApproved(uint256 tokenId) public view virtual override returns (address) {
761         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
762 
763         return _tokenApprovals[tokenId];
764     }
765 
766     /**
767      * @dev See {IERC721-setApprovalForAll}.
768      */
769     function setApprovalForAll(address operator, bool approved) public virtual override {
770         require(operator != _msgSender(), "ERC721: approve to caller");
771 
772         _operatorApprovals[_msgSender()][operator] = approved;
773         emit ApprovalForAll(_msgSender(), operator, approved);
774     }
775 
776     /**
777      * @dev See {IERC721-isApprovedForAll}.
778      */
779     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
780         return _operatorApprovals[owner][operator];
781     }
782 
783     /**
784      * @dev See {IERC721-transferFrom}.
785      */
786     function transferFrom(
787         address from,
788         address to,
789         uint256 tokenId
790     ) public virtual override {
791         //solhint-disable-next-line max-line-length
792         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
793 
794         _transfer(from, to, tokenId);
795     }
796 
797     /**
798      * @dev See {IERC721-safeTransferFrom}.
799      */
800     function safeTransferFrom(
801         address from,
802         address to,
803         uint256 tokenId
804     ) public virtual override {
805         safeTransferFrom(from, to, tokenId, "");
806     }
807 
808     /**
809      * @dev See {IERC721-safeTransferFrom}.
810      */
811     function safeTransferFrom(
812         address from,
813         address to,
814         uint256 tokenId,
815         bytes memory _data
816     ) public virtual override {
817         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
818         _safeTransfer(from, to, tokenId, _data);
819     }
820 
821     /**
822      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
823      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
824      *
825      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
826      *
827      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
828      * implement alternative mechanisms to perform token transfer, such as signature-based.
829      *
830      * Requirements:
831      *
832      * - `from` cannot be the zero address.
833      * - `to` cannot be the zero address.
834      * - `tokenId` token must exist and be owned by `from`.
835      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
836      *
837      * Emits a {Transfer} event.
838      */
839     function _safeTransfer(
840         address from,
841         address to,
842         uint256 tokenId,
843         bytes memory _data
844     ) internal virtual {
845         _transfer(from, to, tokenId);
846         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
847     }
848 
849     /**
850      * @dev Returns whether `tokenId` exists.
851      *
852      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
853      *
854      * Tokens start existing when they are minted (`_mint`),
855      * and stop existing when they are burned (`_burn`).
856      */
857     function _exists(uint256 tokenId) internal view virtual returns (bool) {
858         return _owners[tokenId] != address(0);
859     }
860 
861     /**
862      * @dev Returns whether `spender` is allowed to manage `tokenId`.
863      *
864      * Requirements:
865      *
866      * - `tokenId` must exist.
867      */
868     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
869         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
870         address owner = ERC721.ownerOf(tokenId);
871         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
872     }
873 
874     /**
875      * @dev Safely mints `tokenId` and transfers it to `to`.
876      *
877      * Requirements:
878      *
879      * - `tokenId` must not exist.
880      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _safeMint(address to, uint256 tokenId) internal virtual {
885         _safeMint(to, tokenId, "");
886     }
887 
888     /**
889      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
890      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
891      */
892     function _safeMint(
893         address to,
894         uint256 tokenId,
895         bytes memory _data
896     ) internal virtual {
897         _mint(to, tokenId);
898         require(
899             _checkOnERC721Received(address(0), to, tokenId, _data),
900             "ERC721: transfer to non ERC721Receiver implementer"
901         );
902     }
903 
904     /**
905      * @dev Mints `tokenId` and transfers it to `to`.
906      *
907      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
908      *
909      * Requirements:
910      *
911      * - `tokenId` must not exist.
912      * - `to` cannot be the zero address.
913      *
914      * Emits a {Transfer} event.
915      */
916     function _mint(address to, uint256 tokenId) internal virtual {
917         require(to != address(0), "ERC721: mint to the zero address");
918         require(!_exists(tokenId), "ERC721: token already minted");
919 
920         _beforeTokenTransfer(address(0), to, tokenId);
921 
922         _balances[to] += 1;
923         _owners[tokenId] = to;
924 
925         emit Transfer(address(0), to, tokenId);
926     }
927 
928     /**
929      * @dev Destroys `tokenId`.
930      * The approval is cleared when the token is burned.
931      *
932      * Requirements:
933      *
934      * - `tokenId` must exist.
935      *
936      * Emits a {Transfer} event.
937      */
938     function _burn(uint256 tokenId) internal virtual {
939         address owner = ERC721.ownerOf(tokenId);
940 
941         _beforeTokenTransfer(owner, address(0), tokenId);
942 
943         // Clear approvals
944         _approve(address(0), tokenId);
945 
946         _balances[owner] -= 1;
947         delete _owners[tokenId];
948 
949         emit Transfer(owner, address(0), tokenId);
950     }
951 
952     /**
953      * @dev Transfers `tokenId` from `from` to `to`.
954      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
955      *
956      * Requirements:
957      *
958      * - `to` cannot be the zero address.
959      * - `tokenId` token must be owned by `from`.
960      *
961      * Emits a {Transfer} event.
962      */
963     function _transfer(
964         address from,
965         address to,
966         uint256 tokenId
967     ) internal virtual {
968         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
969         require(to != address(0), "ERC721: transfer to the zero address");
970 
971         _beforeTokenTransfer(from, to, tokenId);
972 
973         // Clear approvals from the previous owner
974         _approve(address(0), tokenId);
975 
976         _balances[from] -= 1;
977         _balances[to] += 1;
978         _owners[tokenId] = to;
979 
980         emit Transfer(from, to, tokenId);
981     }
982 
983     /**
984      * @dev Approve `to` to operate on `tokenId`
985      *
986      * Emits a {Approval} event.
987      */
988     function _approve(address to, uint256 tokenId) internal virtual {
989         _tokenApprovals[tokenId] = to;
990         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
991     }
992 
993     /**
994      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
995      * The call is not executed if the target address is not a contract.
996      *
997      * @param from address representing the previous owner of the given token ID
998      * @param to target address that will receive the tokens
999      * @param tokenId uint256 ID of the token to be transferred
1000      * @param _data bytes optional data to send along with the call
1001      * @return bool whether the call correctly returned the expected magic value
1002      */
1003     function _checkOnERC721Received(
1004         address from,
1005         address to,
1006         uint256 tokenId,
1007         bytes memory _data
1008     ) private returns (bool) {
1009         if (to.isContract()) {
1010             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1011                 return retval == IERC721Receiver.onERC721Received.selector;
1012             } catch (bytes memory reason) {
1013                 if (reason.length == 0) {
1014                     revert("ERC721: transfer to non ERC721Receiver implementer");
1015                 } else {
1016                     assembly {
1017                         revert(add(32, reason), mload(reason))
1018                     }
1019                 }
1020             }
1021         } else {
1022             return true;
1023         }
1024     }
1025 
1026     /**
1027      * @dev Hook that is called before any token transfer. This includes minting
1028      * and burning.
1029      *
1030      * Calling conditions:
1031      *
1032      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1033      * transferred to `to`.
1034      * - When `from` is zero, `tokenId` will be minted for `to`.
1035      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1036      * - `from` and `to` are never both zero.
1037      *
1038      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1039      */
1040     function _beforeTokenTransfer(
1041         address from,
1042         address to,
1043         uint256 tokenId
1044     ) internal virtual {}
1045 }
1046 
1047 pragma solidity ^0.8.9;
1048 
1049 /**
1050  * @dev Contract module that helps prevent reentrant calls to a function.
1051  *
1052  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1053  * available, which can be applied to functions to make sure there are no nested
1054  * (reentrant) calls to them.
1055  *
1056  * Note that because there is a single `nonReentrant` guard, functions marked as
1057  * `nonReentrant` may not call one another. This can be worked around by making
1058  * those functions `private`, and then adding `external` `nonReentrant` entry
1059  * points to them.
1060  *
1061  * TIP: If you would like to learn more about reentrancy and alternative ways
1062  * to protect against it, check out our blog post
1063  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1064  */
1065 abstract contract ReentrancyGuard {
1066     // Booleans are more expensive than uint256 or any type that takes up a full
1067     // word because each write operation emits an extra SLOAD to first read the
1068     // slot's contents, replace the bits taken up by the boolean, and then write
1069     // back. This is the compiler's defense against contract upgrades and
1070     // pointer aliasing, and it cannot be disabled.
1071 
1072     // The values being non-zero value makes deployment a bit more expensive,
1073     // but in exchange the refund on every call to nonReentrant will be lower in
1074     // amount. Since refunds are capped to a percentage of the total
1075     // transaction's gas, it is best to keep them low in cases like this one, to
1076     // increase the likelihood of the full refund coming into effect.
1077     uint256 private constant _NOT_ENTERED = 1;
1078     uint256 private constant _ENTERED = 2;
1079 
1080     uint256 private _status;
1081 
1082     constructor() {
1083         _status = _NOT_ENTERED;
1084     }
1085 
1086     /**
1087      * @dev Prevents a contract from calling itself, directly or indirectly.
1088      * Calling a `nonReentrant` function from another `nonReentrant`
1089      * function is not supported. It is possible to prevent this from happening
1090      * by making the `nonReentrant` function external, and making it call a
1091      * `private` function that does the actual work.
1092      */
1093     modifier nonReentrant() {
1094         // On the first call to nonReentrant, _notEntered will be true
1095         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1096 
1097         // Any calls to nonReentrant after this point will fail
1098         _status = _ENTERED;
1099 
1100         _;
1101 
1102         // By storing the original value once again, a refund is triggered (see
1103         // https://eips.ethereum.org/EIPS/eip-2200)
1104         _status = _NOT_ENTERED;
1105     }
1106 }
1107 
1108 
1109 pragma solidity ^0.8.9;
1110 
1111 /**
1112  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1113  * @dev See https://eips.ethereum.org/EIPS/eip-721
1114  */
1115 interface IERC721Enumerable is IERC721 {
1116     /**
1117      * @dev Returns the total amount of tokens stored by the contract.
1118      */
1119     function totalSupply() external view returns (uint256);
1120 
1121     /**
1122      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1123      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1124      */
1125     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1126 
1127     /**
1128      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1129      * Use along with {totalSupply} to enumerate all tokens.
1130      */
1131     function tokenByIndex(uint256 index) external view returns (uint256);
1132 }
1133 
1134 
1135 // Creator: Chiru Labs
1136 
1137 pragma solidity ^0.8.9;
1138 
1139 /**
1140  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1141  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1142  *
1143  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1144  *
1145  * Does not support burning tokens to address(0).
1146  *
1147  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
1148  */
1149 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1150     using Address for address;
1151     using Strings for uint256;
1152 
1153     struct TokenOwnership {
1154         address addr;
1155         uint64 startTimestamp;
1156     }
1157 
1158     struct AddressData {
1159         uint128 balance;
1160         uint128 numberMinted;
1161     }
1162 
1163     uint256 internal currentIndex;
1164 
1165     // Token name
1166     string private _name;
1167 
1168     // Token symbol
1169     string private _symbol;
1170 
1171     // Mapping from token ID to ownership details
1172     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1173     mapping(uint256 => TokenOwnership) internal _ownerships;
1174 
1175     // Mapping owner address to address data
1176     mapping(address => AddressData) private _addressData;
1177 
1178     // Mapping from token ID to approved address
1179     mapping(uint256 => address) private _tokenApprovals;
1180 
1181     // Mapping from owner to operator approvals
1182     mapping(address => mapping(address => bool)) private _operatorApprovals;
1183 
1184     constructor(string memory name_, string memory symbol_) {
1185         _name = name_;
1186         _symbol = symbol_;
1187     }
1188 
1189     /**
1190      * @dev See {IERC721Enumerable-totalSupply}.
1191      */
1192     function totalSupply() public view virtual override returns (uint256) {
1193         return currentIndex;
1194     }
1195 
1196     /**
1197      * @dev See {IERC721Enumerable-tokenByIndex}.
1198      */
1199     function tokenByIndex(uint256 index) public view override returns (uint256) {
1200         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1201         return index;
1202     }
1203 
1204     /**
1205      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1206      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1207      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1208      */
1209     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1210         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1211         uint256 numMintedSoFar = totalSupply();
1212         uint256 tokenIdsIdx;
1213         address currOwnershipAddr;
1214 
1215         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1216         unchecked {
1217             for (uint256 i; i < numMintedSoFar; i++) {
1218                 TokenOwnership memory ownership = _ownerships[i];
1219                 if (ownership.addr != address(0)) {
1220                     currOwnershipAddr = ownership.addr;
1221                 }
1222                 if (currOwnershipAddr == owner) {
1223                     if (tokenIdsIdx == index) {
1224                         return i;
1225                     }
1226                     tokenIdsIdx++;
1227                 }
1228             }
1229         }
1230 
1231         revert('ERC721A: unable to get token of owner by index');
1232     }
1233 
1234     /**
1235      * @dev See {IERC165-supportsInterface}.
1236      */
1237     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1238         return
1239             interfaceId == type(IERC721).interfaceId ||
1240             interfaceId == type(IERC721Metadata).interfaceId ||
1241             interfaceId == type(IERC721Enumerable).interfaceId ||
1242             super.supportsInterface(interfaceId);
1243     }
1244 
1245     /**
1246      * @dev See {IERC721-balanceOf}.
1247      */
1248     function balanceOf(address owner) public view override returns (uint256) {
1249         require(owner != address(0), 'ERC721A: balance query for the zero address');
1250         return uint256(_addressData[owner].balance);
1251     }
1252 
1253     function _numberMinted(address owner) internal view returns (uint256) {
1254         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1255         return uint256(_addressData[owner].numberMinted);
1256     }
1257 
1258     /**
1259      * Gas spent here starts off proportional to the maximum mint batch size.
1260      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1261      */
1262     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1263         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1264 
1265         unchecked {
1266             for (uint256 curr = tokenId; curr >= 0; curr--) {
1267                 TokenOwnership memory ownership = _ownerships[curr];
1268                 if (ownership.addr != address(0)) {
1269                     return ownership;
1270                 }
1271             }
1272         }
1273 
1274         revert('ERC721A: unable to determine the owner of token');
1275     }
1276 
1277     /**
1278      * @dev See {IERC721-ownerOf}.
1279      */
1280     function ownerOf(uint256 tokenId) public view override returns (address) {
1281         return ownershipOf(tokenId).addr;
1282     }
1283 
1284     /**
1285      * @dev See {IERC721Metadata-name}.
1286      */
1287     function name() public view virtual override returns (string memory) {
1288         return _name;
1289     }
1290 
1291     /**
1292      * @dev See {IERC721Metadata-symbol}.
1293      */
1294     function symbol() public view virtual override returns (string memory) {
1295         return _symbol;
1296     }
1297 
1298     /**
1299      * @dev See {IERC721Metadata-tokenURI}.
1300      */
1301     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1302         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1303 
1304         string memory baseURI = _baseURI();
1305         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1306     }
1307 
1308     /**
1309      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1310      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1311      * by default, can be overriden in child contracts.
1312      */
1313     function _baseURI() internal view virtual returns (string memory) {
1314         return '';
1315     }
1316 
1317     /**
1318      * @dev See {IERC721-approve}.
1319      */
1320     function approve(address to, uint256 tokenId) public override {
1321         address owner = ERC721A.ownerOf(tokenId);
1322         require(to != owner, 'ERC721A: approval to current owner');
1323 
1324         require(
1325             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1326             'ERC721A: approve caller is not owner nor approved for all'
1327         );
1328 
1329         _approve(to, tokenId, owner);
1330     }
1331 
1332     /**
1333      * @dev See {IERC721-getApproved}.
1334      */
1335     function getApproved(uint256 tokenId) public view override returns (address) {
1336         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1337 
1338         return _tokenApprovals[tokenId];
1339     }
1340 
1341     /**
1342      * @dev See {IERC721-setApprovalForAll}.
1343      */
1344     function setApprovalForAll(address operator, bool approved) public override {
1345         require(operator != _msgSender(), 'ERC721A: approve to caller');
1346 
1347         _operatorApprovals[_msgSender()][operator] = approved;
1348         emit ApprovalForAll(_msgSender(), operator, approved);
1349     }
1350 
1351     /**
1352      * @dev See {IERC721-isApprovedForAll}.
1353      */
1354     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1355         return _operatorApprovals[owner][operator];
1356     }
1357 
1358     /**
1359      * @dev See {IERC721-transferFrom}.
1360      */
1361     function transferFrom(
1362         address from,
1363         address to,
1364         uint256 tokenId
1365     ) public virtual override {
1366         _transfer(from, to, tokenId);
1367     }
1368 
1369     /**
1370      * @dev See {IERC721-safeTransferFrom}.
1371      */
1372     function safeTransferFrom(
1373         address from,
1374         address to,
1375         uint256 tokenId
1376     ) public virtual override {
1377         safeTransferFrom(from, to, tokenId, '');
1378     }
1379 
1380     /**
1381      * @dev See {IERC721-safeTransferFrom}.
1382      */
1383     function safeTransferFrom(
1384         address from,
1385         address to,
1386         uint256 tokenId,
1387         bytes memory _data
1388     ) public override {
1389         _transfer(from, to, tokenId);
1390         require(
1391             _checkOnERC721Received(from, to, tokenId, _data),
1392             'ERC721A: transfer to non ERC721Receiver implementer'
1393         );
1394     }
1395 
1396     /**
1397      * @dev Returns whether `tokenId` exists.
1398      *
1399      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1400      *
1401      * Tokens start existing when they are minted (`_mint`),
1402      */
1403     function _exists(uint256 tokenId) internal view returns (bool) {
1404         return tokenId < currentIndex;
1405     }
1406 
1407     function _safeMint(address to, uint256 quantity) internal {
1408         _safeMint(to, quantity, '');
1409     }
1410 
1411     /**
1412      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1413      *
1414      * Requirements:
1415      *
1416      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1417      * - `quantity` must be greater than 0.
1418      *
1419      * Emits a {Transfer} event.
1420      */
1421     function _safeMint(
1422         address to,
1423         uint256 quantity,
1424         bytes memory _data
1425     ) internal {
1426         _mint(to, quantity, _data, true);
1427     }
1428 
1429     /**
1430      * @dev Mints `quantity` tokens and transfers them to `to`.
1431      *
1432      * Requirements:
1433      *
1434      * - `to` cannot be the zero address.
1435      * - `quantity` must be greater than 0.
1436      *
1437      * Emits a {Transfer} event.
1438      */
1439     function _mint(
1440         address to,
1441         uint256 quantity,
1442         bytes memory _data,
1443         bool safe
1444     ) internal {
1445         uint256 startTokenId = currentIndex;
1446         require(to != address(0), 'ERC721A: mint to the zero address');
1447         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1448 
1449         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1450 
1451         // Overflows are incredibly unrealistic.
1452         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1453         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1454         unchecked {
1455             _addressData[to].balance += uint128(quantity);
1456             _addressData[to].numberMinted += uint128(quantity);
1457 
1458             _ownerships[startTokenId].addr = to;
1459             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1460 
1461             uint256 updatedIndex = startTokenId;
1462 
1463             for (uint256 i; i < quantity; i++) {
1464                 emit Transfer(address(0), to, updatedIndex);
1465                 if (safe) {
1466                     require(
1467                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1468                         'ERC721A: transfer to non ERC721Receiver implementer'
1469                     );
1470                 }
1471 
1472                 updatedIndex++;
1473             }
1474 
1475             currentIndex = updatedIndex;
1476         }
1477 
1478         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1479     }
1480 
1481     /**
1482      * @dev Transfers `tokenId` from `from` to `to`.
1483      *
1484      * Requirements:
1485      *
1486      * - `to` cannot be the zero address.
1487      * - `tokenId` token must be owned by `from`.
1488      *
1489      * Emits a {Transfer} event.
1490      */
1491     function _transfer(
1492         address from,
1493         address to,
1494         uint256 tokenId
1495     ) private {
1496         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1497 
1498         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1499             getApproved(tokenId) == _msgSender() ||
1500             isApprovedForAll(prevOwnership.addr, _msgSender()));
1501 
1502         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1503 
1504         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1505         require(to != address(0), 'ERC721A: transfer to the zero address');
1506 
1507         _beforeTokenTransfers(from, to, tokenId, 1);
1508 
1509         // Clear approvals from the previous owner
1510         _approve(address(0), tokenId, prevOwnership.addr);
1511 
1512         // Underflow of the sender's balance is impossible because we check for
1513         // ownership above and the recipient's balance can't realistically overflow.
1514         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1515         unchecked {
1516             _addressData[from].balance -= 1;
1517             _addressData[to].balance += 1;
1518 
1519             _ownerships[tokenId].addr = to;
1520             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1521 
1522             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1523             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1524             uint256 nextTokenId = tokenId + 1;
1525             if (_ownerships[nextTokenId].addr == address(0)) {
1526                 if (_exists(nextTokenId)) {
1527                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1528                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1529                 }
1530             }
1531         }
1532 
1533         emit Transfer(from, to, tokenId);
1534         _afterTokenTransfers(from, to, tokenId, 1);
1535     }
1536 
1537     /**
1538      * @dev Approve `to` to operate on `tokenId`
1539      *
1540      * Emits a {Approval} event.
1541      */
1542     function _approve(
1543         address to,
1544         uint256 tokenId,
1545         address owner
1546     ) private {
1547         _tokenApprovals[tokenId] = to;
1548         emit Approval(owner, to, tokenId);
1549     }
1550 
1551     /**
1552      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1553      * The call is not executed if the target address is not a contract.
1554      *
1555      * @param from address representing the previous owner of the given token ID
1556      * @param to target address that will receive the tokens
1557      * @param tokenId uint256 ID of the token to be transferred
1558      * @param _data bytes optional data to send along with the call
1559      * @return bool whether the call correctly returned the expected magic value
1560      */
1561     function _checkOnERC721Received(
1562         address from,
1563         address to,
1564         uint256 tokenId,
1565         bytes memory _data
1566     ) private returns (bool) {
1567         if (to.isContract()) {
1568             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1569                 return retval == IERC721Receiver(to).onERC721Received.selector;
1570             } catch (bytes memory reason) {
1571                 if (reason.length == 0) {
1572                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1573                 } else {
1574                     assembly {
1575                         revert(add(32, reason), mload(reason))
1576                     }
1577                 }
1578             }
1579         } else {
1580             return true;
1581         }
1582     }
1583 
1584     /**
1585      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1586      *
1587      * startTokenId - the first token id to be transferred
1588      * quantity - the amount to be transferred
1589      *
1590      * Calling conditions:
1591      *
1592      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1593      * transferred to `to`.
1594      * - When `from` is zero, `tokenId` will be minted for `to`.
1595      */
1596     function _beforeTokenTransfers(
1597         address from,
1598         address to,
1599         uint256 startTokenId,
1600         uint256 quantity
1601     ) internal virtual {}
1602 
1603     /**
1604      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1605      * minting.
1606      *
1607      * startTokenId - the first token id to be transferred
1608      * quantity - the amount to be transferred
1609      *
1610      * Calling conditions:
1611      *
1612      * - when `from` and `to` are both non-zero.
1613      * - `from` and `to` are never both zero.
1614      */
1615     function _afterTokenTransfers(
1616         address from,
1617         address to,
1618         uint256 startTokenId,
1619         uint256 quantity
1620     ) internal virtual {}
1621 }
1622 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1623 
1624 
1625 contract NFT is ERC721A, Ownable {
1626     
1627     using Strings for uint256;
1628     
1629     //declares the maximum amount of tokens that can be minted, total and in presale
1630     uint256 private maxTotalTokens;
1631     
1632     //initial part of the URI for the metadata
1633     string private _currentBaseURI;
1634         
1635     //cost of mints depending on state of sale    
1636     uint private mintCost_; 
1637 
1638     //max amount of mints a user can have
1639     uint public maxMint;
1640 
1641     //max amount of mints a user can execute per tx
1642     uint public maxMintPerTX;
1643     
1644     //the amount of reserved mints that have currently been executed by creator and giveaways
1645     uint private _reservedMints;
1646 
1647     //amount of mints that each address has executed
1648     mapping(address => uint256) public mintsPerAddress;
1649     
1650     //current state os sale
1651     enum State {NoSale, OpenSale}
1652     State private saleState_;
1653     
1654     //declaring initial values for variables
1655     constructor() ERC721A('Goblin Vikings', 'GB') {
1656         _currentBaseURI = "ipfs://QmPMBiXpcjMwPg36r9BiixuhJ8W9BY6YqPBK6FHhQnEz2K/";
1657         maxTotalTokens = 8000;
1658         mintCost_ = 0.003 ether;
1659         maxMint = 20;
1660         maxMintPerTX = 5;
1661     }
1662     
1663     //in case somebody accidentaly sends funds or transaction to contract
1664     receive() payable external {}
1665     fallback() payable external {
1666         revert();
1667     }
1668     
1669     //visualize baseURI
1670     function _baseURI() internal view virtual override returns (string memory) {
1671         return _currentBaseURI;
1672     }
1673     
1674     //change baseURI in case needed for IPFS
1675     function changeBaseURI(string memory baseURI_) public onlyOwner {
1676         _currentBaseURI = baseURI_;
1677     }
1678 
1679     //open and close the sale
1680     function toggleSale() public onlyOwner {
1681         if (saleState_ == State.NoSale) {
1682             saleState_ = State.OpenSale;
1683         }
1684         else {
1685             saleState_ = State.NoSale;
1686         }
1687     }
1688     
1689     //mint a @param number of NFTs in presale
1690     function mint(uint256 number) public payable {
1691         require(saleState_ != State.NoSale, "Sale is not open yet!");
1692         require(totalSupply() + number <= maxTotalTokens, "Not enough NFTs left to mint..");
1693         require(number <= maxMintPerTX, "Max Mints per TX exceeded!");
1694         require(mintsPerAddress[msg.sender] + number <= maxMint, "Max mints per address exceeded!");
1695         require(msg.value >= mintCost() * number, "Not sufficient Ether to mint this amount of NFTs");
1696         
1697         _safeMint(msg.sender, number);
1698         mintsPerAddress[msg.sender] += number;
1699 
1700     }
1701     
1702     function tokenURI(uint256 tokenId_) public view virtual override returns (string memory) {
1703         require(_exists(tokenId_), "ERC721Metadata: URI query for nonexistent token");
1704         
1705 
1706         string memory baseURI = _baseURI();
1707         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId_.toString(), ".json")) : "";
1708             
1709     }
1710     
1711     //reserved NFTs for creator
1712     function reservedMint(uint number, address recipient) public onlyOwner {
1713         require(totalSupply() + number <= maxTotalTokens, "Not enough Reserved NFTs left to mint..");
1714 
1715         _safeMint(recipient, number);
1716         mintsPerAddress[recipient] += number;
1717         _reservedMints += number; 
1718         
1719     }
1720 
1721 
1722     
1723     //se the current account balance
1724     function accountBalance() public onlyOwner view returns(uint) {
1725         return address(this).balance;
1726     }
1727     
1728     //retrieve all funds recieved from minting
1729     function withdraw() public onlyOwner {
1730         uint256 balance = accountBalance();
1731         require(balance > 0, 'No Funds to withdraw, Balance is 0');
1732 
1733         _withdraw(payable(owner()), balance); 
1734     }
1735     
1736     //send the percentage of funds to a shareholder´s wallet
1737     function _withdraw(address payable account, uint256 amount) internal {
1738         (bool sent, ) = account.call{value: amount}("");
1739         require(sent, "Failed to send Ether");
1740     }
1741     
1742     //see current state of sale
1743     //see the current state of the sale
1744     function saleState() public view returns(State){
1745         return saleState_;
1746     }
1747     
1748     //gets the cost of current mint
1749     function mintCost() public view returns(uint) {
1750         return mintCost_;
1751     }
1752 
1753     //change the mint cost
1754     function changeMintCost(uint256 newMintCost) public onlyOwner {
1755         mintCost_ = newMintCost;
1756     }
1757 
1758     //change the max mints
1759     function changeMaxMint(uint256 newMaxMint) public onlyOwner {
1760         maxMint = newMaxMint;
1761     }
1762 
1763     //change the max mints per tx
1764     function changeMaxMintPerTX(uint256 newMaxMintPerTX) public onlyOwner {
1765         maxMintPerTX = newMaxMintPerTX;
1766     }
1767    
1768 }