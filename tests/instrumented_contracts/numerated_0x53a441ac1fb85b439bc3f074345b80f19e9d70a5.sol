1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 
6 
7 pragma solidity ^0.8.0;
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
76 pragma solidity ^0.8.0;
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
102 pragma solidity ^0.8.0;
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
392 
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @title ERC721 token receiver interface
398  * @dev Interface for any contract that wants to support safeTransfers
399  * from ERC721 asset contracts.
400  */
401 interface IERC721Receiver {
402     /**
403      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
404      * by `operator` from `from`, this function is called.
405      *
406      * It must return its Solidity selector to confirm the token transfer.
407      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
408      *
409      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
410      */
411     function onERC721Received(
412         address operator,
413         address from,
414         uint256 tokenId,
415         bytes calldata data
416     ) external returns (bytes4);
417 }
418 
419 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
420 
421 
422 
423 pragma solidity ^0.8.0;
424 
425 /**
426  * @dev Interface of the ERC165 standard, as defined in the
427  * https://eips.ethereum.org/EIPS/eip-165[EIP].
428  *
429  * Implementers can declare support of contract interfaces, which can then be
430  * queried by others ({ERC165Checker}).
431  *
432  * For an implementation, see {ERC165}.
433  */
434 interface IERC165 {
435     /**
436      * @dev Returns true if this contract implements the interface defined by
437      * `interfaceId`. See the corresponding
438      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
439      * to learn more about how these ids are created.
440      *
441      * This function call must use less than 30 000 gas.
442      */
443     function supportsInterface(bytes4 interfaceId) external view returns (bool);
444 }
445 
446 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
447 
448 
449 
450 pragma solidity ^0.8.0;
451 
452 
453 /**
454  * @dev Implementation of the {IERC165} interface.
455  *
456  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
457  * for the additional interface id that will be supported. For example:
458  *
459  * ```solidity
460  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
461  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
462  * }
463  * ```
464  *
465  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
466  */
467 abstract contract ERC165 is IERC165 {
468     /**
469      * @dev See {IERC165-supportsInterface}.
470      */
471     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
472         return interfaceId == type(IERC165).interfaceId;
473     }
474 }
475 
476 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
477 
478 
479 
480 pragma solidity ^0.8.0;
481 
482 
483 /**
484  * @dev Required interface of an ERC721 compliant contract.
485  */
486 interface IERC721 is IERC165 {
487     /**
488      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
489      */
490     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
491 
492     /**
493      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
494      */
495     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
496 
497     /**
498      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
499      */
500     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
501 
502     /**
503      * @dev Returns the number of tokens in ``owner``'s account.
504      */
505     function balanceOf(address owner) external view returns (uint256 balance);
506 
507     /**
508      * @dev Returns the owner of the `tokenId` token.
509      *
510      * Requirements:
511      *
512      * - `tokenId` must exist.
513      */
514     function ownerOf(uint256 tokenId) external view returns (address owner);
515 
516     /**
517      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
518      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
519      *
520      * Requirements:
521      *
522      * - `from` cannot be the zero address.
523      * - `to` cannot be the zero address.
524      * - `tokenId` token must exist and be owned by `from`.
525      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
526      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
527      *
528      * Emits a {Transfer} event.
529      */
530     function safeTransferFrom(
531         address from,
532         address to,
533         uint256 tokenId
534     ) external;
535 
536     /**
537      * @dev Transfers `tokenId` token from `from` to `to`.
538      *
539      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
540      *
541      * Requirements:
542      *
543      * - `from` cannot be the zero address.
544      * - `to` cannot be the zero address.
545      * - `tokenId` token must be owned by `from`.
546      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
547      *
548      * Emits a {Transfer} event.
549      */
550     function transferFrom(
551         address from,
552         address to,
553         uint256 tokenId
554     ) external;
555 
556     /**
557      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
558      * The approval is cleared when the token is transferred.
559      *
560      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
561      *
562      * Requirements:
563      *
564      * - The caller must own the token or be an approved operator.
565      * - `tokenId` must exist.
566      *
567      * Emits an {Approval} event.
568      */
569     function approve(address to, uint256 tokenId) external;
570 
571     /**
572      * @dev Returns the account approved for `tokenId` token.
573      *
574      * Requirements:
575      *
576      * - `tokenId` must exist.
577      */
578     function getApproved(uint256 tokenId) external view returns (address operator);
579 
580     /**
581      * @dev Approve or remove `operator` as an operator for the caller.
582      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
583      *
584      * Requirements:
585      *
586      * - The `operator` cannot be the caller.
587      *
588      * Emits an {ApprovalForAll} event.
589      */
590     function setApprovalForAll(address operator, bool _approved) external;
591 
592     /**
593      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
594      *
595      * See {setApprovalForAll}
596      */
597     function isApprovedForAll(address owner, address operator) external view returns (bool);
598 
599     /**
600      * @dev Safely transfers `tokenId` token from `from` to `to`.
601      *
602      * Requirements:
603      *
604      * - `from` cannot be the zero address.
605      * - `to` cannot be the zero address.
606      * - `tokenId` token must exist and be owned by `from`.
607      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
608      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
609      *
610      * Emits a {Transfer} event.
611      */
612     function safeTransferFrom(
613         address from,
614         address to,
615         uint256 tokenId,
616         bytes calldata data
617     ) external;
618 }
619 
620 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
621 
622 
623 
624 pragma solidity ^0.8.0;
625 
626 
627 /**
628  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
629  * @dev See https://eips.ethereum.org/EIPS/eip-721
630  */
631 interface IERC721Enumerable is IERC721 {
632     /**
633      * @dev Returns the total amount of tokens stored by the contract.
634      */
635     function totalSupply() external view returns (uint256);
636 
637     /**
638      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
639      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
640      */
641     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
642 
643     /**
644      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
645      * Use along with {totalSupply} to enumerate all tokens.
646      */
647     function tokenByIndex(uint256 index) external view returns (uint256);
648 }
649 
650 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
651 
652 
653 
654 pragma solidity ^0.8.0;
655 
656 
657 /**
658  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
659  * @dev See https://eips.ethereum.org/EIPS/eip-721
660  */
661 interface IERC721Metadata is IERC721 {
662     /**
663      * @dev Returns the token collection name.
664      */
665     function name() external view returns (string memory);
666 
667     /**
668      * @dev Returns the token collection symbol.
669      */
670     function symbol() external view returns (string memory);
671 
672     /**
673      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
674      */
675     function tokenURI(uint256 tokenId) external view returns (string memory);
676 }
677 
678 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
679 
680 
681 
682 pragma solidity ^0.8.0;
683 
684 
685 
686 
687 
688 
689 
690 
691 /**
692  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
693  * the Metadata extension, but not including the Enumerable extension, which is available separately as
694  * {ERC721Enumerable}.
695  */
696 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
697     using Address for address;
698     using Strings for uint256;
699 
700     // Token name
701     string private _name;
702 
703     // Token symbol
704     string private _symbol;
705 
706     // Mapping from token ID to owner address
707     mapping(uint256 => address) private _owners;
708 
709     // Mapping owner address to token count
710     mapping(address => uint256) private _balances;
711 
712     // Mapping from token ID to approved address
713     mapping(uint256 => address) private _tokenApprovals;
714 
715     // Mapping from owner to operator approvals
716     mapping(address => mapping(address => bool)) private _operatorApprovals;
717 
718     /**
719      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
720      */
721     constructor(string memory name_, string memory symbol_) {
722         _name = name_;
723         _symbol = symbol_;
724     }
725 
726     /**
727      * @dev See {IERC165-supportsInterface}.
728      */
729     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
730         return
731             interfaceId == type(IERC721).interfaceId ||
732             interfaceId == type(IERC721Metadata).interfaceId ||
733             super.supportsInterface(interfaceId);
734     }
735 
736     /**
737      * @dev See {IERC721-balanceOf}.
738      */
739     function balanceOf(address owner) public view virtual override returns (uint256) {
740         require(owner != address(0), "ERC721: balance query for the zero address");
741         return _balances[owner];
742     }
743 
744     /**
745      * @dev See {IERC721-ownerOf}.
746      */
747     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
748         address owner = _owners[tokenId];
749         require(owner != address(0), "ERC721: owner query for nonexistent token");
750         return owner;
751     }
752 
753     /**
754      * @dev See {IERC721Metadata-name}.
755      */
756     function name() public view virtual override returns (string memory) {
757         return _name;
758     }
759 
760     /**
761      * @dev See {IERC721Metadata-symbol}.
762      */
763     function symbol() public view virtual override returns (string memory) {
764         return _symbol;
765     }
766 
767     /**
768      * @dev See {IERC721Metadata-tokenURI}.
769      */
770     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
771         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
772 
773         string memory baseURI = _baseURI();
774         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
775     }
776 
777     /**
778      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
779      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
780      * by default, can be overriden in child contracts.
781      */
782     function _baseURI() internal view virtual returns (string memory) {
783         return "";
784     }
785 
786     /**
787      * @dev See {IERC721-approve}.
788      */
789     function approve(address to, uint256 tokenId) public virtual override {
790         address owner = ERC721.ownerOf(tokenId);
791         require(to != owner, "ERC721: approval to current owner");
792 
793         require(
794             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
795             "ERC721: approve caller is not owner nor approved for all"
796         );
797 
798         _approve(to, tokenId);
799     }
800 
801     /**
802      * @dev See {IERC721-getApproved}.
803      */
804     function getApproved(uint256 tokenId) public view virtual override returns (address) {
805         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
806 
807         return _tokenApprovals[tokenId];
808     }
809 
810     /**
811      * @dev See {IERC721-setApprovalForAll}.
812      */
813     function setApprovalForAll(address operator, bool approved) public virtual override {
814         require(operator != _msgSender(), "ERC721: approve to caller");
815 
816         _operatorApprovals[_msgSender()][operator] = approved;
817         emit ApprovalForAll(_msgSender(), operator, approved);
818     }
819 
820     /**
821      * @dev See {IERC721-isApprovedForAll}.
822      */
823     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
824         return _operatorApprovals[owner][operator];
825     }
826 
827     /**
828      * @dev See {IERC721-transferFrom}.
829      */
830     function transferFrom(
831         address from,
832         address to,
833         uint256 tokenId
834     ) public virtual override {
835         //solhint-disable-next-line max-line-length
836         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
837 
838         _transfer(from, to, tokenId);
839     }
840 
841     /**
842      * @dev See {IERC721-safeTransferFrom}.
843      */
844     function safeTransferFrom(
845         address from,
846         address to,
847         uint256 tokenId
848     ) public virtual override {
849         safeTransferFrom(from, to, tokenId, "");
850     }
851 
852     /**
853      * @dev See {IERC721-safeTransferFrom}.
854      */
855     function safeTransferFrom(
856         address from,
857         address to,
858         uint256 tokenId,
859         bytes memory _data
860     ) public virtual override {
861         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
862         _safeTransfer(from, to, tokenId, _data);
863     }
864 
865     /**
866      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
867      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
868      *
869      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
870      *
871      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
872      * implement alternative mechanisms to perform token transfer, such as signature-based.
873      *
874      * Requirements:
875      *
876      * - `from` cannot be the zero address.
877      * - `to` cannot be the zero address.
878      * - `tokenId` token must exist and be owned by `from`.
879      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
880      *
881      * Emits a {Transfer} event.
882      */
883     function _safeTransfer(
884         address from,
885         address to,
886         uint256 tokenId,
887         bytes memory _data
888     ) internal virtual {
889         _transfer(from, to, tokenId);
890         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
891     }
892 
893     /**
894      * @dev Returns whether `tokenId` exists.
895      *
896      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
897      *
898      * Tokens start existing when they are minted (`_mint`),
899      * and stop existing when they are burned (`_burn`).
900      */
901     function _exists(uint256 tokenId) internal view virtual returns (bool) {
902         return _owners[tokenId] != address(0);
903     }
904 
905     /**
906      * @dev Returns whether `spender` is allowed to manage `tokenId`.
907      *
908      * Requirements:
909      *
910      * - `tokenId` must exist.
911      */
912     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
913         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
914         address owner = ERC721.ownerOf(tokenId);
915         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
916     }
917 
918     /**
919      * @dev Safely mints `tokenId` and transfers it to `to`.
920      *
921      * Requirements:
922      *
923      * - `tokenId` must not exist.
924      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
925      *
926      * Emits a {Transfer} event.
927      */
928     function _safeMint(address to, uint256 tokenId) internal virtual {
929         _safeMint(to, tokenId, "");
930     }
931 
932     /**
933      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
934      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
935      */
936     function _safeMint(
937         address to,
938         uint256 tokenId,
939         bytes memory _data
940     ) internal virtual {
941         _mint(to, tokenId);
942         require(
943             _checkOnERC721Received(address(0), to, tokenId, _data),
944             "ERC721: transfer to non ERC721Receiver implementer"
945         );
946     }
947 
948     /**
949      * @dev Mints `tokenId` and transfers it to `to`.
950      *
951      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
952      *
953      * Requirements:
954      *
955      * - `tokenId` must not exist.
956      * - `to` cannot be the zero address.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _mint(address to, uint256 tokenId) internal virtual {
961         require(to != address(0), "ERC721: mint to the zero address");
962         require(!_exists(tokenId), "ERC721: token already minted");
963 
964         _beforeTokenTransfer(address(0), to, tokenId);
965 
966         _balances[to] += 1;
967         _owners[tokenId] = to;
968 
969         emit Transfer(address(0), to, tokenId);
970     }
971 
972     /**
973      * @dev Destroys `tokenId`.
974      * The approval is cleared when the token is burned.
975      *
976      * Requirements:
977      *
978      * - `tokenId` must exist.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _burn(uint256 tokenId) internal virtual {
983         address owner = ERC721.ownerOf(tokenId);
984 
985         _beforeTokenTransfer(owner, address(0), tokenId);
986 
987         // Clear approvals
988         _approve(address(0), tokenId);
989 
990         _balances[owner] -= 1;
991         delete _owners[tokenId];
992 
993         emit Transfer(owner, address(0), tokenId);
994     }
995 
996     /**
997      * @dev Transfers `tokenId` from `from` to `to`.
998      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
999      *
1000      * Requirements:
1001      *
1002      * - `to` cannot be the zero address.
1003      * - `tokenId` token must be owned by `from`.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _transfer(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) internal virtual {
1012         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1013         require(to != address(0), "ERC721: transfer to the zero address");
1014 
1015         _beforeTokenTransfer(from, to, tokenId);
1016 
1017         // Clear approvals from the previous owner
1018         _approve(address(0), tokenId);
1019 
1020         _balances[from] -= 1;
1021         _balances[to] += 1;
1022         _owners[tokenId] = to;
1023 
1024         emit Transfer(from, to, tokenId);
1025     }
1026 
1027     /**
1028      * @dev Approve `to` to operate on `tokenId`
1029      *
1030      * Emits a {Approval} event.
1031      */
1032     function _approve(address to, uint256 tokenId) internal virtual {
1033         _tokenApprovals[tokenId] = to;
1034         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1035     }
1036 
1037     /**
1038      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1039      * The call is not executed if the target address is not a contract.
1040      *
1041      * @param from address representing the previous owner of the given token ID
1042      * @param to target address that will receive the tokens
1043      * @param tokenId uint256 ID of the token to be transferred
1044      * @param _data bytes optional data to send along with the call
1045      * @return bool whether the call correctly returned the expected magic value
1046      */
1047     function _checkOnERC721Received(
1048         address from,
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) private returns (bool) {
1053         if (to.isContract()) {
1054             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1055                 return retval == IERC721Receiver.onERC721Received.selector;
1056             } catch (bytes memory reason) {
1057                 if (reason.length == 0) {
1058                     revert("ERC721: transfer to non ERC721Receiver implementer");
1059                 } else {
1060                     assembly {
1061                         revert(add(32, reason), mload(reason))
1062                     }
1063                 }
1064             }
1065         } else {
1066             return true;
1067         }
1068     }
1069 
1070     /**
1071      * @dev Hook that is called before any token transfer. This includes minting
1072      * and burning.
1073      *
1074      * Calling conditions:
1075      *
1076      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1077      * transferred to `to`.
1078      * - When `from` is zero, `tokenId` will be minted for `to`.
1079      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1080      * - `from` and `to` are never both zero.
1081      *
1082      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1083      */
1084     function _beforeTokenTransfer(
1085         address from,
1086         address to,
1087         uint256 tokenId
1088     ) internal virtual {}
1089 }
1090 
1091 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1092 
1093 
1094 
1095 pragma solidity ^0.8.0;
1096 
1097 
1098 
1099 /**
1100  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1101  * enumerability of all the token ids in the contract as well as all token ids owned by each
1102  * account.
1103  */
1104 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1105     // Mapping from owner to list of owned token IDs
1106     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1107 
1108     // Mapping from token ID to index of the owner tokens list
1109     mapping(uint256 => uint256) private _ownedTokensIndex;
1110 
1111     // Array with all token ids, used for enumeration
1112     uint256[] private _allTokens;
1113 
1114     // Mapping from token id to position in the allTokens array
1115     mapping(uint256 => uint256) private _allTokensIndex;
1116 
1117     /**
1118      * @dev See {IERC165-supportsInterface}.
1119      */
1120     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1121         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1122     }
1123 
1124     /**
1125      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1126      */
1127     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1128         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1129         return _ownedTokens[owner][index];
1130     }
1131 
1132     /**
1133      * @dev See {IERC721Enumerable-totalSupply}.
1134      */
1135     function totalSupply() public view virtual override returns (uint256) {
1136         return _allTokens.length;
1137     }
1138 
1139     /**
1140      * @dev See {IERC721Enumerable-tokenByIndex}.
1141      */
1142     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1143         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1144         return _allTokens[index];
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
1157      * - `from` cannot be the zero address.
1158      * - `to` cannot be the zero address.
1159      *
1160      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1161      */
1162     function _beforeTokenTransfer(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) internal virtual override {
1167         super._beforeTokenTransfer(from, to, tokenId);
1168 
1169         if (from == address(0)) {
1170             _addTokenToAllTokensEnumeration(tokenId);
1171         } else if (from != to) {
1172             _removeTokenFromOwnerEnumeration(from, tokenId);
1173         }
1174         if (to == address(0)) {
1175             _removeTokenFromAllTokensEnumeration(tokenId);
1176         } else if (to != from) {
1177             _addTokenToOwnerEnumeration(to, tokenId);
1178         }
1179     }
1180 
1181     /**
1182      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1183      * @param to address representing the new owner of the given token ID
1184      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1185      */
1186     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1187         uint256 length = ERC721.balanceOf(to);
1188         _ownedTokens[to][length] = tokenId;
1189         _ownedTokensIndex[tokenId] = length;
1190     }
1191 
1192     /**
1193      * @dev Private function to add a token to this extension's token tracking data structures.
1194      * @param tokenId uint256 ID of the token to be added to the tokens list
1195      */
1196     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1197         _allTokensIndex[tokenId] = _allTokens.length;
1198         _allTokens.push(tokenId);
1199     }
1200 
1201     /**
1202      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1203      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1204      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1205      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1206      * @param from address representing the previous owner of the given token ID
1207      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1208      */
1209     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1210         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1211         // then delete the last slot (swap and pop).
1212 
1213         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1214         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1215 
1216         // When the token to delete is the last token, the swap operation is unnecessary
1217         if (tokenIndex != lastTokenIndex) {
1218             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1219 
1220             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1221             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1222         }
1223 
1224         // This also deletes the contents at the last position of the array
1225         delete _ownedTokensIndex[tokenId];
1226         delete _ownedTokens[from][lastTokenIndex];
1227     }
1228 
1229     /**
1230      * @dev Private function to remove a token from this extension's token tracking data structures.
1231      * This has O(1) time complexity, but alters the order of the _allTokens array.
1232      * @param tokenId uint256 ID of the token to be removed from the tokens list
1233      */
1234     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1235         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1236         // then delete the last slot (swap and pop).
1237 
1238         uint256 lastTokenIndex = _allTokens.length - 1;
1239         uint256 tokenIndex = _allTokensIndex[tokenId];
1240 
1241         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1242         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1243         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1244         uint256 lastTokenId = _allTokens[lastTokenIndex];
1245 
1246         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1247         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1248 
1249         // This also deletes the contents at the last position of the array
1250         delete _allTokensIndex[tokenId];
1251         _allTokens.pop();
1252     }
1253 }
1254 
1255 // File: contracts/DayOfTheDeadNFT.sol
1256 
1257 
1258 
1259 pragma solidity 0.8.7;
1260 
1261 
1262 
1263 contract DayOfTheDeadNFT is ERC721Enumerable, Ownable {
1264   using Strings for uint256;
1265 
1266   string public baseURI;
1267   string public baseExtension = ".json";
1268   string public notRevealedUri;
1269   uint256 public cost = 0.0777 ether;
1270   uint256 public maxSupply = 7777;
1271   uint256 public maxMintAmount = 1;
1272   uint256 public nftPerAddressLimit = 3;
1273   bool public paused = true;
1274   bool public revealed = false;
1275   bool public onlyWhitelisted = true;
1276   address[] public whitelistedAddresses;
1277   mapping(address => uint256) public addressMintedBalance;
1278 
1279   constructor(
1280     string memory _name,
1281     string memory _symbol,
1282     string memory _initBaseURI,
1283     string memory _initNotRevealedUri
1284   ) ERC721(_name, _symbol) {
1285     setBaseURI(_initBaseURI);
1286     setNotRevealedURI(_initNotRevealedUri);
1287   }
1288 
1289   // internal
1290   function _baseURI() internal view virtual override returns (string memory) {
1291     return baseURI;
1292   }
1293 
1294   // public
1295   function mint(uint256 _mintAmount) public payable {
1296     require(!paused, "the contract is paused");
1297     uint256 supply = totalSupply();
1298     require(_mintAmount > 0, "need to mint at least 1 NFT");
1299     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1300     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1301 
1302     if (msg.sender != owner()) {
1303       if(onlyWhitelisted == true) {
1304         require(isWhitelisted(msg.sender), "user is not whitelisted");
1305         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1306         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1307       }
1308       require(msg.value >= cost * _mintAmount, "insufficient funds");
1309     }
1310 
1311     for (uint256 i = 1; i <= _mintAmount; i++) {
1312       addressMintedBalance[msg.sender]++;
1313       _safeMint(msg.sender, supply + i);
1314     }
1315   }
1316 
1317   function isWhitelisted(address _user) public view returns (bool) {
1318     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1319       if (whitelistedAddresses[i] == _user) {
1320         return true;
1321       }
1322     }
1323     return false;
1324   }
1325 
1326   function walletOfOwner(address _owner)
1327   public
1328   view
1329   returns (uint256[] memory)
1330   {
1331     uint256 ownerTokenCount = balanceOf(_owner);
1332     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1333     for (uint256 i; i < ownerTokenCount; i++) {
1334       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1335     }
1336     return tokenIds;
1337   }
1338 
1339   function tokenURI(uint256 tokenId)
1340   public
1341   view
1342   virtual
1343   override
1344   returns (string memory)
1345   {
1346     require(
1347       _exists(tokenId),
1348       "ERC721Metadata: URI query for nonexistent token"
1349     );
1350 
1351     if(revealed == false) {
1352       return notRevealedUri;
1353     }
1354 
1355     string memory currentBaseURI = _baseURI();
1356     return bytes(currentBaseURI).length > 0
1357     ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1358     : "";
1359   }
1360 
1361   //only owner
1362   function reveal() public onlyOwner() {
1363     revealed = true;
1364   }
1365 
1366   function setNftPerAddressLimit(uint256 _limit) public onlyOwner() {
1367     nftPerAddressLimit = _limit;
1368   }
1369 
1370   function setCost(uint256 _newCost) public onlyOwner() {
1371     cost = _newCost;
1372   }
1373 
1374   function setMaxSupply(uint256 _maxSupply) public onlyOwner() {
1375       maxSupply = _maxSupply;
1376   }
1377 
1378   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1379     maxMintAmount = _newmaxMintAmount;
1380   }
1381 
1382   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1383     baseURI = _newBaseURI;
1384   }
1385 
1386   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1387     baseExtension = _newBaseExtension;
1388   }
1389 
1390   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1391     notRevealedUri = _notRevealedURI;
1392   }
1393 
1394   function pause(bool _state) public onlyOwner {
1395     paused = _state;
1396   }
1397 
1398   function setOnlyWhitelisted(bool _state) public onlyOwner {
1399     onlyWhitelisted = _state;
1400   }
1401 
1402   function whitelistUsers(address[] calldata _users) public onlyOwner {
1403     delete whitelistedAddresses;
1404     whitelistedAddresses = _users;
1405   }
1406 
1407   function withdraw() public payable onlyOwner {
1408     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1409     require(success);
1410   }
1411 }