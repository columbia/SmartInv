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
656 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
657     using Address for address;
658     using Strings for uint256;
659 
660     // Token name
661     string private _name;
662 
663     // Token symbol
664     string private _symbol;
665 
666     // Mapping from token ID to owner address
667     mapping(uint256 => address) private _owners;
668 
669     // Mapping owner address to token count
670     mapping(address => uint256) private _balances;
671 
672     // Mapping from token ID to approved address
673     mapping(uint256 => address) private _tokenApprovals;
674 
675     // Mapping from owner to operator approvals
676     mapping(address => mapping(address => bool)) private _operatorApprovals;
677     
678     //Mapping para atribuirle un URI para cada token
679     mapping(uint256 => string) internal id_to_URI;
680 
681     /**
682      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
683      */
684     constructor(string memory name_, string memory symbol_) {
685         _name = name_;
686         _symbol = symbol_;
687     }
688 
689     /**
690      * @dev See {IERC165-supportsInterface}.
691      */
692     
693     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
694         return
695             interfaceId == type(IERC721).interfaceId ||
696             interfaceId == type(IERC721Metadata).interfaceId ||
697             super.supportsInterface(interfaceId);
698     }
699     
700 
701     /**
702      * @dev See {IERC721-balanceOf}.
703      */
704     function balanceOf(address owner) public view virtual override returns (uint256) {
705         require(owner != address(0), "ERC721: balance query for the zero address");
706         return _balances[owner];
707     }
708 
709     /**
710      * @dev See {IERC721-ownerOf}.
711      */
712     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
713         address owner = _owners[tokenId];
714         require(owner != address(0), "ERC721: owner query for nonexistent token");
715         return owner;
716     }
717 
718     /**
719      * @dev See {IERC721Metadata-name}.
720      */
721     function name() public view virtual override returns (string memory) {
722         return _name;
723     }
724 
725     /**
726      * @dev See {IERC721Metadata-symbol}.
727      */
728     function symbol() public view virtual override returns (string memory) {
729         return _symbol;
730     }
731 
732     /**
733      * @dev See {IERC721Metadata-tokenURI}.
734      */
735     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {  }
736 
737     /**
738      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
739      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
740      * by default, can be overriden in child contracts.
741      */
742     function _baseURI() internal view virtual returns (string memory) {
743         return "";
744     }
745 
746     /**
747      * @dev See {IERC721-approve}.
748      */
749     function approve(address to, uint256 tokenId) public virtual override {
750         address owner = ERC721.ownerOf(tokenId);
751         require(to != owner, "ERC721: approval to current owner");
752 
753         require(
754             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
755             "ERC721: approve caller is not owner nor approved for all"
756         );
757 
758         _approve(to, tokenId);
759     }
760 
761     /**
762      * @dev See {IERC721-getApproved}.
763      */
764     function getApproved(uint256 tokenId) public view virtual override returns (address) {
765         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
766 
767         return _tokenApprovals[tokenId];
768     }
769 
770     /**
771      * @dev See {IERC721-setApprovalForAll}.
772      */
773     function setApprovalForAll(address operator, bool approved) public virtual override {
774         require(operator != _msgSender(), "ERC721: approve to caller");
775 
776         _operatorApprovals[_msgSender()][operator] = approved;
777         emit ApprovalForAll(_msgSender(), operator, approved);
778     }
779 
780     /**
781      * @dev See {IERC721-isApprovedForAll}.
782      */
783     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
784         return _operatorApprovals[owner][operator];
785     }
786 
787     /**
788      * @dev See {IERC721-transferFrom}.
789      */
790     function transferFrom(
791         address from,
792         address to,
793         uint256 tokenId
794     ) public virtual override {
795         //solhint-disable-next-line max-line-length
796         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
797 
798         _transfer(from, to, tokenId);
799     }
800 
801     /**
802      * @dev See {IERC721-safeTransferFrom}.
803      */
804     function safeTransferFrom(
805         address from,
806         address to,
807         uint256 tokenId
808     ) public virtual override {
809         safeTransferFrom(from, to, tokenId, "");
810     }
811 
812     /**
813      * @dev See {IERC721-safeTransferFrom}.
814      */
815     function safeTransferFrom(
816         address from,
817         address to,
818         uint256 tokenId,
819         bytes memory _data
820     ) public virtual override {
821         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
822         _safeTransfer(from, to, tokenId, _data);
823     }
824 
825     /**
826      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
827      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
828      *
829      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
830      *
831      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
832      * implement alternative mechanisms to perform token transfer, such as signature-based.
833      *
834      * Requirements:
835      *
836      * - `from` cannot be the zero address.
837      * - `to` cannot be the zero address.
838      * - `tokenId` token must exist and be owned by `from`.
839      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
840      *
841      * Emits a {Transfer} event.
842      */
843     function _safeTransfer(
844         address from,
845         address to,
846         uint256 tokenId,
847         bytes memory _data
848     ) internal virtual {
849         _transfer(from, to, tokenId);
850         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
851     }
852 
853     /**
854      * @dev Returns whether `tokenId` exists.
855      *
856      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
857      *
858      * Tokens start existing when they are minted (`_mint`),
859      * and stop existing when they are burned (`_burn`).
860      */
861     function _exists(uint256 tokenId) internal view virtual returns (bool) {
862         return _owners[tokenId] != address(0);
863     }
864 
865     /**
866      * @dev Returns whether `spender` is allowed to manage `tokenId`.
867      *
868      * Requirements:
869      *
870      * - `tokenId` must exist.
871      */
872     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
873         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
874         address owner = ERC721.ownerOf(tokenId);
875         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
876     }
877 
878     /**
879      * @dev Safely mints `tokenId` and transfers it to `to`.
880      *
881      * Requirements:
882      *
883      * - `tokenId` must not exist.
884      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _safeMint(address to, uint256 tokenId) internal virtual {
889         _safeMint(to, tokenId, "");
890     }
891 
892     /**
893      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
894      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
895      */
896     function _safeMint(
897         address to,
898         uint256 tokenId,
899         bytes memory _data
900     ) internal virtual {
901         _mint(to, tokenId);
902         require(
903             _checkOnERC721Received(address(0), to, tokenId, _data),
904             "ERC721: transfer to non ERC721Receiver implementer"
905         );
906     }
907 
908     /**
909      * @dev Mints `tokenId` and transfers it to `to`.
910      *
911      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
912      *
913      * Requirements:
914      *
915      * - `tokenId` must not exist.
916      * - `to` cannot be the zero address.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _mint(address to, uint256 tokenId) internal virtual {
921         require(to != address(0), "ERC721: mint to the zero address");
922         require(!_exists(tokenId), "ERC721: token already minted");
923 
924         _beforeTokenTransfer(address(0), to, tokenId);
925 
926         _balances[to] += 1;
927         _owners[tokenId] = to;
928 
929         emit Transfer(address(0), to, tokenId);
930     }
931 
932     /**
933      * @dev Destroys `tokenId`.
934      * The approval is cleared when the token is burned.
935      *
936      * Requirements:
937      *
938      * - `tokenId` must exist.
939      *
940      * Emits a {Transfer} event.
941      */
942     function _burn(uint256 tokenId) internal virtual {
943         address owner = ERC721.ownerOf(tokenId);
944 
945         _beforeTokenTransfer(owner, address(0), tokenId);
946 
947         // Clear approvals
948         _approve(address(0), tokenId);
949 
950         _balances[owner] -= 1;
951         delete _owners[tokenId];
952 
953         emit Transfer(owner, address(0), tokenId);
954     }
955 
956     /**
957      * @dev Transfers `tokenId` from `from` to `to`.
958      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
959      *
960      * Requirements:
961      *
962      * - `to` cannot be the zero address.
963      * - `tokenId` token must be owned by `from`.
964      *
965      * Emits a {Transfer} event.
966      */
967     function _transfer(
968         address from,
969         address to,
970         uint256 tokenId
971     ) internal virtual {
972         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
973         require(to != address(0), "ERC721: transfer to the zero address");
974 
975         _beforeTokenTransfer(from, to, tokenId);
976 
977         // Clear approvals from the previous owner
978         _approve(address(0), tokenId);
979 
980         _balances[from] -= 1;
981         _balances[to] += 1;
982         _owners[tokenId] = to;
983 
984         emit Transfer(from, to, tokenId);
985     }
986 
987     /**
988      * @dev Approve `to` to operate on `tokenId`
989      *
990      * Emits a {Approval} event.
991      */
992     function _approve(address to, uint256 tokenId) internal virtual {
993         _tokenApprovals[tokenId] = to;
994         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
995     }
996 
997     /**
998      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
999      * The call is not executed if the target address is not a contract.
1000      *
1001      * @param from address representing the previous owner of the given token ID
1002      * @param to target address that will receive the tokens
1003      * @param tokenId uint256 ID of the token to be transferred
1004      * @param _data bytes optional data to send along with the call
1005      * @return bool whether the call correctly returned the expected magic value
1006      */
1007     function _checkOnERC721Received(
1008         address from,
1009         address to,
1010         uint256 tokenId,
1011         bytes memory _data
1012     ) private returns (bool) {
1013         if (to.isContract()) {
1014             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1015                 return retval == IERC721Receiver.onERC721Received.selector;
1016             } catch (bytes memory reason) {
1017                 if (reason.length == 0) {
1018                     revert("ERC721: transfer to non ERC721Receiver implementer");
1019                 } else {
1020                     assembly {
1021                         revert(add(32, reason), mload(reason))
1022                     }
1023                 }
1024             }
1025         } else {
1026             return true;
1027         }
1028     }
1029 
1030     /**
1031      * @dev Hook that is called before any token transfer. This includes minting
1032      * and burning.
1033      *
1034      * Calling conditions:
1035      *
1036      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1037      * transferred to `to`.
1038      * - When `from` is zero, `tokenId` will be minted for `to`.
1039      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1040      * - `from` and `to` are never both zero.
1041      *
1042      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1043      */
1044     function _beforeTokenTransfer(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) internal virtual {}
1049 }
1050 
1051 contract nft is ERC721, Ownable {
1052     using Strings for uint256;
1053 
1054     //amount of tokens that have been minted so far, in total and in presale
1055     uint256 private numberOfTotalTokens;
1056     
1057     //declares the maximum amount of tokens that can be minted, total and in presale
1058     uint256 private maxTotalTokens;
1059     
1060     //initial part of the URI for the metadata
1061     string private _currentBaseURI;
1062         
1063     //cost of mints depending on state of sale    
1064     uint private mintCost_ = 0.15 ether;
1065     
1066     //maximum amount of mints per wallet
1067     uint public maxMint;
1068     
1069     //the amount of reserved mints that have currently been executed by creator and by marketing wallet
1070     uint private _reservedMints = 0;
1071     
1072     //the maximum amount of reserved mints allowed for creator and marketing wallet
1073     uint private maxReservedMints = 250;
1074     
1075     //dummy address that we use to sign the mint transaction to make sure it is valid
1076     address private dummy = 0x80E4929c869102140E69550BBECC20bEd61B080c;
1077 
1078     //developers wallet address
1079     address payable private dev = payable(0x318cBF186eB13C74533943b054959867eE44eFFE);
1080 
1081     //amount of mints that each address has executed
1082     mapping(address => uint256) public mintsPerAddress;
1083     
1084     //current state os sale
1085     enum State {NoSale, Presale, PublicSale}
1086 
1087     //defines the uri for when the NFTs have not been yet revealed
1088     string public unrevealedURI;
1089     
1090     //marks the timestamp of when the respective sales open
1091     uint256 public presaleLaunchTime;
1092     uint256 public publicSaleLaunchTime;
1093     uint256 public revealTime;
1094     
1095     //declaring initial values for variables
1096     constructor() ERC721('The Companion', 'TC'){
1097         numberOfTotalTokens = 0;
1098         
1099         maxTotalTokens = 8888;
1100         maxMint = 10;
1101 
1102         unrevealedURI = "ipfs://QmeiF5rT5mR8tQA9gHxcYHGoEUev7UnTgB3TWRRGkuE2Ca/";
1103     }
1104     
1105     //in case somebody accidentaly sends funds or transaction to contract
1106     receive() payable external {}
1107     fallback() payable external {
1108         revert();
1109     }
1110     
1111     //visualize baseURI
1112     function _baseURI() internal view virtual override returns (string memory) {
1113         return _currentBaseURI;
1114     }
1115     
1116     //change baseURI in case needed for IPFS
1117     function changeBaseURI(string memory baseURI_) public onlyOwner {
1118         _currentBaseURI = baseURI_;
1119     }
1120     
1121     function changeUnrevealedURI(string memory unrevealedURI_) public onlyOwner {
1122         unrevealedURI = unrevealedURI_;
1123     }
1124     
1125     //gets the tokenID of NFT to be minted
1126     function tokenId() internal view returns(uint256) {
1127         return numberOfTotalTokens + 1;
1128     }
1129     
1130     modifier onlyValidAccess(uint8 _v, bytes32 _r, bytes32 _s) {
1131         require( isValidAccessMessage(msg.sender,_v,_r,_s), 'Invalid Signature' );
1132         _;
1133     }
1134  
1135     /* 
1136     * @dev Verifies if message was signed by owner to give access to _add for this contract.
1137     *      Assumes Geth signature prefix.
1138     * @param _add Address of agent with access
1139     * @param _v ECDSA signature parameter v.
1140     * @param _r ECDSA signature parameters r.
1141     * @param _s ECDSA signature parameters s.
1142     * @return Validity of access message for a given address.
1143     */
1144     function isValidAccessMessage(address _add, uint8 _v, bytes32 _r, bytes32 _s) view public returns (bool) {
1145         bytes32 hash = keccak256(abi.encodePacked(address(this), _add));
1146         return dummy == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), _v, _r, _s);
1147     }
1148     
1149     //mint a @param number of NFTs in presale
1150     function presaleMint(uint256 number, uint8 _v, bytes32 _r, bytes32 _s) onlyValidAccess(_v,  _r, _s) public payable {
1151         State saleState_ = saleState();
1152         require(saleState_ != State.NoSale, "Sale in not open yet!");
1153         require(saleState_ != State.PublicSale, "Presale has closed, Check out Public Sale!");
1154         require(numberOfTotalTokens + number <= maxTotalTokens - (maxReservedMints  - _reservedMints), "Not enough NFTs left to mint..");
1155         require(mintsPerAddress[msg.sender] + number <= maxMint, "Maximum 10 Mints per Address allowed!");
1156         require(msg.value >= mintCost() * number, "Not sufficient Ether to mint this amount of NFTs (Cost = 0.15 ether each NFT)");
1157         
1158         for (uint256 i = 0; i < number; i++) {
1159             uint256 tid = tokenId();
1160             _safeMint(msg.sender, tid);
1161             mintsPerAddress[msg.sender] += 1;
1162             numberOfTotalTokens += 1;
1163         }
1164 
1165     }
1166 
1167     //mint a @param number of NFTs in public sale
1168     function publicSaleMint(uint256 number) public payable {
1169         State saleState_ = saleState();
1170         require(saleState_ == State.PublicSale, "Public Sale in not open yet!");
1171         require(numberOfTotalTokens + number <= maxTotalTokens - (maxReservedMints - _reservedMints), "Not enough NFTs left to mint..");
1172         require(mintsPerAddress[msg.sender] + number <= maxMint, "Maximum 10 Mints per Address allowed!");
1173         require(msg.value >= mintCost() * number, "Not sufficient Ether to mint this amount of NFTs (Cost = 0.15 ether for each NFT)");
1174 
1175 
1176         for (uint256 i = 0; i < number; i++) {
1177             uint256 tid = tokenId();
1178             _safeMint(msg.sender, tid);
1179             mintsPerAddress[msg.sender] += 1;
1180             numberOfTotalTokens += 1;
1181         }
1182     }
1183     
1184     //reserved NFTs for creator
1185     function reservedMints(uint256 number, address recipient) public onlyOwner {
1186         require(_reservedMints + number <= maxReservedMints, "Not enough Reserved NFTs for Creator left to mint..");
1187         for (uint256 i = 0; i < number; i++) {
1188             uint256 tid = tokenId();
1189             _safeMint(recipient, tid);
1190             mintsPerAddress[recipient] += 1;
1191             numberOfTotalTokens += 1;
1192         }
1193     }
1194 
1195     function tokenURI(uint256 tokenId_) public view virtual override returns (string memory) {
1196         require(_exists(tokenId_), "ERC721Metadata: URI query for nonexistent token");
1197         
1198         //check to see that 24 hours have passed since beginning of publicsale launch
1199         if (revealTime == 0) {
1200             return unrevealedURI;
1201         }
1202         
1203         else {
1204             string memory baseURI = _baseURI();
1205             return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId_.toString(), '.json')) : "";
1206         }    
1207     }
1208     
1209     //begins the minting of the NFTs
1210     function switchToPresale() public onlyOwner{
1211         State saleState_ = saleState();
1212         require(saleState_ == State.NoSale, "Presale has already opened!");
1213         presaleLaunchTime = block.timestamp;
1214     }
1215     
1216     //begins the public sale
1217     function switchToPublicSale() public onlyOwner {
1218         State saleState_ = saleState();
1219         require(saleState_ != State.PublicSale, "Public Sale is already live!");
1220         require(saleState_ != State.NoSale, "Cannot change to Public Sale if there has not been a Presale!");
1221         
1222         publicSaleLaunchTime = block.timestamp;
1223     }
1224 
1225     
1226     //burn the tokens that have not been sold yet
1227     function burnTokens() public onlyOwner {
1228         maxTotalTokens = numberOfTotalTokens;
1229     }
1230     
1231     //se the current account balance
1232     function accountBalance() public onlyOwner view returns(uint) {
1233         return address(this).balance;
1234     }
1235     
1236     //change the dummy account used for signing transactions
1237     function changeDummy(address _dummy) public onlyOwner {
1238         dummy = _dummy;
1239     }
1240     
1241     //see the total amount of tokens that have been minted
1242     function totalSupply() public view returns(uint) {
1243         return numberOfTotalTokens;
1244     }
1245     
1246     //see the total amount of reserved mints that are left creator
1247     function reservedMintsLeft() public onlyOwner view returns(uint) {
1248         return maxReservedMints - _reservedMints;
1249     }
1250     
1251     //get the funds from the minting of the NFTs
1252     function retrieveFunds() public onlyOwner {
1253         uint256 balance = accountBalance();
1254         require(balance > 0, "No funds to retrieve!");
1255 
1256         _withdraw(dev, (balance * 5)/1000);
1257         _withdraw(payable(msg.sender), accountBalance()); //to avoid dust eth
1258         
1259     }
1260 
1261     function _withdraw(address payable account, uint256 amount) internal {
1262         (bool sent, ) = account.call{value: amount}("");
1263         require(sent, "Failed to send Ether");
1264     }
1265 
1266     //see the current state of the sale
1267     function saleState() public view returns(State){
1268         if (presaleLaunchTime == 0) {
1269             return State.NoSale;
1270         }
1271         else if (publicSaleLaunchTime == 0) {
1272             return State.Presale;
1273         }
1274         else {
1275             return State.PublicSale;
1276         }
1277     }
1278 
1279     //get the current price to mint
1280     function mintCost() public view returns(uint256) {
1281         return mintCost_;
1282     }
1283 
1284     //change the current price to mint
1285     function changeMintCost(uint newCost) public onlyOwner {
1286         mintCost_ = newCost;
1287     }
1288 
1289     //reveal the NFTs
1290     function reveal() public onlyOwner {
1291         revealTime = block.timestamp;
1292     }
1293 
1294 }