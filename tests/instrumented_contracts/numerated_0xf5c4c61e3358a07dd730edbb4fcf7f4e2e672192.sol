1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/Strings.sol
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
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Context.sol
71 
72 
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
98 
99 
100 pragma solidity ^0.8.0;
101 
102 
103 /**
104  * @dev Contract module which provides a basic access control mechanism, where
105  * there is an account (an owner) that can be granted exclusive access to
106  * specific functions.
107  *
108  * By default, the owner account will be the one that deploys the contract. This
109  * can later be changed with {transferOwnership}.
110  *
111  * This module is used through inheritance. It will make available the modifier
112  * `onlyOwner`, which can be applied to your functions to restrict their use to
113  * the owner.
114  */
115 abstract contract Ownable is Context {
116     address private _owner;
117 
118     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
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
158         require(newOwner != address(0), "Ownable: new owner is the zero address");
159         _setOwner(newOwner);
160     }
161 
162     function _setOwner(address newOwner) private {
163         address oldOwner = _owner;
164         _owner = newOwner;
165         emit OwnershipTransferred(oldOwner, newOwner);
166     }
167 }
168 
169 // File: @openzeppelin/contracts/utils/Address.sol
170 
171 
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @dev Collection of functions related to the address type
177  */
178 library Address {
179     /**
180      * @dev Returns true if `account` is a contract.
181      *
182      * [IMPORTANT]
183      * ====
184      * It is unsafe to assume that an address for which this function returns
185      * false is an externally-owned account (EOA) and not a contract.
186      *
187      * Among others, `isContract` will return false for the following
188      * types of addresses:
189      *
190      *  - an externally-owned account
191      *  - a contract in construction
192      *  - an address where a contract will be created
193      *  - an address where a contract lived, but was destroyed
194      * ====
195      */
196     function isContract(address account) internal view returns (bool) {
197         // This method relies on extcodesize, which returns 0 for contracts in
198         // construction, since the code is only stored at the end of the
199         // constructor execution.
200 
201         uint256 size;
202         assembly {
203             size := extcodesize(account)
204         }
205         return size > 0;
206     }
207 
208     /**
209      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
210      * `recipient`, forwarding all available gas and reverting on errors.
211      *
212      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
213      * of certain opcodes, possibly making contracts go over the 2300 gas limit
214      * imposed by `transfer`, making them unable to receive funds via
215      * `transfer`. {sendValue} removes this limitation.
216      *
217      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
218      *
219      * IMPORTANT: because control is transferred to `recipient`, care must be
220      * taken to not create reentrancy vulnerabilities. Consider using
221      * {ReentrancyGuard} or the
222      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
223      */
224     function sendValue(address payable recipient, uint256 amount) internal {
225         require(address(this).balance >= amount, "Address: insufficient balance");
226 
227         (bool success, ) = recipient.call{value: amount}("");
228         require(success, "Address: unable to send value, recipient may have reverted");
229     }
230 
231     /**
232      * @dev Performs a Solidity function call using a low level `call`. A
233      * plain `call` is an unsafe replacement for a function call: use this
234      * function instead.
235      *
236      * If `target` reverts with a revert reason, it is bubbled up by this
237      * function (like regular Solidity function calls).
238      *
239      * Returns the raw returned data. To convert to the expected return value,
240      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
241      *
242      * Requirements:
243      *
244      * - `target` must be a contract.
245      * - calling `target` with `data` must not revert.
246      *
247      * _Available since v3.1._
248      */
249     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
250         return functionCall(target, data, "Address: low-level call failed");
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
255      * `errorMessage` as a fallback revert reason when `target` reverts.
256      *
257      * _Available since v3.1._
258      */
259     function functionCall(
260         address target,
261         bytes memory data,
262         string memory errorMessage
263     ) internal returns (bytes memory) {
264         return functionCallWithValue(target, data, 0, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but also transferring `value` wei to `target`.
270      *
271      * Requirements:
272      *
273      * - the calling contract must have an ETH balance of at least `value`.
274      * - the called Solidity function must be `payable`.
275      *
276      * _Available since v3.1._
277      */
278     function functionCallWithValue(
279         address target,
280         bytes memory data,
281         uint256 value
282     ) internal returns (bytes memory) {
283         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
288      * with `errorMessage` as a fallback revert reason when `target` reverts.
289      *
290      * _Available since v3.1._
291      */
292     function functionCallWithValue(
293         address target,
294         bytes memory data,
295         uint256 value,
296         string memory errorMessage
297     ) internal returns (bytes memory) {
298         require(address(this).balance >= value, "Address: insufficient balance for call");
299         require(isContract(target), "Address: call to non-contract");
300 
301         (bool success, bytes memory returndata) = target.call{value: value}(data);
302         return verifyCallResult(success, returndata, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but performing a static call.
308      *
309      * _Available since v3.3._
310      */
311     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
312         return functionStaticCall(target, data, "Address: low-level static call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
317      * but performing a static call.
318      *
319      * _Available since v3.3._
320      */
321     function functionStaticCall(
322         address target,
323         bytes memory data,
324         string memory errorMessage
325     ) internal view returns (bytes memory) {
326         require(isContract(target), "Address: static call to non-contract");
327 
328         (bool success, bytes memory returndata) = target.staticcall(data);
329         return verifyCallResult(success, returndata, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but performing a delegate call.
335      *
336      * _Available since v3.4._
337      */
338     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
339         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
344      * but performing a delegate call.
345      *
346      * _Available since v3.4._
347      */
348     function functionDelegateCall(
349         address target,
350         bytes memory data,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         require(isContract(target), "Address: delegate call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.delegatecall(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
361      * revert reason using the provided one.
362      *
363      * _Available since v4.3._
364      */
365     function verifyCallResult(
366         bool success,
367         bytes memory returndata,
368         string memory errorMessage
369     ) internal pure returns (bytes memory) {
370         if (success) {
371             return returndata;
372         } else {
373             // Look for revert reason and bubble it up if present
374             if (returndata.length > 0) {
375                 // The easiest way to bubble the revert reason is using memory via assembly
376 
377                 assembly {
378                     let returndata_size := mload(returndata)
379                     revert(add(32, returndata), returndata_size)
380                 }
381             } else {
382                 revert(errorMessage);
383             }
384         }
385     }
386 }
387 
388 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
389 
390 
391 
392 pragma solidity ^0.8.0;
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
421 pragma solidity ^0.8.0;
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
448 pragma solidity ^0.8.0;
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
478 pragma solidity ^0.8.0;
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
622 pragma solidity ^0.8.0;
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
647 
648 pragma solidity >=0.8.2;
649 // to enable certain compiler features
650 
651 //import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
652 
653 
654 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
655     using Address for address;
656     using Strings for uint256;
657 
658     // Token name
659     string private _name;
660 
661     // Token symbol
662     string private _symbol;
663 
664     // Mapping from token ID to owner address
665     mapping(uint256 => address) private _owners;
666 
667     // Mapping owner address to token count
668     mapping(address => uint256) private _balances;
669 
670     // Mapping from token ID to approved address
671     mapping(uint256 => address) private _tokenApprovals;
672 
673     // Mapping from owner to operator approvals
674     mapping(address => mapping(address => bool)) private _operatorApprovals;
675     
676     //Mapping para atribuirle un URI para cada token
677     mapping(uint256 => string) internal id_to_URI;
678 
679     /**
680      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
681      */
682     constructor(string memory name_, string memory symbol_) {
683         _name = name_;
684         _symbol = symbol_;
685     }
686 
687     /**
688      * @dev See {IERC165-supportsInterface}.
689      */
690     
691     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
692         return
693             interfaceId == type(IERC721).interfaceId ||
694             interfaceId == type(IERC721Metadata).interfaceId ||
695             super.supportsInterface(interfaceId);
696     }
697     
698 
699     /**
700      * @dev See {IERC721-balanceOf}.
701      */
702     function balanceOf(address owner) public view virtual override returns (uint256) {
703         require(owner != address(0), "ERC721: balance query for the zero address");
704         return _balances[owner];
705     }
706 
707     /**
708      * @dev See {IERC721-ownerOf}.
709      */
710     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
711         address owner = _owners[tokenId];
712         require(owner != address(0), "ERC721: owner query for nonexistent token");
713         return owner;
714     }
715 
716     /**
717      * @dev See {IERC721Metadata-name}.
718      */
719     function name() public view virtual override returns (string memory) {
720         return _name;
721     }
722 
723     /**
724      * @dev See {IERC721Metadata-symbol}.
725      */
726     function symbol() public view virtual override returns (string memory) {
727         return _symbol;
728     }
729 
730     /**
731      * @dev See {IERC721Metadata-tokenURI}.
732      */
733     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {}
734 
735     /**
736      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
737      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
738      * by default, can be overriden in child contracts.
739      */
740     function _baseURI() internal view virtual returns (string memory) {
741         return "";
742     }
743 
744     /**
745      * @dev See {IERC721-approve}.
746      */
747     function approve(address to, uint256 tokenId) public virtual override {
748         address owner = ERC721.ownerOf(tokenId);
749         require(to != owner, "ERC721: approval to current owner");
750 
751         require(
752             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
753             "ERC721: approve caller is not owner nor approved for all"
754         );
755 
756         _approve(to, tokenId);
757     }
758 
759     /**
760      * @dev See {IERC721-getApproved}.
761      */
762     function getApproved(uint256 tokenId) public view virtual override returns (address) {
763         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
764 
765         return _tokenApprovals[tokenId];
766     }
767 
768     /**
769      * @dev See {IERC721-setApprovalForAll}.
770      */
771     function setApprovalForAll(address operator, bool approved) public virtual override {
772         require(operator != _msgSender(), "ERC721: approve to caller");
773 
774         _operatorApprovals[_msgSender()][operator] = approved;
775         emit ApprovalForAll(_msgSender(), operator, approved);
776     }
777 
778     /**
779      * @dev See {IERC721-isApprovedForAll}.
780      */
781     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
782         return _operatorApprovals[owner][operator];
783     }
784 
785     /**
786      * @dev See {IERC721-transferFrom}.
787      */
788     function transferFrom(
789         address from,
790         address to,
791         uint256 tokenId
792     ) public virtual override {
793         //solhint-disable-next-line max-line-length
794         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
795 
796         _transfer(from, to, tokenId);
797     }
798 
799     /**
800      * @dev See {IERC721-safeTransferFrom}.
801      */
802     function safeTransferFrom(
803         address from,
804         address to,
805         uint256 tokenId
806     ) public virtual override {
807         safeTransferFrom(from, to, tokenId, "");
808     }
809 
810     /**
811      * @dev See {IERC721-safeTransferFrom}.
812      */
813     function safeTransferFrom(
814         address from,
815         address to,
816         uint256 tokenId,
817         bytes memory _data
818     ) public virtual override {
819         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
820         _safeTransfer(from, to, tokenId, _data);
821     }
822 
823     /**
824      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
825      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
826      *
827      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
828      *
829      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
830      * implement alternative mechanisms to perform token transfer, such as signature-based.
831      *
832      * Requirements:
833      *
834      * - `from` cannot be the zero address.
835      * - `to` cannot be the zero address.
836      * - `tokenId` token must exist and be owned by `from`.
837      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
838      *
839      * Emits a {Transfer} event.
840      */
841     function _safeTransfer(
842         address from,
843         address to,
844         uint256 tokenId,
845         bytes memory _data
846     ) internal virtual {
847         _transfer(from, to, tokenId);
848         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
849     }
850 
851     /**
852      * @dev Returns whether `tokenId` exists.
853      *
854      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
855      *
856      * Tokens start existing when they are minted (`_mint`),
857      * and stop existing when they are burned (`_burn`).
858      */
859     function _exists(uint256 tokenId) internal view virtual returns (bool) {
860         return _owners[tokenId] != address(0);
861     }
862 
863     /**
864      * @dev Returns whether `spender` is allowed to manage `tokenId`.
865      *
866      * Requirements:
867      *
868      * - `tokenId` must exist.
869      */
870     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
871         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
872         address owner = ERC721.ownerOf(tokenId);
873         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
874     }
875 
876     /**
877      * @dev Safely mints `tokenId` and transfers it to `to`.
878      *
879      * Requirements:
880      *
881      * - `tokenId` must not exist.
882      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
883      *
884      * Emits a {Transfer} event.
885      */
886     function _safeMint(address to, uint256 tokenId) internal virtual {
887         _safeMint(to, tokenId, "");
888     }
889 
890     /**
891      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
892      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
893      */
894     function _safeMint(
895         address to,
896         uint256 tokenId,
897         bytes memory _data
898     ) internal virtual {
899         _mint(to, tokenId);
900         require(
901             _checkOnERC721Received(address(0), to, tokenId, _data),
902             "ERC721: transfer to non ERC721Receiver implementer"
903         );
904     }
905 
906     /**
907      * @dev Mints `tokenId` and transfers it to `to`.
908      *
909      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
910      *
911      * Requirements:
912      *
913      * - `tokenId` must not exist.
914      * - `to` cannot be the zero address.
915      *
916      * Emits a {Transfer} event.
917      */
918     function _mint(address to, uint256 tokenId) internal virtual {
919         require(to != address(0), "ERC721: mint to the zero address");
920         require(!_exists(tokenId), "ERC721: token already minted");
921 
922         _beforeTokenTransfer(address(0), to, tokenId);
923 
924         _balances[to] += 1;
925         _owners[tokenId] = to;
926 
927         emit Transfer(address(0), to, tokenId);
928     }
929 
930     /**
931      * @dev Destroys `tokenId`.
932      * The approval is cleared when the token is burned.
933      *
934      * Requirements:
935      *
936      * - `tokenId` must exist.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _burn(uint256 tokenId) internal virtual {
941         address owner = ERC721.ownerOf(tokenId);
942 
943         _beforeTokenTransfer(owner, address(0), tokenId);
944 
945         // Clear approvals
946         _approve(address(0), tokenId);
947 
948         _balances[owner] -= 1;
949         delete _owners[tokenId];
950 
951         emit Transfer(owner, address(0), tokenId);
952     }
953 
954     /**
955      * @dev Transfers `tokenId` from `from` to `to`.
956      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
957      *
958      * Requirements:
959      *
960      * - `to` cannot be the zero address.
961      * - `tokenId` token must be owned by `from`.
962      *
963      * Emits a {Transfer} event.
964      */
965     function _transfer(
966         address from,
967         address to,
968         uint256 tokenId
969     ) internal virtual {
970         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
971         require(to != address(0), "ERC721: transfer to the zero address");
972 
973         _beforeTokenTransfer(from, to, tokenId);
974 
975         // Clear approvals from the previous owner
976         _approve(address(0), tokenId);
977 
978         _balances[from] -= 1;
979         _balances[to] += 1;
980         _owners[tokenId] = to;
981 
982         emit Transfer(from, to, tokenId);
983     }
984 
985     /**
986      * @dev Approve `to` to operate on `tokenId`
987      *
988      * Emits a {Approval} event.
989      */
990     function _approve(address to, uint256 tokenId) internal virtual {
991         _tokenApprovals[tokenId] = to;
992         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
993     }
994 
995     /**
996      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
997      * The call is not executed if the target address is not a contract.
998      *
999      * @param from address representing the previous owner of the given token ID
1000      * @param to target address that will receive the tokens
1001      * @param tokenId uint256 ID of the token to be transferred
1002      * @param _data bytes optional data to send along with the call
1003      * @return bool whether the call correctly returned the expected magic value
1004      */
1005     function _checkOnERC721Received(
1006         address from,
1007         address to,
1008         uint256 tokenId,
1009         bytes memory _data
1010     ) private returns (bool) {
1011         if (to.isContract()) {
1012             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1013                 return retval == IERC721Receiver.onERC721Received.selector;
1014             } catch (bytes memory reason) {
1015                 if (reason.length == 0) {
1016                     revert("ERC721: transfer to non ERC721Receiver implementer");
1017                 } else {
1018                     assembly {
1019                         revert(add(32, reason), mload(reason))
1020                     }
1021                 }
1022             }
1023         } else {
1024             return true;
1025         }
1026     }
1027 
1028     /**
1029      * @dev Hook that is called before any token transfer. This includes minting
1030      * and burning.
1031      *
1032      * Calling conditions:
1033      *
1034      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1035      * transferred to `to`.
1036      * - When `from` is zero, `tokenId` will be minted for `to`.
1037      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1038      * - `from` and `to` are never both zero.
1039      *
1040      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1041      */
1042     function _beforeTokenTransfer(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) internal virtual {}
1047 }
1048 
1049 contract Saibushi is ERC721, Ownable {
1050     using Strings for uint256;
1051 
1052     //amount of tokens that have been minted so far, in total and in presale
1053     uint256 private numberOfTotalTokens;
1054     
1055     //declares the maximum amount of tokens that can be minted, total and in presale
1056     uint256 private maxTotalTokens;
1057     
1058     //initial part of the URI for the metadata
1059     string private _currentBaseURI;
1060     
1061     //the amount of reserved mints that have currently been executed by creator and giveaways
1062     uint private _reservedMints;
1063     
1064     //dummy address that we use to sign the mint transaction to make sure it is valid
1065     address private dummy = 0x80E4929c869102140E69550BBECC20bEd61B080c;
1066     
1067     //marks the timestamp of when the respective sales open
1068     uint256 internal presaleLaunchTime;
1069     uint256 internal publicSaleLaunchTime;
1070     uint256 internal revealTime;
1071 
1072     //amount of mints that each address has executed
1073     mapping(address => uint256) public mintsPerAddressPresale;
1074     mapping(address => uint256) public mintsPerAddressPublicSale;
1075     
1076     //current state os sale
1077     enum State {NoSale, Presale, PublicSale}
1078 
1079     //defines the uri for when the NFTs have not been yet revealed
1080     string public unrevealedURI;
1081     
1082     //declaring initial values for variables
1083     constructor() ERC721('Saibushi', 'S') {
1084         maxTotalTokens = 4444;
1085 
1086         unrevealedURI = "ipfs://QmXc1Q4QKw87qer4NpzCf5XjMYB8CcrWcq6WVi5PvuvwnT/";
1087     }
1088     
1089     //in case somebody accidentaly sends funds or transaction to contract
1090     receive() payable external {}
1091     fallback() payable external {
1092         revert();
1093     }
1094     
1095     //visualize baseURI
1096     function _baseURI() internal view virtual override returns (string memory) {
1097         return _currentBaseURI;
1098     }
1099     
1100     //change baseURI in case needed for IPFS
1101     function changeBaseURI(string memory baseURI_) public onlyOwner {
1102         _currentBaseURI = baseURI_;
1103     }
1104 
1105     function changeUnrevealedURI(string memory unrevealedURI_) public onlyOwner {
1106         unrevealedURI = unrevealedURI_;
1107     }
1108     
1109     //gets the tokenID of NFT to be minted
1110     function tokenId() internal view returns(uint256) {
1111         return numberOfTotalTokens + 1;
1112     }
1113 
1114     function switchToPresale() public onlyOwner {
1115         require(saleState() == State.NoSale, 'Sale is already Open!');
1116         presaleLaunchTime = block.timestamp;
1117     }
1118 
1119     function switchToPublic () public onlyOwner {
1120         require(saleState() == State.Presale, 'Cannot Open Public Sale!');
1121         publicSaleLaunchTime = block.timestamp;
1122     }
1123     
1124     modifier onlyValidAccess(uint8 _v, bytes32 _r, bytes32 _s) {
1125         require( isValidAccessMessage(msg.sender,_v,_r,_s), 'Invalid Signature' );
1126         _;
1127     }
1128  
1129     /* 
1130     * @dev Verifies if message was signed by owner to give access to _add for this contract.
1131     *      Assumes Geth signature prefix.
1132     * @param _add Address of agent with access
1133     * @param _v ECDSA signature parameter v.
1134     * @param _r ECDSA signature parameters r.
1135     * @param _s ECDSA signature parameters s.
1136     * @return Validity of access message for a given address.
1137     */
1138     function isValidAccessMessage(address _add, uint8 _v, bytes32 _r, bytes32 _s) view public returns (bool) {
1139         bytes32 hash = keccak256(abi.encodePacked(address(this), _add));
1140         return dummy == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), _v, _r, _s);
1141     }
1142     
1143     //mint a @param number of NFTs in presale
1144     function presaleMint(uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v,  _r, _s) public {
1145         State saleState_ = saleState();
1146         require(saleState_ != State.NoSale, "Sale in not open yet!");
1147         require(saleState_ != State.PublicSale, "Presale has closed, Check out Public Sale!");
1148         require(numberOfTotalTokens < maxTotalTokens, "Not enough NFTs left to mint..");
1149         require(mintsPerAddressPresale[msg.sender] < 1, "Maximum 1 Mint per Address allowed!");
1150 
1151         uint256 tid = tokenId();
1152         _safeMint(msg.sender, tid);
1153         mintsPerAddressPresale[msg.sender] += 1;
1154         numberOfTotalTokens += 1;
1155         
1156 
1157     }
1158 
1159     //mint a @param number of NFTs in public sale
1160     function publicSaleMint() public {
1161         State saleState_ = saleState();
1162         require(saleState_ == State.PublicSale, "Public Sale in not open yet!");
1163         require(numberOfTotalTokens < maxTotalTokens, "Not enough NFTs left to mint..");
1164         require(mintsPerAddressPublicSale[msg.sender] < 1, "Maximum 1 Mint per Address allowed!");
1165 
1166         uint256 tid = tokenId();
1167         _safeMint(msg.sender, tid);
1168         mintsPerAddressPublicSale[msg.sender] += 1;
1169         numberOfTotalTokens += 1;
1170         
1171     }
1172     
1173     function tokenURI(uint256 tokenId_) public view virtual override returns (string memory) {
1174         require(_exists(tokenId_), "ERC721Metadata: URI query for nonexistent token");
1175         
1176         //check to see that 24 hours have passed since beginning of publicsale launch
1177         if (revealTime == 0) {
1178             return unrevealedURI;
1179         }
1180         
1181         else {
1182             string memory baseURI = _baseURI();
1183             return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId_.toString(), '.json')) : "";
1184         }    
1185     }
1186     
1187     //reserved NFTs for creator
1188     function reservedMint(uint number, address recipient) public onlyOwner {
1189         require(_reservedMints + number <= maxTotalTokens, "Not enough NFTs left to mint..");
1190 
1191         for (uint i = 0; i < number; i++) {
1192             _safeMint(recipient, _reservedMints + 1);
1193             numberOfTotalTokens += 1;
1194             _reservedMints += 1;
1195         }    
1196         
1197     }
1198     
1199     //burn the tokens that have not been sold yet
1200     function burnTokens() public onlyOwner {
1201         maxTotalTokens = numberOfTotalTokens;
1202     }
1203     
1204     //se the current account balance
1205     function accountBalance() public onlyOwner view returns(uint) {
1206         return address(this).balance;
1207     }
1208     
1209     //retrieve all funds recieved from minting
1210     function withdraw() public onlyOwner {
1211         uint256 balance = accountBalance();
1212         require(balance > 0, 'No Funds to withdraw, Balance is 0');
1213 
1214         _withdraw(payable(owner()), (balance * 50) / 100); 
1215         _withdraw(payable(owner()), accountBalance()); //to avoid dust eth
1216     }
1217     
1218     //send the percentage of funds to a shareholder´s wallet
1219     function _withdraw(address payable account, uint256 amount) internal {
1220         (bool sent, ) = account.call{value: amount}("");
1221         require(sent, "Failed to send Ether");
1222     }
1223     
1224     //change the dummy account used for signing transactions
1225     function changeDummy(address _dummy) public onlyOwner {
1226         dummy = _dummy;
1227     }
1228     
1229     //see the total amount of tokens that have been minted
1230     function totalSupply() public view returns(uint) {
1231         return numberOfTotalTokens;
1232     }
1233 
1234     //see the current state of the sale
1235     function saleState() public view returns(State){
1236         if (presaleLaunchTime == 0) {
1237             return State.NoSale;
1238         }
1239         else if (publicSaleLaunchTime == 0) {
1240             return State.Presale;
1241         }
1242         else {
1243             return State.PublicSale;
1244         }
1245     }
1246 
1247     //see when NFTs will be revealed
1248     function timeOfReveal() public view returns(uint256) {
1249         require(revealTime != 0, 'NFT Reveal Time has not been determined yet!');
1250         return revealTime;
1251     }
1252 
1253     //reveal the collection
1254     function reveal() public onlyOwner {
1255         require(revealTime == 0, "Has already been revealed!");
1256         revealTime = block.timestamp;
1257     }
1258     
1259    
1260 }