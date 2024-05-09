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
56     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
57         bytes memory buffer = new bytes(2 * length + 2);
58         buffer[0] = "0";
59         buffer[1] = "x";
60         for (uint256 i = 2 * length + 1; i > 1; --i) {
61             buffer[i] = _HEX_SYMBOLS[value & 0xf];
62             value >>= 4;
63         }
64         require(value == 0, "Strings: hex length insufficient");
65         return string(buffer);
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Context.sol
70 
71 
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev Provides information about the current execution context, including the
77  * sender of the transaction and its data. While these are generally available
78  * via msg.sender and msg.data, they should not be accessed in such a direct
79  * manner, since when dealing with meta-transactions the account sending and
80  * paying for execution may not be the actual sender (as far as an application
81  * is concerned).
82  *
83  * This contract is only required for intermediate, library-like contracts.
84  */
85 abstract contract Context {
86     function _msgSender() internal view virtual returns (address) {
87         return msg.sender;
88     }
89 
90     function _msgData() internal view virtual returns (bytes calldata) {
91         return msg.data;
92     }
93 }
94 
95 // File: @openzeppelin/contracts/access/Ownable.sol
96 
97 
98 
99 pragma solidity ^0.8.0;
100 
101 
102 /**
103  * @dev Contract module which provides a basic access control mechanism, where
104  * there is an account (an owner) that can be granted exclusive access to
105  * specific functions.
106  *
107  * By default, the owner account will be the one that deploys the contract. This
108  * can later be changed with {transferOwnership}.
109  *
110  * This module is used through inheritance. It will make available the modifier
111  * `onlyOwner`, which can be applied to your functions to restrict their use to
112  * the owner.
113  */
114 abstract contract Ownable is Context {
115     address private _owner;
116 
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119     /**
120      * @dev Initializes the contract setting the deployer as the initial owner.
121      */
122     constructor() {
123         _setOwner(_msgSender());
124     }
125 
126     /**
127      * @dev Returns the address of the current owner.
128      */
129     function owner() public view virtual returns (address) {
130         return _owner;
131     }
132 
133     /**
134      * @dev Throws if called by any account other than the owner.
135      */
136     modifier onlyOwner() {
137         require(owner() == _msgSender(), "Ownable: caller is not the owner");
138         _;
139     }
140 
141     /**
142      * @dev Leaves the contract without owner. It will not be possible to call
143      * `onlyOwner` functions anymore. Can only be called by the current owner.
144      *
145      * NOTE: Renouncing ownership will leave the contract without an owner,
146      * thereby removing any functionality that is only available to the owner.
147      */
148     function renounceOwnership() public virtual onlyOwner {
149         _setOwner(address(0));
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      * Can only be called by the current owner.
155      */
156     function transferOwnership(address newOwner) public virtual onlyOwner {
157         require(newOwner != address(0), "Ownable: new owner is the zero address");
158         _setOwner(newOwner);
159     }
160 
161     function _setOwner(address newOwner) private {
162         address oldOwner = _owner;
163         _owner = newOwner;
164         emit OwnershipTransferred(oldOwner, newOwner);
165     }
166 }
167 
168 // File: @openzeppelin/contracts/utils/Address.sol
169 
170 
171 
172 pragma solidity ^0.8.0;
173 
174 /**
175  * @dev Collection of functions related to the address type
176  */
177 library Address {
178     /**
179      * @dev Returns true if `account` is a contract.
180      *
181      * [IMPORTANT]
182      * ====
183      * It is unsafe to assume that an address for which this function returns
184      * false is an externally-owned account (EOA) and not a contract.
185      *
186      * Among others, `isContract` will return false for the following
187      * types of addresses:
188      *
189      *  - an externally-owned account
190      *  - a contract in construction
191      *  - an address where a contract will be created
192      *  - an address where a contract lived, but was destroyed
193      * ====
194      */
195     function isContract(address account) internal view returns (bool) {
196         // This method relies on extcodesize, which returns 0 for contracts in
197         // construction, since the code is only stored at the end of the
198         // constructor execution.
199 
200         uint256 size;
201         assembly {
202             size := extcodesize(account)
203         }
204         return size > 0;
205     }
206 
207     /**
208      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
209      * `recipient`, forwarding all available gas and reverting on errors.
210      *
211      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
212      * of certain opcodes, possibly making contracts go over the 2300 gas limit
213      * imposed by `transfer`, making them unable to receive funds via
214      * `transfer`. {sendValue} removes this limitation.
215      *
216      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
217      *
218      * IMPORTANT: because control is transferred to `recipient`, care must be
219      * taken to not create reentrancy vulnerabilities. Consider using
220      * {ReentrancyGuard} or the
221      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
222      */
223     function sendValue(address payable recipient, uint256 amount) internal {
224         require(address(this).balance >= amount, "Address: insufficient balance");
225 
226         (bool success, ) = recipient.call{value: amount}("");
227         require(success, "Address: unable to send value, recipient may have reverted");
228     }
229 
230     /**
231      * @dev Performs a Solidity function call using a low level `call`. A
232      * plain `call` is an unsafe replacement for a function call: use this
233      * function instead.
234      *
235      * If `target` reverts with a revert reason, it is bubbled up by this
236      * function (like regular Solidity function calls).
237      *
238      * Returns the raw returned data. To convert to the expected return value,
239      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
240      *
241      * Requirements:
242      *
243      * - `target` must be a contract.
244      * - calling `target` with `data` must not revert.
245      *
246      * _Available since v3.1._
247      */
248     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
249         return functionCall(target, data, "Address: low-level call failed");
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
254      * `errorMessage` as a fallback revert reason when `target` reverts.
255      *
256      * _Available since v3.1._
257      */
258     function functionCall(
259         address target,
260         bytes memory data,
261         string memory errorMessage
262     ) internal returns (bytes memory) {
263         return functionCallWithValue(target, data, 0, errorMessage);
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
268      * but also transferring `value` wei to `target`.
269      *
270      * Requirements:
271      *
272      * - the calling contract must have an ETH balance of at least `value`.
273      * - the called Solidity function must be `payable`.
274      *
275      * _Available since v3.1._
276      */
277     function functionCallWithValue(
278         address target,
279         bytes memory data,
280         uint256 value
281     ) internal returns (bytes memory) {
282         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
287      * with `errorMessage` as a fallback revert reason when `target` reverts.
288      *
289      * _Available since v3.1._
290      */
291     function functionCallWithValue(
292         address target,
293         bytes memory data,
294         uint256 value,
295         string memory errorMessage
296     ) internal returns (bytes memory) {
297         require(address(this).balance >= value, "Address: insufficient balance for call");
298         require(isContract(target), "Address: call to non-contract");
299 
300         (bool success, bytes memory returndata) = target.call{value: value}(data);
301         return verifyCallResult(success, returndata, errorMessage);
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
306      * but performing a static call.
307      *
308      * _Available since v3.3._
309      */
310     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
311         return functionStaticCall(target, data, "Address: low-level static call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
316      * but performing a static call.
317      *
318      * _Available since v3.3._
319      */
320     function functionStaticCall(
321         address target,
322         bytes memory data,
323         string memory errorMessage
324     ) internal view returns (bytes memory) {
325         require(isContract(target), "Address: static call to non-contract");
326 
327         (bool success, bytes memory returndata) = target.staticcall(data);
328         return verifyCallResult(success, returndata, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but performing a delegate call.
334      *
335      * _Available since v3.4._
336      */
337     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
338         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
343      * but performing a delegate call.
344      *
345      * _Available since v3.4._
346      */
347     function functionDelegateCall(
348         address target,
349         bytes memory data,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         require(isContract(target), "Address: delegate call to non-contract");
353 
354         (bool success, bytes memory returndata) = target.delegatecall(data);
355         return verifyCallResult(success, returndata, errorMessage);
356     }
357 
358     /**
359      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
360      * revert reason using the provided one.
361      *
362      * _Available since v4.3._
363      */
364     function verifyCallResult(
365         bool success,
366         bytes memory returndata,
367         string memory errorMessage
368     ) internal pure returns (bytes memory) {
369         if (success) {
370             return returndata;
371         } else {
372             // Look for revert reason and bubble it up if present
373             if (returndata.length > 0) {
374                 // The easiest way to bubble the revert reason is using memory via assembly
375 
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
388 
389 
390 
391 pragma solidity ^0.8.0;
392 
393 /**
394  * @title ERC721 token receiver interface
395  * @dev Interface for any contract that wants to support safeTransfers
396  * from ERC721 asset contracts.
397  */
398 interface IERC721Receiver {
399     /**
400      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
401      * by `operator` from `from`, this function is called.
402      *
403      * It must return its Solidity selector to confirm the token transfer.
404      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
405      *
406      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
407      */
408     function onERC721Received(
409         address operator,
410         address from,
411         uint256 tokenId,
412         bytes calldata data
413     ) external returns (bytes4);
414 }
415 
416 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
417 
418 
419 
420 pragma solidity ^0.8.0;
421 
422 /**
423  * @dev Interface of the ERC165 standard, as defined in the
424  * https://eips.ethereum.org/EIPS/eip-165[EIP].
425  *
426  * Implementers can declare support of contract interfaces, which can then be
427  * queried by others ({ERC165Checker}).
428  *
429  * For an implementation, see {ERC165}.
430  */
431 interface IERC165 {
432     /**
433      * @dev Returns true if this contract implements the interface defined by
434      * `interfaceId`. See the corresponding
435      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
436      * to learn more about how these ids are created.
437      *
438      * This function call must use less than 30 000 gas.
439      */
440     function supportsInterface(bytes4 interfaceId) external view returns (bool);
441 }
442 
443 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
444 
445 
446 
447 pragma solidity ^0.8.0;
448 
449 
450 /**
451  * @dev Implementation of the {IERC165} interface.
452  *
453  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
454  * for the additional interface id that will be supported. For example:
455  *
456  * ```solidity
457  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
458  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
459  * }
460  * ```
461  *
462  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
463  */
464 abstract contract ERC165 is IERC165 {
465     /**
466      * @dev See {IERC165-supportsInterface}.
467      */
468     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
469         return interfaceId == type(IERC165).interfaceId;
470     }
471 }
472 
473 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
474 
475 
476 
477 pragma solidity ^0.8.0;
478 
479 
480 /**
481  * @dev Required interface of an ERC721 compliant contract.
482  */
483 interface IERC721 is IERC165 {
484     /**
485      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
486      */
487     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
488 
489     /**
490      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
491      */
492     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
493 
494     /**
495      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
496      */
497     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
498 
499     /**
500      * @dev Returns the number of tokens in ``owner``'s account.
501      */
502     function balanceOf(address owner) external view returns (uint256 balance);
503 
504     /**
505      * @dev Returns the owner of the `tokenId` token.
506      *
507      * Requirements:
508      *
509      * - `tokenId` must exist.
510      */
511     function ownerOf(uint256 tokenId) external view returns (address owner);
512 
513     /**
514      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
515      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
516      *
517      * Requirements:
518      *
519      * - `from` cannot be the zero address.
520      * - `to` cannot be the zero address.
521      * - `tokenId` token must exist and be owned by `from`.
522      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
523      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
524      *
525      * Emits a {Transfer} event.
526      */
527     function safeTransferFrom(
528         address from,
529         address to,
530         uint256 tokenId
531     ) external;
532 
533     /**
534      * @dev Transfers `tokenId` token from `from` to `to`.
535      *
536      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
537      *
538      * Requirements:
539      *
540      * - `from` cannot be the zero address.
541      * - `to` cannot be the zero address.
542      * - `tokenId` token must be owned by `from`.
543      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
544      *
545      * Emits a {Transfer} event.
546      */
547     function transferFrom(
548         address from,
549         address to,
550         uint256 tokenId
551     ) external;
552 
553     /**
554      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
555      * The approval is cleared when the token is transferred.
556      *
557      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
558      *
559      * Requirements:
560      *
561      * - The caller must own the token or be an approved operator.
562      * - `tokenId` must exist.
563      *
564      * Emits an {Approval} event.
565      */
566     function approve(address to, uint256 tokenId) external;
567 
568     /**
569      * @dev Returns the account approved for `tokenId` token.
570      *
571      * Requirements:
572      *
573      * - `tokenId` must exist.
574      */
575     function getApproved(uint256 tokenId) external view returns (address operator);
576 
577     /**
578      * @dev Approve or remove `operator` as an operator for the caller.
579      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
580      *
581      * Requirements:
582      *
583      * - The `operator` cannot be the caller.
584      *
585      * Emits an {ApprovalForAll} event.
586      */
587     function setApprovalForAll(address operator, bool _approved) external;
588 
589     /**
590      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
591      *
592      * See {setApprovalForAll}
593      */
594     function isApprovedForAll(address owner, address operator) external view returns (bool);
595 
596     /**
597      * @dev Safely transfers `tokenId` token from `from` to `to`.
598      *
599      * Requirements:
600      *
601      * - `from` cannot be the zero address.
602      * - `to` cannot be the zero address.
603      * - `tokenId` token must exist and be owned by `from`.
604      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
605      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
606      *
607      * Emits a {Transfer} event.
608      */
609     function safeTransferFrom(
610         address from,
611         address to,
612         uint256 tokenId,
613         bytes calldata data
614     ) external;
615 }
616 
617 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
618 
619 
620 
621 pragma solidity ^0.8.0;
622 
623 
624 /**
625  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
626  * @dev See https://eips.ethereum.org/EIPS/eip-721
627  */
628 interface IERC721Metadata is IERC721 {
629     /**
630      * @dev Returns the token collection name.
631      */
632     function name() external view returns (string memory);
633 
634     /**
635      * @dev Returns the token collection symbol.
636      */
637     function symbol() external view returns (string memory);
638 
639     /**
640      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
641      */
642     function tokenURI(uint256 tokenId) external view returns (string memory);
643 }
644 
645 // File: contracts/creepies.sol
646 
647 
648 
649 pragma solidity >=0.8.2;
650 // to enable certain compiler features
651 
652 //import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
653 
654 
655 
656 
657 
658 
659 
660 
661 
662 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
663     using Address for address;
664     using Strings for uint256;
665 
666     // Token name
667     string private _name;
668 
669     // Token symbol
670     string private _symbol;
671 
672     // Mapping from token ID to owner address
673     mapping(uint256 => address) private _owners;
674 
675     // Mapping owner address to token count
676     mapping(address => uint256) private _balances;
677 
678     // Mapping from token ID to approved address
679     mapping(uint256 => address) private _tokenApprovals;
680 
681     // Mapping from owner to operator approvals
682     mapping(address => mapping(address => bool)) private _operatorApprovals;
683     
684     //Mapping para atribuirle un URI para cada token
685     mapping(uint256 => string) internal id_to_URI;
686 
687     /**
688      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
689      */
690     constructor(string memory name_, string memory symbol_) {
691         _name = name_;
692         _symbol = symbol_;
693     }
694 
695     /**
696      * @dev See {IERC165-supportsInterface}.
697      */
698     
699     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
700         return
701             interfaceId == type(IERC721).interfaceId ||
702             interfaceId == type(IERC721Metadata).interfaceId ||
703             super.supportsInterface(interfaceId);
704     }
705     
706 
707     /**
708      * @dev See {IERC721-balanceOf}.
709      */
710     function balanceOf(address owner) public view virtual override returns (uint256) {
711         require(owner != address(0), "ERC721: balance query for the zero address");
712         return _balances[owner];
713     }
714 
715     /**
716      * @dev See {IERC721-ownerOf}.
717      */
718     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
719         address owner = _owners[tokenId];
720         require(owner != address(0), "ERC721: owner query for nonexistent token");
721         return owner;
722     }
723 
724     /**
725      * @dev See {IERC721Metadata-name}.
726      */
727     function name() public view virtual override returns (string memory) {
728         return _name;
729     }
730 
731     /**
732      * @dev See {IERC721Metadata-symbol}.
733      */
734     function symbol() public view virtual override returns (string memory) {
735         return _symbol;
736     }
737 
738     /**
739      * @dev See {IERC721Metadata-tokenURI}.
740      */
741     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {}
742 
743     /**
744      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
745      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
746      * by default, can be overriden in child contracts.
747      */
748     function _baseURI() internal view virtual returns (string memory) {
749         return "";
750     }
751 
752     /**
753      * @dev See {IERC721-approve}.
754      */
755     function approve(address to, uint256 tokenId) public virtual override {
756         address owner = ERC721.ownerOf(tokenId);
757         require(to != owner, "ERC721: approval to current owner");
758 
759         require(
760             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
761             "ERC721: approve caller is not owner nor approved for all"
762         );
763 
764         _approve(to, tokenId);
765     }
766 
767     /**
768      * @dev See {IERC721-getApproved}.
769      */
770     function getApproved(uint256 tokenId) public view virtual override returns (address) {
771         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
772 
773         return _tokenApprovals[tokenId];
774     }
775 
776     /**
777      * @dev See {IERC721-setApprovalForAll}.
778      */
779     function setApprovalForAll(address operator, bool approved) public virtual override {
780         require(operator != _msgSender(), "ERC721: approve to caller");
781 
782         _operatorApprovals[_msgSender()][operator] = approved;
783         emit ApprovalForAll(_msgSender(), operator, approved);
784     }
785 
786     /**
787      * @dev See {IERC721-isApprovedForAll}.
788      */
789     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
790         return _operatorApprovals[owner][operator];
791     }
792 
793     /**
794      * @dev See {IERC721-transferFrom}.
795      */
796     function transferFrom(
797         address from,
798         address to,
799         uint256 tokenId
800     ) public virtual override {
801         //solhint-disable-next-line max-line-length
802         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
803 
804         _transfer(from, to, tokenId);
805     }
806 
807     /**
808      * @dev See {IERC721-safeTransferFrom}.
809      */
810     function safeTransferFrom(
811         address from,
812         address to,
813         uint256 tokenId
814     ) public virtual override {
815         safeTransferFrom(from, to, tokenId, "");
816     }
817 
818     /**
819      * @dev See {IERC721-safeTransferFrom}.
820      */
821     function safeTransferFrom(
822         address from,
823         address to,
824         uint256 tokenId,
825         bytes memory _data
826     ) public virtual override {
827         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
828         _safeTransfer(from, to, tokenId, _data);
829     }
830 
831     /**
832      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
833      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
834      *
835      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
836      *
837      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
838      * implement alternative mechanisms to perform token transfer, such as signature-based.
839      *
840      * Requirements:
841      *
842      * - `from` cannot be the zero address.
843      * - `to` cannot be the zero address.
844      * - `tokenId` token must exist and be owned by `from`.
845      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
846      *
847      * Emits a {Transfer} event.
848      */
849     function _safeTransfer(
850         address from,
851         address to,
852         uint256 tokenId,
853         bytes memory _data
854     ) internal virtual {
855         _transfer(from, to, tokenId);
856         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
857     }
858 
859     /**
860      * @dev Returns whether `tokenId` exists.
861      *
862      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
863      *
864      * Tokens start existing when they are minted (`_mint`),
865      * and stop existing when they are burned (`_burn`).
866      */
867     function _exists(uint256 tokenId) internal view virtual returns (bool) {
868         return _owners[tokenId] != address(0);
869     }
870 
871     /**
872      * @dev Returns whether `spender` is allowed to manage `tokenId`.
873      *
874      * Requirements:
875      *
876      * - `tokenId` must exist.
877      */
878     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
879         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
880         address owner = ERC721.ownerOf(tokenId);
881         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
882     }
883 
884     /**
885      * @dev Safely mints `tokenId` and transfers it to `to`.
886      *
887      * Requirements:
888      *
889      * - `tokenId` must not exist.
890      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
891      *
892      * Emits a {Transfer} event.
893      */
894     function _safeMint(address to, uint256 tokenId) internal virtual {
895         _safeMint(to, tokenId, "");
896     }
897 
898     /**
899      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
900      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
901      */
902     function _safeMint(
903         address to,
904         uint256 tokenId,
905         bytes memory _data
906     ) internal virtual {
907         _mint(to, tokenId);
908         require(
909             _checkOnERC721Received(address(0), to, tokenId, _data),
910             "ERC721: transfer to non ERC721Receiver implementer"
911         );
912     }
913 
914     /**
915      * @dev Mints `tokenId` and transfers it to `to`.
916      *
917      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
918      *
919      * Requirements:
920      *
921      * - `tokenId` must not exist.
922      * - `to` cannot be the zero address.
923      *
924      * Emits a {Transfer} event.
925      */
926     function _mint(address to, uint256 tokenId) internal virtual {
927         require(to != address(0), "ERC721: mint to the zero address");
928         require(!_exists(tokenId), "ERC721: token already minted");
929 
930         _beforeTokenTransfer(address(0), to, tokenId);
931 
932         _balances[to] += 1;
933         _owners[tokenId] = to;
934 
935         emit Transfer(address(0), to, tokenId);
936     }
937 
938     /**
939      * @dev Destroys `tokenId`.
940      * The approval is cleared when the token is burned.
941      *
942      * Requirements:
943      *
944      * - `tokenId` must exist.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _burn(uint256 tokenId) internal virtual {
949         address owner = ERC721.ownerOf(tokenId);
950 
951         _beforeTokenTransfer(owner, address(0), tokenId);
952 
953         // Clear approvals
954         _approve(address(0), tokenId);
955 
956         _balances[owner] -= 1;
957         delete _owners[tokenId];
958 
959         emit Transfer(owner, address(0), tokenId);
960     }
961 
962     /**
963      * @dev Transfers `tokenId` from `from` to `to`.
964      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
965      *
966      * Requirements:
967      *
968      * - `to` cannot be the zero address.
969      * - `tokenId` token must be owned by `from`.
970      *
971      * Emits a {Transfer} event.
972      */
973     function _transfer(
974         address from,
975         address to,
976         uint256 tokenId
977     ) internal virtual {
978         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
979         require(to != address(0), "ERC721: transfer to the zero address");
980 
981         _beforeTokenTransfer(from, to, tokenId);
982 
983         // Clear approvals from the previous owner
984         _approve(address(0), tokenId);
985 
986         _balances[from] -= 1;
987         _balances[to] += 1;
988         _owners[tokenId] = to;
989 
990         emit Transfer(from, to, tokenId);
991     }
992 
993     /**
994      * @dev Approve `to` to operate on `tokenId`
995      *
996      * Emits a {Approval} event.
997      */
998     function _approve(address to, uint256 tokenId) internal virtual {
999         _tokenApprovals[tokenId] = to;
1000         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1001     }
1002 
1003     /**
1004      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1005      * The call is not executed if the target address is not a contract.
1006      *
1007      * @param from address representing the previous owner of the given token ID
1008      * @param to target address that will receive the tokens
1009      * @param tokenId uint256 ID of the token to be transferred
1010      * @param _data bytes optional data to send along with the call
1011      * @return bool whether the call correctly returned the expected magic value
1012      */
1013     function _checkOnERC721Received(
1014         address from,
1015         address to,
1016         uint256 tokenId,
1017         bytes memory _data
1018     ) private returns (bool) {
1019         if (to.isContract()) {
1020             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1021                 return retval == IERC721Receiver.onERC721Received.selector;
1022             } catch (bytes memory reason) {
1023                 if (reason.length == 0) {
1024                     revert("ERC721: transfer to non ERC721Receiver implementer");
1025                 } else {
1026                     assembly {
1027                         revert(add(32, reason), mload(reason))
1028                     }
1029                 }
1030             }
1031         } else {
1032             return true;
1033         }
1034     }
1035 
1036     /**
1037      * @dev Hook that is called before any token transfer. This includes minting
1038      * and burning.
1039      *
1040      * Calling conditions:
1041      *
1042      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1043      * transferred to `to`.
1044      * - When `from` is zero, `tokenId` will be minted for `to`.
1045      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1046      * - `from` and `to` are never both zero.
1047      *
1048      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1049      */
1050     function _beforeTokenTransfer(
1051         address from,
1052         address to,
1053         uint256 tokenId
1054     ) internal virtual {}
1055 }
1056 
1057 contract nft is ERC721, Ownable {
1058     using Strings for uint256;
1059 
1060     //amount of tokens that have been minted so far, in total and in presale
1061     uint256 private numberOfTokensPresale1;
1062     uint256 private numberOfTokensPresale2;
1063     uint256 private numberOfTokensWhitelist;
1064     uint256 private numberOfTotalTokens;
1065     
1066     //declares the maximum amount of tokens that can be minted, total and in presale
1067     uint256 private maxTokensPresale1 = 70;
1068     uint256 private maxTokensPresale2 = 930;
1069     uint256 private maxTokensWhitelist = 2600;
1070     uint256 private maxTotalTokens;
1071     
1072     //initial part of the URI for the metadata
1073     string private _currentBaseURI;
1074         
1075     //cost of mints depending on state of sale    
1076     uint private mintCostPresale2 = 0.1 ether;
1077     uint private mintCostWhitelistSale = 0.2 ether;
1078     uint private mintCostPublicSale = 0.25 ether;
1079     
1080     //maximum amount of mints allowed per person
1081     uint256 private maxMintPresale1 = 1;
1082     uint256 private maxMintRest = 10;
1083     
1084     //the amount of reserved mints that have currently been executed by creator and by marketing wallet
1085     uint private _reservedMintsMarketing = 0;
1086     uint private _reservedMintsTeam = 0;
1087     
1088     //the maximum amount of reserved mints allowed for creator and marketing wallet
1089     uint private maxReservedMintsMarketing = 999;
1090     uint private maxReservedMintsTeam = 400;
1091     
1092     //dummy address that we use to sign the mint transaction to make sure it is valid
1093     address private dummy = 0x80E4929c869102140E69550BBECC20bEd61B080c;
1094     
1095     //marks the timestamp of when the respective sales open
1096     uint256 internal presale1LaunchTime;
1097     uint256 internal presale2LaunchTime;
1098     uint256 internal whitelistLaunchTime;
1099     uint256 internal publicSaleLaunchTime;
1100 
1101     //amount of mints that each address has executed
1102     mapping(address => uint256) public mintsPerAddress;
1103     
1104     //current state os sale
1105     enum State {NoSale, Presale1, Presale2, WhitelistSale, PublicSale}
1106     
1107     //declaring initial values for variables
1108     constructor() ERC721('Digits Club', 'DC') {
1109         numberOfTotalTokens = 0;
1110         maxTotalTokens = 9999;
1111 
1112         _currentBaseURI = "ipfs://Qmf1fg9b6LkrFehZYNeNjPRNCQdqW6AMg59BeR8HfB7LBB/";
1113     }
1114     
1115     //in case somebody accidentaly sends funds or transaction to contract
1116     receive() payable external {}
1117     fallback() payable external {
1118         revert();
1119     }
1120     
1121     //visualize baseURI
1122     function _baseURI() internal view virtual override returns (string memory) {
1123         return _currentBaseURI;
1124     }
1125     
1126     //change baseURI in case needed for IPFS
1127     function changeBaseURI(string memory baseURI_) public onlyOwner {
1128         _currentBaseURI = baseURI_;
1129     }
1130     
1131     //gets the tokenID of NFT to be minted
1132     function tokenId() internal view returns(uint256) {
1133         uint currentId = totalSupply();
1134         bool exists = true;
1135         while (exists) {
1136             currentId += 1;
1137             exists = _exists(currentId);
1138         }
1139         
1140         return currentId;
1141     }
1142 
1143     function openPresale1() public onlyOwner {
1144         require(saleState() == State.NoSale, 'Current State has to be No Sale!');
1145         presale1LaunchTime = block.timestamp;
1146     }
1147 
1148     function openPresale2() public onlyOwner {
1149         require(saleState() == State.Presale1, 'Current State has to be Presale1!');
1150         presale2LaunchTime = block.timestamp;
1151     }
1152 
1153     function openWhitelist() public onlyOwner {
1154         require(saleState() == State.Presale2, 'Current State has to be Presale2!');
1155         whitelistLaunchTime = block.timestamp;
1156     }
1157 
1158     function openPublicSale() public onlyOwner {
1159         require(saleState() == State.WhitelistSale, 'Current State has to be Whitelist Sale!');
1160         publicSaleLaunchTime = block.timestamp;
1161     }
1162     
1163     modifier onlyValidAccess(uint8 _v, bytes32 _r, bytes32 _s) {
1164         require( isValidAccessMessage(msg.sender,_v,_r,_s), 'Invalid Signature' );
1165         _;
1166     }
1167  
1168     /* 
1169     * @dev Verifies if message was signed by owner to give access to _add for this contract.
1170     *      Assumes Geth signature prefix.
1171     * @param _add Address of agent with access
1172     * @param _v ECDSA signature parameter v.
1173     * @param _r ECDSA signature parameters r.
1174     * @param _s ECDSA signature parameters s.
1175     * @return Validity of access message for a given address.
1176     */
1177     function isValidAccessMessage(address _add, uint8 _v, bytes32 _r, bytes32 _s) view public returns (bool) {
1178         bytes32 hash = keccak256(abi.encodePacked(address(this), _add));
1179         return dummy == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), _v, _r, _s);
1180     }
1181     
1182     function presale1Mint(uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v,  _r, _s) public payable {
1183         State saleState_ = saleState();
1184         require(saleState_ == State.Presale1, "Sale in not open!");
1185         require(numberOfTokensPresale1 < maxTokensPresale1, "Not enough NFTs left to mint..");
1186         require(mintsPerAddress[msg.sender] == 0, "Maximum Mints per Address exceeded!");
1187 
1188         uint256 tid = tokenId();
1189         _safeMint(msg.sender, tid);
1190         mintsPerAddress[msg.sender] += 1;
1191         numberOfTotalTokens += 1;
1192         
1193 
1194     }
1195 
1196     //mint a @param number of NFTs in presale
1197     function presale2Mint(uint256 number, uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v,  _r, _s) public payable {
1198         State saleState_ = saleState();
1199         require(saleState_ == State.Presale2, "Sale in not open!");
1200         require(numberOfTokensPresale2 + number <= maxTokensPresale2, "Not enough NFTs left to mint..");
1201         require(mintsPerAddress[msg.sender] + number <= maxMint(), "Maximum Mints per Address exceeded!");
1202         require(msg.value >= mintCost() * number, "Not sufficient Ether to mint this amount of NFTs (Cost = 0.1 ether each NFT)");
1203         
1204         for (uint256 i = 0; i < number; i++) {
1205             uint256 tid = tokenId();
1206             _safeMint(msg.sender, tid);
1207             mintsPerAddress[msg.sender] += 1;
1208             numberOfTotalTokens += 1;
1209         }
1210 
1211     }
1212 
1213     //mint a @param number of NFTs in presale
1214     function whitelistMint(uint256 number, uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v,  _r, _s) public payable {
1215         State saleState_ = saleState();
1216         require(saleState_ == State.WhitelistSale, "Sale in not open!");
1217         require(numberOfTokensWhitelist + number <= maxTokensWhitelist, "Not enough NFTs left to mint..");
1218         require(mintsPerAddress[msg.sender] + number <= maxMint(), "Maximum Mints per Address exceeded!");
1219         require(msg.value >= mintCost() * number, "Not sufficient Ether to mint this amount of NFTs (Cost = 0.2 ether each NFT)");
1220         
1221         for (uint256 i = 0; i < number; i++) {
1222             uint256 tid = tokenId();
1223             _safeMint(msg.sender, tid);
1224             mintsPerAddress[msg.sender] += 1;
1225             numberOfTotalTokens += 1;
1226         }
1227 
1228     }
1229 
1230     //mint a @param number of NFTs in presale
1231     function publicSaleMint(uint256 number) public payable {
1232         State saleState_ = saleState();
1233         require(saleState_ == State.PublicSale, "Sale in not open!");
1234         require(numberOfTotalTokens + number <= maxTotalTokens - (maxReservedMintsMarketing + maxReservedMintsTeam - _reservedMintsMarketing - _reservedMintsTeam), "Not enough NFTs left to mint..");
1235         require(mintsPerAddress[msg.sender] + number <= maxMint(), "Maximum Mints per Address exceeded!");
1236         require(msg.value >= mintCost() * number, "Not sufficient Ether to mint this amount of NFTs (Cost = 0.25 ether each NFT)");
1237         
1238         for (uint256 i = 0; i < number; i++) {
1239             uint256 tid = tokenId();
1240             _safeMint(msg.sender, tid);
1241             mintsPerAddress[msg.sender] += 1;
1242             numberOfTotalTokens += 1;
1243         }
1244 
1245     }
1246     
1247     function tokenURI(uint256 tokenId_) public view virtual override returns (string memory) {
1248         require(_exists(tokenId_), "ERC721Metadata: URI query for nonexistent token");
1249         
1250         string memory baseURI = _baseURI();
1251         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId_.toString(), '.json')) : "";
1252            
1253     }
1254 
1255     //reserved mints for giveaways/team/marketing
1256     function reservedMintMarketing(uint256 number) public onlyOwner {
1257         require(_reservedMintsMarketing + number <= maxReservedMintsMarketing, "Not enough Reserved NFT left to mint..");
1258         for (uint256 i = 0; i < number; i++) {
1259             uint256 tid = tokenId();
1260             _safeMint(msg.sender, tid);
1261             mintsPerAddress[msg.sender] += 1;
1262             numberOfTotalTokens += 1;
1263             _reservedMintsMarketing += 1;
1264         }
1265     }
1266 
1267     //reserved mints for giveaways/team/marketing
1268     function reservedMintTeam(uint256 number) public onlyOwner {
1269         require(_reservedMintsTeam + number <= maxReservedMintsTeam, "Not enough Reserved NFT left to mint..");
1270         for (uint256 i = 0; i < number; i++) {
1271             uint256 tid = tokenId();
1272             _safeMint(msg.sender, tid);
1273             mintsPerAddress[msg.sender] += 1;
1274             numberOfTotalTokens += 1;
1275             _reservedMintsTeam += 1;
1276         }
1277     }
1278     
1279     //burn the tokens that have not been sold yet
1280     function burnTokens() public onlyOwner {
1281         maxTotalTokens = numberOfTotalTokens;
1282     }
1283     
1284     //se the current account balance
1285     function accountBalance() public onlyOwner view returns(uint) {
1286         return address(this).balance;
1287     }
1288     
1289     //retrieve all funds recieved from minting
1290     function withdraw() public onlyOwner {
1291         uint256 balance = accountBalance();
1292         require(balance > 0, 'No Funds to withdraw, Balance is 0');
1293 
1294         _withdraw(payable(owner()), accountBalance());  //to avoid dust eth
1295     }
1296     
1297     //send the percentage of funds to a shareholder´s wallet
1298     function _withdraw(address payable account, uint256 amount) internal {
1299         (bool sent, ) = account.call{value: amount}("");
1300         require(sent, "Failed to send Ether");
1301     }
1302     
1303     //change the dummy account used for signing transactions
1304     function changeDummy(address _dummy) public onlyOwner {
1305         dummy = _dummy;
1306     }
1307     
1308     //see the total amount of tokens that have been minted
1309     function totalSupply() public view returns(uint) {
1310         return numberOfTotalTokens;
1311     }
1312     
1313     //to see the total amount of reserved team mints left 
1314     function reservedMintsMarketingLeft() public view returns(uint) {
1315         return maxReservedMintsMarketing - _reservedMintsMarketing;
1316     }
1317 
1318     //to see the total amount of reserved giveaway mints left 
1319     function reservedMintsTeamLeft() public view returns(uint) {
1320         return maxReservedMintsTeam - _reservedMintsTeam;
1321     }
1322     
1323     //see current state of sale
1324     //see the current state of the sale
1325     function saleState() public view returns(State){
1326         if (presale1LaunchTime == 0) {
1327             return State.NoSale;
1328         }    
1329         else if (presale2LaunchTime == 0) {
1330             return State.Presale1;
1331         } 
1332         else if (whitelistLaunchTime == 0) {
1333             return State.Presale2;
1334         }
1335         else if (publicSaleLaunchTime == 0) {
1336             return State.WhitelistSale;
1337         }
1338         else {
1339             return State.PublicSale;
1340         }   
1341     }
1342     
1343     //gets the cost of current mint
1344     function mintCost() public view returns(uint) {
1345         State saleState_ = saleState();
1346         if (saleState_ == State.NoSale || saleState_ == State.Presale1) {
1347             return 0;
1348         }
1349         else if (saleState_ == State.Presale2) {
1350             return mintCostPresale2;
1351         }
1352         else if (saleState_ == State.WhitelistSale) {
1353             return mintCostWhitelistSale;
1354         }
1355         else {
1356             return mintCostPublicSale;
1357         }
1358     }
1359 
1360     //shows total amount of tokens that could be minted
1361     function maxTokens() public view returns(uint) {
1362         return maxTotalTokens;
1363     }
1364 
1365     //see what the current ma mint is
1366     function maxMint() public view returns(uint) {
1367         State saleState_ = saleState();
1368         if (saleState_ == State.NoSale || saleState_ == State.Presale1) {
1369             return maxMintPresale1;
1370         }
1371         else {
1372             return maxMintRest;
1373         }
1374     }
1375     
1376    
1377 }