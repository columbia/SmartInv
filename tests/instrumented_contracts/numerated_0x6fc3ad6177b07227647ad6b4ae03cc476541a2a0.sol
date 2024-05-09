1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 
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
99 
100 
101 pragma solidity ^0.8.0;
102 
103 
104 /**
105  * @dev Contract module which provides a basic access control mechanism, where
106  * there is an account (an owner) that can be granted exclusive access to
107  * specific functions.
108  *
109  * By default, the owner account will be the one that deploys the contract. This
110  * can later be changed with {transferOwnership}.
111  *
112  * This module is used through inheritance. It will make available the modifier
113  * `onlyOwner`, which can be applied to your functions to restrict their use to
114  * the owner.
115  */
116 abstract contract Ownable is Context {
117     address private _owner;
118 
119     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
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
159         require(newOwner != address(0), "Ownable: new owner is the zero address");
160         _setOwner(newOwner);
161     }
162 
163     function _setOwner(address newOwner) private {
164         address oldOwner = _owner;
165         _owner = newOwner;
166         emit OwnershipTransferred(oldOwner, newOwner);
167     }
168 }
169 
170 // File: @openzeppelin/contracts/utils/Address.sol
171 
172 
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
226         require(address(this).balance >= amount, "Address: insufficient balance");
227 
228         (bool success, ) = recipient.call{value: amount}("");
229         require(success, "Address: unable to send value, recipient may have reverted");
230     }
231 
232     /**
233      * @dev Performs a Solidity function call using a low level `call`. A
234      * plain `call` is an unsafe replacement for a function call: use this
235      * function instead.
236      *
237      * If `target` reverts with a revert reason, it is bubbled up by this
238      * function (like regular Solidity function calls).
239      *
240      * Returns the raw returned data. To convert to the expected return value,
241      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
242      *
243      * Requirements:
244      *
245      * - `target` must be a contract.
246      * - calling `target` with `data` must not revert.
247      *
248      * _Available since v3.1._
249      */
250     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
251         return functionCall(target, data, "Address: low-level call failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
256      * `errorMessage` as a fallback revert reason when `target` reverts.
257      *
258      * _Available since v3.1._
259      */
260     function functionCall(
261         address target,
262         bytes memory data,
263         string memory errorMessage
264     ) internal returns (bytes memory) {
265         return functionCallWithValue(target, data, 0, errorMessage);
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
270      * but also transferring `value` wei to `target`.
271      *
272      * Requirements:
273      *
274      * - the calling contract must have an ETH balance of at least `value`.
275      * - the called Solidity function must be `payable`.
276      *
277      * _Available since v3.1._
278      */
279     function functionCallWithValue(
280         address target,
281         bytes memory data,
282         uint256 value
283     ) internal returns (bytes memory) {
284         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
289      * with `errorMessage` as a fallback revert reason when `target` reverts.
290      *
291      * _Available since v3.1._
292      */
293     function functionCallWithValue(
294         address target,
295         bytes memory data,
296         uint256 value,
297         string memory errorMessage
298     ) internal returns (bytes memory) {
299         require(address(this).balance >= value, "Address: insufficient balance for call");
300         require(isContract(target), "Address: call to non-contract");
301 
302         (bool success, bytes memory returndata) = target.call{value: value}(data);
303         return verifyCallResult(success, returndata, errorMessage);
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
308      * but performing a static call.
309      *
310      * _Available since v3.3._
311      */
312     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
313         return functionStaticCall(target, data, "Address: low-level static call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
318      * but performing a static call.
319      *
320      * _Available since v3.3._
321      */
322     function functionStaticCall(
323         address target,
324         bytes memory data,
325         string memory errorMessage
326     ) internal view returns (bytes memory) {
327         require(isContract(target), "Address: static call to non-contract");
328 
329         (bool success, bytes memory returndata) = target.staticcall(data);
330         return verifyCallResult(success, returndata, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but performing a delegate call.
336      *
337      * _Available since v3.4._
338      */
339     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
340         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
345      * but performing a delegate call.
346      *
347      * _Available since v3.4._
348      */
349     function functionDelegateCall(
350         address target,
351         bytes memory data,
352         string memory errorMessage
353     ) internal returns (bytes memory) {
354         require(isContract(target), "Address: delegate call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.delegatecall(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
362      * revert reason using the provided one.
363      *
364      * _Available since v4.3._
365      */
366     function verifyCallResult(
367         bool success,
368         bytes memory returndata,
369         string memory errorMessage
370     ) internal pure returns (bytes memory) {
371         if (success) {
372             return returndata;
373         } else {
374             // Look for revert reason and bubble it up if present
375             if (returndata.length > 0) {
376                 // The easiest way to bubble the revert reason is using memory via assembly
377 
378                 assembly {
379                     let returndata_size := mload(returndata)
380                     revert(add(32, returndata), returndata_size)
381                 }
382             } else {
383                 revert(errorMessage);
384             }
385         }
386     }
387 }
388 
389 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
390 
391 
392 
393 pragma solidity ^0.8.0;
394 
395 /**
396  * @title ERC721 token receiver interface
397  * @dev Interface for any contract that wants to support safeTransfers
398  * from ERC721 asset contracts.
399  */
400 interface IERC721Receiver {
401     /**
402      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
403      * by `operator` from `from`, this function is called.
404      *
405      * It must return its Solidity selector to confirm the token transfer.
406      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
407      *
408      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
409      */
410     function onERC721Received(
411         address operator,
412         address from,
413         uint256 tokenId,
414         bytes calldata data
415     ) external returns (bytes4);
416 }
417 
418 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
419 
420 
421 
422 pragma solidity ^0.8.0;
423 
424 /**
425  * @dev Interface of the ERC165 standard, as defined in the
426  * https://eips.ethereum.org/EIPS/eip-165[EIP].
427  *
428  * Implementers can declare support of contract interfaces, which can then be
429  * queried by others ({ERC165Checker}).
430  *
431  * For an implementation, see {ERC165}.
432  */
433 interface IERC165 {
434     /**
435      * @dev Returns true if this contract implements the interface defined by
436      * `interfaceId`. See the corresponding
437      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
438      * to learn more about how these ids are created.
439      *
440      * This function call must use less than 30 000 gas.
441      */
442     function supportsInterface(bytes4 interfaceId) external view returns (bool);
443 }
444 
445 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
446 
447 
448 
449 pragma solidity ^0.8.0;
450 
451 
452 /**
453  * @dev Implementation of the {IERC165} interface.
454  *
455  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
456  * for the additional interface id that will be supported. For example:
457  *
458  * ```solidity
459  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
460  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
461  * }
462  * ```
463  *
464  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
465  */
466 abstract contract ERC165 is IERC165 {
467     /**
468      * @dev See {IERC165-supportsInterface}.
469      */
470     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
471         return interfaceId == type(IERC165).interfaceId;
472     }
473 }
474 
475 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
476 
477 
478 
479 pragma solidity ^0.8.0;
480 
481 
482 /**
483  * @dev Required interface of an ERC721 compliant contract.
484  */
485 interface IERC721 is IERC165 {
486     /**
487      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
488      */
489     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
490 
491     /**
492      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
493      */
494     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
495 
496     /**
497      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
498      */
499     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
500 
501     /**
502      * @dev Returns the number of tokens in ``owner``'s account.
503      */
504     function balanceOf(address owner) external view returns (uint256 balance);
505 
506     /**
507      * @dev Returns the owner of the `tokenId` token.
508      *
509      * Requirements:
510      *
511      * - `tokenId` must exist.
512      */
513     function ownerOf(uint256 tokenId) external view returns (address owner);
514 
515     /**
516      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
517      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
518      *
519      * Requirements:
520      *
521      * - `from` cannot be the zero address.
522      * - `to` cannot be the zero address.
523      * - `tokenId` token must exist and be owned by `from`.
524      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
525      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
526      *
527      * Emits a {Transfer} event.
528      */
529     function safeTransferFrom(
530         address from,
531         address to,
532         uint256 tokenId
533     ) external;
534 
535     /**
536      * @dev Transfers `tokenId` token from `from` to `to`.
537      *
538      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
539      *
540      * Requirements:
541      *
542      * - `from` cannot be the zero address.
543      * - `to` cannot be the zero address.
544      * - `tokenId` token must be owned by `from`.
545      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
546      *
547      * Emits a {Transfer} event.
548      */
549     function transferFrom(
550         address from,
551         address to,
552         uint256 tokenId
553     ) external;
554 
555     /**
556      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
557      * The approval is cleared when the token is transferred.
558      *
559      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
560      *
561      * Requirements:
562      *
563      * - The caller must own the token or be an approved operator.
564      * - `tokenId` must exist.
565      *
566      * Emits an {Approval} event.
567      */
568     function approve(address to, uint256 tokenId) external;
569 
570     /**
571      * @dev Returns the account approved for `tokenId` token.
572      *
573      * Requirements:
574      *
575      * - `tokenId` must exist.
576      */
577     function getApproved(uint256 tokenId) external view returns (address operator);
578 
579     /**
580      * @dev Approve or remove `operator` as an operator for the caller.
581      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
582      *
583      * Requirements:
584      *
585      * - The `operator` cannot be the caller.
586      *
587      * Emits an {ApprovalForAll} event.
588      */
589     function setApprovalForAll(address operator, bool _approved) external;
590 
591     /**
592      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
593      *
594      * See {setApprovalForAll}
595      */
596     function isApprovedForAll(address owner, address operator) external view returns (bool);
597 
598     /**
599      * @dev Safely transfers `tokenId` token from `from` to `to`.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must exist and be owned by `from`.
606      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
607      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
608      *
609      * Emits a {Transfer} event.
610      */
611     function safeTransferFrom(
612         address from,
613         address to,
614         uint256 tokenId,
615         bytes calldata data
616     ) external;
617 }
618 
619 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
620 
621 
622 
623 pragma solidity ^0.8.0;
624 
625 
626 /**
627  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
628  * @dev See https://eips.ethereum.org/EIPS/eip-721
629  */
630 interface IERC721Enumerable is IERC721 {
631     /**
632      * @dev Returns the total amount of tokens stored by the contract.
633      */
634     function totalSupply() external view returns (uint256);
635 
636     /**
637      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
638      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
639      */
640     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
641 
642     /**
643      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
644      * Use along with {totalSupply} to enumerate all tokens.
645      */
646     function tokenByIndex(uint256 index) external view returns (uint256);
647 }
648 
649 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
650 
651 
652 
653 pragma solidity ^0.8.0;
654 
655 
656 /**
657  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
658  * @dev See https://eips.ethereum.org/EIPS/eip-721
659  */
660 interface IERC721Metadata is IERC721 {
661     /**
662      * @dev Returns the token collection name.
663      */
664     function name() external view returns (string memory);
665 
666     /**
667      * @dev Returns the token collection symbol.
668      */
669     function symbol() external view returns (string memory);
670 
671     /**
672      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
673      */
674     function tokenURI(uint256 tokenId) external view returns (string memory);
675 }
676 
677 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
678 
679 
680 
681 pragma solidity ^0.8.0;
682 
683 
684 
685 
686 
687 
688 
689 
690 /**
691  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
692  * the Metadata extension, but not including the Enumerable extension, which is available separately as
693  * {ERC721Enumerable}.
694  */
695 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
696     using Address for address;
697     using Strings for uint256;
698 
699     // Token name
700     string private _name;
701 
702     // Token symbol
703     string private _symbol;
704 
705     // Mapping from token ID to owner address
706     mapping(uint256 => address) private _owners;
707 
708     // Mapping owner address to token count
709     mapping(address => uint256) private _balances;
710 
711     // Mapping from token ID to approved address
712     mapping(uint256 => address) private _tokenApprovals;
713 
714     // Mapping from owner to operator approvals
715     mapping(address => mapping(address => bool)) private _operatorApprovals;
716 
717     /**
718      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
719      */
720     constructor(string memory name_, string memory symbol_) {
721         _name = name_;
722         _symbol = symbol_;
723     }
724 
725     /**
726      * @dev See {IERC165-supportsInterface}.
727      */
728     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
729         return
730             interfaceId == type(IERC721).interfaceId ||
731             interfaceId == type(IERC721Metadata).interfaceId ||
732             super.supportsInterface(interfaceId);
733     }
734 
735     /**
736      * @dev See {IERC721-balanceOf}.
737      */
738     function balanceOf(address owner) public view virtual override returns (uint256) {
739         require(owner != address(0), "ERC721: balance query for the zero address");
740         return _balances[owner];
741     }
742 
743     /**
744      * @dev See {IERC721-ownerOf}.
745      */
746     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
747         address owner = _owners[tokenId];
748         require(owner != address(0), "ERC721: owner query for nonexistent token");
749         return owner;
750     }
751 
752     /**
753      * @dev See {IERC721Metadata-name}.
754      */
755     function name() public view virtual override returns (string memory) {
756         return _name;
757     }
758 
759     /**
760      * @dev See {IERC721Metadata-symbol}.
761      */
762     function symbol() public view virtual override returns (string memory) {
763         return _symbol;
764     }
765 
766     /**
767      * @dev See {IERC721Metadata-tokenURI}.
768      */
769     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
770         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
771 
772         string memory baseURI = _baseURI();
773         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
774     }
775 
776     /**
777      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
778      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
779      * by default, can be overriden in child contracts.
780      */
781     function _baseURI() internal view virtual returns (string memory) {
782         return "";
783     }
784 
785     /**
786      * @dev See {IERC721-approve}.
787      */
788     function approve(address to, uint256 tokenId) public virtual override {
789         address owner = ERC721.ownerOf(tokenId);
790         require(to != owner, "ERC721: approval to current owner");
791 
792         require(
793             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
794             "ERC721: approve caller is not owner nor approved for all"
795         );
796 
797         _approve(to, tokenId);
798     }
799 
800     /**
801      * @dev See {IERC721-getApproved}.
802      */
803     function getApproved(uint256 tokenId) public view virtual override returns (address) {
804         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
805 
806         return _tokenApprovals[tokenId];
807     }
808 
809     /**
810      * @dev See {IERC721-setApprovalForAll}.
811      */
812     function setApprovalForAll(address operator, bool approved) public virtual override {
813         require(operator != _msgSender(), "ERC721: approve to caller");
814 
815         _operatorApprovals[_msgSender()][operator] = approved;
816         emit ApprovalForAll(_msgSender(), operator, approved);
817     }
818 
819     /**
820      * @dev See {IERC721-isApprovedForAll}.
821      */
822     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
823         return _operatorApprovals[owner][operator];
824     }
825 
826     /**
827      * @dev See {IERC721-transferFrom}.
828      */
829     function transferFrom(
830         address from,
831         address to,
832         uint256 tokenId
833     ) public virtual override {
834         //solhint-disable-next-line max-line-length
835         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
836 
837         _transfer(from, to, tokenId);
838     }
839 
840     /**
841      * @dev See {IERC721-safeTransferFrom}.
842      */
843     function safeTransferFrom(
844         address from,
845         address to,
846         uint256 tokenId
847     ) public virtual override {
848         safeTransferFrom(from, to, tokenId, "");
849     }
850 
851     /**
852      * @dev See {IERC721-safeTransferFrom}.
853      */
854     function safeTransferFrom(
855         address from,
856         address to,
857         uint256 tokenId,
858         bytes memory _data
859     ) public virtual override {
860         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
861         _safeTransfer(from, to, tokenId, _data);
862     }
863 
864     /**
865      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
866      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
867      *
868      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
869      *
870      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
871      * implement alternative mechanisms to perform token transfer, such as signature-based.
872      *
873      * Requirements:
874      *
875      * - `from` cannot be the zero address.
876      * - `to` cannot be the zero address.
877      * - `tokenId` token must exist and be owned by `from`.
878      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
879      *
880      * Emits a {Transfer} event.
881      */
882     function _safeTransfer(
883         address from,
884         address to,
885         uint256 tokenId,
886         bytes memory _data
887     ) internal virtual {
888         _transfer(from, to, tokenId);
889         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
890     }
891 
892     /**
893      * @dev Returns whether `tokenId` exists.
894      *
895      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
896      *
897      * Tokens start existing when they are minted (`_mint`),
898      * and stop existing when they are burned (`_burn`).
899      */
900     function _exists(uint256 tokenId) internal view virtual returns (bool) {
901         return _owners[tokenId] != address(0);
902     }
903 
904     /**
905      * @dev Returns whether `spender` is allowed to manage `tokenId`.
906      *
907      * Requirements:
908      *
909      * - `tokenId` must exist.
910      */
911     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
912         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
913         address owner = ERC721.ownerOf(tokenId);
914         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
915     }
916 
917     /**
918      * @dev Safely mints `tokenId` and transfers it to `to`.
919      *
920      * Requirements:
921      *
922      * - `tokenId` must not exist.
923      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _safeMint(address to, uint256 tokenId) internal virtual {
928         _safeMint(to, tokenId, "");
929     }
930 
931     /**
932      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
933      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
934      */
935     function _safeMint(
936         address to,
937         uint256 tokenId,
938         bytes memory _data
939     ) internal virtual {
940         _mint(to, tokenId);
941         require(
942             _checkOnERC721Received(address(0), to, tokenId, _data),
943             "ERC721: transfer to non ERC721Receiver implementer"
944         );
945     }
946 
947     /**
948      * @dev Mints `tokenId` and transfers it to `to`.
949      *
950      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
951      *
952      * Requirements:
953      *
954      * - `tokenId` must not exist.
955      * - `to` cannot be the zero address.
956      *
957      * Emits a {Transfer} event.
958      */
959     function _mint(address to, uint256 tokenId) internal virtual {
960         require(to != address(0), "ERC721: mint to the zero address");
961         require(!_exists(tokenId), "ERC721: token already minted");
962 
963         _beforeTokenTransfer(address(0), to, tokenId);
964 
965         _balances[to] += 1;
966         _owners[tokenId] = to;
967 
968         emit Transfer(address(0), to, tokenId);
969     }
970 
971     /**
972      * @dev Destroys `tokenId`.
973      * The approval is cleared when the token is burned.
974      *
975      * Requirements:
976      *
977      * - `tokenId` must exist.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _burn(uint256 tokenId) internal virtual {
982         address owner = ERC721.ownerOf(tokenId);
983 
984         _beforeTokenTransfer(owner, address(0), tokenId);
985 
986         // Clear approvals
987         _approve(address(0), tokenId);
988 
989         _balances[owner] -= 1;
990         delete _owners[tokenId];
991 
992         emit Transfer(owner, address(0), tokenId);
993     }
994 
995     /**
996      * @dev Transfers `tokenId` from `from` to `to`.
997      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
998      *
999      * Requirements:
1000      *
1001      * - `to` cannot be the zero address.
1002      * - `tokenId` token must be owned by `from`.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _transfer(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) internal virtual {
1011         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1012         require(to != address(0), "ERC721: transfer to the zero address");
1013 
1014         _beforeTokenTransfer(from, to, tokenId);
1015 
1016         // Clear approvals from the previous owner
1017         _approve(address(0), tokenId);
1018 
1019         _balances[from] -= 1;
1020         _balances[to] += 1;
1021         _owners[tokenId] = to;
1022 
1023         emit Transfer(from, to, tokenId);
1024     }
1025 
1026     /**
1027      * @dev Approve `to` to operate on `tokenId`
1028      *
1029      * Emits a {Approval} event.
1030      */
1031     function _approve(address to, uint256 tokenId) internal virtual {
1032         _tokenApprovals[tokenId] = to;
1033         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1034     }
1035 
1036     /**
1037      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1038      * The call is not executed if the target address is not a contract.
1039      *
1040      * @param from address representing the previous owner of the given token ID
1041      * @param to target address that will receive the tokens
1042      * @param tokenId uint256 ID of the token to be transferred
1043      * @param _data bytes optional data to send along with the call
1044      * @return bool whether the call correctly returned the expected magic value
1045      */
1046     function _checkOnERC721Received(
1047         address from,
1048         address to,
1049         uint256 tokenId,
1050         bytes memory _data
1051     ) private returns (bool) {
1052         if (to.isContract()) {
1053             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1054                 return retval == IERC721Receiver.onERC721Received.selector;
1055             } catch (bytes memory reason) {
1056                 if (reason.length == 0) {
1057                     revert("ERC721: transfer to non ERC721Receiver implementer");
1058                 } else {
1059                     assembly {
1060                         revert(add(32, reason), mload(reason))
1061                     }
1062                 }
1063             }
1064         } else {
1065             return true;
1066         }
1067     }
1068 
1069     /**
1070      * @dev Hook that is called before any token transfer. This includes minting
1071      * and burning.
1072      *
1073      * Calling conditions:
1074      *
1075      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1076      * transferred to `to`.
1077      * - When `from` is zero, `tokenId` will be minted for `to`.
1078      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1079      * - `from` and `to` are never both zero.
1080      *
1081      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1082      */
1083     function _beforeTokenTransfer(
1084         address from,
1085         address to,
1086         uint256 tokenId
1087     ) internal virtual {}
1088 }
1089 
1090 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1091 
1092 
1093 
1094 pragma solidity ^0.8.0;
1095 
1096 
1097 
1098 /**
1099  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1100  * enumerability of all the token ids in the contract as well as all token ids owned by each
1101  * account.
1102  */
1103 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1104     // Mapping from owner to list of owned token IDs
1105     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1106 
1107     // Mapping from token ID to index of the owner tokens list
1108     mapping(uint256 => uint256) private _ownedTokensIndex;
1109 
1110     // Array with all token ids, used for enumeration
1111     uint256[] private _allTokens;
1112 
1113     // Mapping from token id to position in the allTokens array
1114     mapping(uint256 => uint256) private _allTokensIndex;
1115 
1116     /**
1117      * @dev See {IERC165-supportsInterface}.
1118      */
1119     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1120         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1121     }
1122 
1123     /**
1124      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1125      */
1126     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1127         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1128         return _ownedTokens[owner][index];
1129     }
1130 
1131     /**
1132      * @dev See {IERC721Enumerable-totalSupply}.
1133      */
1134     function totalSupply() public view virtual override returns (uint256) {
1135         return _allTokens.length;
1136     }
1137 
1138     /**
1139      * @dev See {IERC721Enumerable-tokenByIndex}.
1140      */
1141     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1142         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1143         return _allTokens[index];
1144     }
1145 
1146     /**
1147      * @dev Hook that is called before any token transfer. This includes minting
1148      * and burning.
1149      *
1150      * Calling conditions:
1151      *
1152      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1153      * transferred to `to`.
1154      * - When `from` is zero, `tokenId` will be minted for `to`.
1155      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1156      * - `from` cannot be the zero address.
1157      * - `to` cannot be the zero address.
1158      *
1159      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1160      */
1161     function _beforeTokenTransfer(
1162         address from,
1163         address to,
1164         uint256 tokenId
1165     ) internal virtual override {
1166         super._beforeTokenTransfer(from, to, tokenId);
1167 
1168         if (from == address(0)) {
1169             _addTokenToAllTokensEnumeration(tokenId);
1170         } else if (from != to) {
1171             _removeTokenFromOwnerEnumeration(from, tokenId);
1172         }
1173         if (to == address(0)) {
1174             _removeTokenFromAllTokensEnumeration(tokenId);
1175         } else if (to != from) {
1176             _addTokenToOwnerEnumeration(to, tokenId);
1177         }
1178     }
1179 
1180     /**
1181      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1182      * @param to address representing the new owner of the given token ID
1183      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1184      */
1185     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1186         uint256 length = ERC721.balanceOf(to);
1187         _ownedTokens[to][length] = tokenId;
1188         _ownedTokensIndex[tokenId] = length;
1189     }
1190 
1191     /**
1192      * @dev Private function to add a token to this extension's token tracking data structures.
1193      * @param tokenId uint256 ID of the token to be added to the tokens list
1194      */
1195     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1196         _allTokensIndex[tokenId] = _allTokens.length;
1197         _allTokens.push(tokenId);
1198     }
1199 
1200     /**
1201      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1202      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1203      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1204      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1205      * @param from address representing the previous owner of the given token ID
1206      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1207      */
1208     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1209         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1210         // then delete the last slot (swap and pop).
1211 
1212         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1213         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1214 
1215         // When the token to delete is the last token, the swap operation is unnecessary
1216         if (tokenIndex != lastTokenIndex) {
1217             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1218 
1219             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1220             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1221         }
1222 
1223         // This also deletes the contents at the last position of the array
1224         delete _ownedTokensIndex[tokenId];
1225         delete _ownedTokens[from][lastTokenIndex];
1226     }
1227 
1228     /**
1229      * @dev Private function to remove a token from this extension's token tracking data structures.
1230      * This has O(1) time complexity, but alters the order of the _allTokens array.
1231      * @param tokenId uint256 ID of the token to be removed from the tokens list
1232      */
1233     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1234         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1235         // then delete the last slot (swap and pop).
1236 
1237         uint256 lastTokenIndex = _allTokens.length - 1;
1238         uint256 tokenIndex = _allTokensIndex[tokenId];
1239 
1240         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1241         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1242         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1243         uint256 lastTokenId = _allTokens[lastTokenIndex];
1244 
1245         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1246         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1247 
1248         // This also deletes the contents at the last position of the array
1249         delete _allTokensIndex[tokenId];
1250         _allTokens.pop();
1251     }
1252 }
1253 
1254 // File: contracts/Dark.sol
1255 
1256 
1257 
1258 pragma solidity >=0.7.0 <0.9.0;
1259 
1260 
1261 
1262 contract DarkEchelon is ERC721Enumerable, Ownable {
1263     using Strings for uint256;
1264 
1265     string baseURI;
1266     string public baseExtension = ".json";
1267     uint256 public cost = 90000000000000000;
1268     uint256 public maxSupply = 1098;
1269     uint256 public maxMintAmount = 4;
1270     uint256 public reservedForTeam = 10;
1271     
1272     string private signature;
1273 
1274     bool public paused = false;
1275     bool public revealed = false;
1276 
1277     // Whitelist
1278     uint256 public whitelistMintAmount = 3;
1279     uint256 public whitelistReserved = 1000;
1280     uint256 public whitelistCost = 90000000000000000;
1281 
1282     bool private whitelistedSale = true;
1283     string public notRevealedUri;
1284 
1285     string _name = "DarkEchelon";
1286     string _symbol = "DARK";
1287 
1288     constructor(
1289         string memory _initBaseURI,
1290         string memory _initNotRevealedUri
1291     ) ERC721(_name, _symbol) {
1292         setBaseURI(_initBaseURI);
1293         setNotRevealedURI(_initNotRevealedUri);
1294     }
1295 
1296     // internal
1297     function _baseURI() internal view virtual override returns (string memory) {
1298         return baseURI;
1299     }
1300     
1301     function presaleMint(uint256 _mintAmount, string memory _signature) public payable {
1302         require(!paused, "Contract is paused");
1303         require(whitelistedSale);
1304         require(keccak256(abi.encodePacked((signature))) == keccak256(abi.encodePacked((_signature))), "Invalid signature");
1305         require(msg.sender != owner());
1306         
1307         uint256 supply = totalSupply();
1308         uint256 totalAmount;
1309 
1310         uint256 tokenCount = balanceOf(msg.sender);
1311 
1312         require(
1313             tokenCount + _mintAmount <= maxMintAmount,
1314             string(abi.encodePacked("Limit token ", tokenCount.toString()))
1315         );
1316         require(
1317             supply + _mintAmount <= maxSupply - reservedForTeam,
1318             "Max Supply"
1319         );
1320 
1321         // Whitelist
1322         require(whitelistReserved - _mintAmount >= 0);
1323         require(tokenCount + _mintAmount <= whitelistMintAmount, "Maximum per wallet is 3 during whitelist");
1324 
1325         totalAmount = whitelistCost * _mintAmount;
1326 
1327         require(
1328             msg.value >= totalAmount,
1329             string(
1330                 abi.encodePacked(
1331                     "Incorrect amount ",
1332                     totalAmount.toString(),
1333                     " ",
1334                     msg.value.toString()
1335                 )
1336             )
1337         );
1338         
1339         whitelistReserved -= _mintAmount;
1340         
1341 
1342         for (uint256 i = 1; i <= _mintAmount; i++) {
1343             _safeMint(msg.sender, supply + i);
1344         }
1345     }
1346 
1347     // public
1348     function mint(uint256 _mintAmount) public payable {
1349         uint256 supply = totalSupply();
1350         uint256 totalAmount;
1351 
1352         require(!paused);
1353         require(_mintAmount > 0);
1354 
1355         // Owner
1356         if (msg.sender == owner()) {
1357             require(reservedForTeam >= _mintAmount);
1358             reservedForTeam -= _mintAmount;
1359         }
1360 
1361         if (msg.sender != owner()) {
1362             require(!whitelistedSale);
1363             uint256 tokenCount = balanceOf(msg.sender);
1364 
1365             require(
1366                 tokenCount + _mintAmount <= maxMintAmount,
1367                 string(abi.encodePacked("Limit token ", tokenCount.toString()))
1368             );
1369             require(
1370                 supply + _mintAmount <= maxSupply - reservedForTeam,
1371                 "Max Supply"
1372             );
1373 
1374             totalAmount = cost * _mintAmount;
1375 
1376             require(
1377                 msg.value >= totalAmount,
1378                 string(
1379                     abi.encodePacked(
1380                         "Incorrect amount ",
1381                         totalAmount.toString(),
1382                         " ",
1383                         msg.value.toString()
1384                     )
1385                 )
1386             );
1387         }
1388 
1389         for (uint256 i = 1; i <= _mintAmount; i++) {
1390             _safeMint(msg.sender, supply + i);
1391         }
1392     }
1393 
1394     function walletOfOwner(address _owner)
1395         public
1396         view
1397         returns (uint256[] memory)
1398     {
1399         uint256 ownerTokenCount = balanceOf(_owner);
1400         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1401 
1402         for (uint256 i; i < ownerTokenCount; i++) {
1403             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1404         }
1405         return tokenIds;
1406     }
1407 
1408     function tokenURI(uint256 tokenId)
1409         public
1410         view
1411         virtual
1412         override
1413         returns (string memory)
1414     {
1415         require(
1416             _exists(tokenId),
1417             "ERC721Metadata: URI query for nonexistent token"
1418         );
1419 
1420         if (revealed == false) {
1421             return notRevealedUri;
1422         }
1423 
1424         string memory currentBaseURI = _baseURI();
1425         return
1426             bytes(currentBaseURI).length > 0
1427                 ? string(
1428                     abi.encodePacked(
1429                         currentBaseURI,
1430                         tokenId.toString(),
1431                         baseExtension
1432                     )
1433                 )
1434                 : "";
1435     }
1436 
1437     //only owner
1438     function reveal() public onlyOwner {
1439         revealed = true;
1440     }
1441 
1442     function setReserved(uint256 _reserved) public onlyOwner {
1443         reservedForTeam = _reserved;
1444     }
1445 
1446     function setCost(uint256 _newCost) public onlyOwner {
1447         cost = _newCost;
1448     }
1449 
1450     function setWhitelistCost(uint256 _newCost) public onlyOwner {
1451         whitelistCost = _newCost;
1452     }
1453 
1454     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1455         maxMintAmount = _newmaxMintAmount;
1456     }
1457 
1458     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1459         notRevealedUri = _notRevealedURI;
1460     }
1461 
1462     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1463         baseURI = _newBaseURI;
1464     }
1465 
1466     function setBaseExtension(string memory _newBaseExtension)
1467         public
1468         onlyOwner
1469     {
1470         baseExtension = _newBaseExtension;
1471     }
1472 
1473     function pause(bool _state) public onlyOwner {
1474         paused = _state;
1475     }
1476 
1477     function whitelistSale(bool _state) public onlyOwner {
1478         require(whitelistReserved > 0);
1479         whitelistedSale = _state;
1480     }
1481     
1482     function setSignature(string memory _signature) public onlyOwner {
1483         signature = _signature;
1484     }
1485 
1486     function setWhitelistReserved(uint256 _count) public onlyOwner {
1487         uint256 totalSupply = totalSupply();
1488         require(_count < maxSupply - totalSupply);
1489         whitelistReserved = _count;
1490     }
1491 
1492     function withdraw() public payable onlyOwner {
1493         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1494         require(os);
1495     }
1496 
1497     function getBalance() public view onlyOwner returns (uint256) {
1498         return address(this).balance;
1499     }
1500 
1501     function isWhitelisted() public view returns (bool) {
1502         return whitelistedSale;
1503     }
1504 }