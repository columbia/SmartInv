1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 
6 
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
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
75 
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         return msg.data;
96     }
97 }
98 
99 // File: @openzeppelin/contracts/access/Ownable.sol
100 
101 
102 
103 pragma solidity ^0.8.0;
104 
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _setOwner(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _setOwner(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _setOwner(newOwner);
163     }
164 
165     function _setOwner(address newOwner) private {
166         address oldOwner = _owner;
167         _owner = newOwner;
168         emit OwnershipTransferred(oldOwner, newOwner);
169     }
170 }
171 
172 // File: @openzeppelin/contracts/utils/Address.sol
173 
174 
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @dev Collection of functions related to the address type
180  */
181 library Address {
182     /**
183      * @dev Returns true if `account` is a contract.
184      *
185      * [IMPORTANT]
186      * ====
187      * It is unsafe to assume that an address for which this function returns
188      * false is an externally-owned account (EOA) and not a contract.
189      *
190      * Among others, `isContract` will return false for the following
191      * types of addresses:
192      *
193      *  - an externally-owned account
194      *  - a contract in construction
195      *  - an address where a contract will be created
196      *  - an address where a contract lived, but was destroyed
197      * ====
198      */
199     function isContract(address account) internal view returns (bool) {
200         // This method relies on extcodesize, which returns 0 for contracts in
201         // construction, since the code is only stored at the end of the
202         // constructor execution.
203 
204         uint256 size;
205         assembly {
206             size := extcodesize(account)
207         }
208         return size > 0;
209     }
210 
211     /**
212      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
213      * `recipient`, forwarding all available gas and reverting on errors.
214      *
215      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
216      * of certain opcodes, possibly making contracts go over the 2300 gas limit
217      * imposed by `transfer`, making them unable to receive funds via
218      * `transfer`. {sendValue} removes this limitation.
219      *
220      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
221      *
222      * IMPORTANT: because control is transferred to `recipient`, care must be
223      * taken to not create reentrancy vulnerabilities. Consider using
224      * {ReentrancyGuard} or the
225      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
226      */
227     function sendValue(address payable recipient, uint256 amount) internal {
228         require(address(this).balance >= amount, "Address: insufficient balance");
229 
230         (bool success, ) = recipient.call{value: amount}("");
231         require(success, "Address: unable to send value, recipient may have reverted");
232     }
233 
234     /**
235      * @dev Performs a Solidity function call using a low level `call`. A
236      * plain `call` is an unsafe replacement for a function call: use this
237      * function instead.
238      *
239      * If `target` reverts with a revert reason, it is bubbled up by this
240      * function (like regular Solidity function calls).
241      *
242      * Returns the raw returned data. To convert to the expected return value,
243      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
244      *
245      * Requirements:
246      *
247      * - `target` must be a contract.
248      * - calling `target` with `data` must not revert.
249      *
250      * _Available since v3.1._
251      */
252     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
253         return functionCall(target, data, "Address: low-level call failed");
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
258      * `errorMessage` as a fallback revert reason when `target` reverts.
259      *
260      * _Available since v3.1._
261      */
262     function functionCall(
263         address target,
264         bytes memory data,
265         string memory errorMessage
266     ) internal returns (bytes memory) {
267         return functionCallWithValue(target, data, 0, errorMessage);
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
272      * but also transferring `value` wei to `target`.
273      *
274      * Requirements:
275      *
276      * - the calling contract must have an ETH balance of at least `value`.
277      * - the called Solidity function must be `payable`.
278      *
279      * _Available since v3.1._
280      */
281     function functionCallWithValue(
282         address target,
283         bytes memory data,
284         uint256 value
285     ) internal returns (bytes memory) {
286         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
291      * with `errorMessage` as a fallback revert reason when `target` reverts.
292      *
293      * _Available since v3.1._
294      */
295     function functionCallWithValue(
296         address target,
297         bytes memory data,
298         uint256 value,
299         string memory errorMessage
300     ) internal returns (bytes memory) {
301         require(address(this).balance >= value, "Address: insufficient balance for call");
302         require(isContract(target), "Address: call to non-contract");
303 
304         (bool success, bytes memory returndata) = target.call{value: value}(data);
305         return verifyCallResult(success, returndata, errorMessage);
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
310      * but performing a static call.
311      *
312      * _Available since v3.3._
313      */
314     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
315         return functionStaticCall(target, data, "Address: low-level static call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
320      * but performing a static call.
321      *
322      * _Available since v3.3._
323      */
324     function functionStaticCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal view returns (bytes memory) {
329         require(isContract(target), "Address: static call to non-contract");
330 
331         (bool success, bytes memory returndata) = target.staticcall(data);
332         return verifyCallResult(success, returndata, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but performing a delegate call.
338      *
339      * _Available since v3.4._
340      */
341     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
342         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
347      * but performing a delegate call.
348      *
349      * _Available since v3.4._
350      */
351     function functionDelegateCall(
352         address target,
353         bytes memory data,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         require(isContract(target), "Address: delegate call to non-contract");
357 
358         (bool success, bytes memory returndata) = target.delegatecall(data);
359         return verifyCallResult(success, returndata, errorMessage);
360     }
361 
362     /**
363      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
364      * revert reason using the provided one.
365      *
366      * _Available since v4.3._
367      */
368     function verifyCallResult(
369         bool success,
370         bytes memory returndata,
371         string memory errorMessage
372     ) internal pure returns (bytes memory) {
373         if (success) {
374             return returndata;
375         } else {
376             // Look for revert reason and bubble it up if present
377             if (returndata.length > 0) {
378                 // The easiest way to bubble the revert reason is using memory via assembly
379 
380                 assembly {
381                     let returndata_size := mload(returndata)
382                     revert(add(32, returndata), returndata_size)
383                 }
384             } else {
385                 revert(errorMessage);
386             }
387         }
388     }
389 }
390 
391 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
392 
393 
394 
395 pragma solidity ^0.8.0;
396 
397 /**
398  * @title ERC721 token receiver interface
399  * @dev Interface for any contract that wants to support safeTransfers
400  * from ERC721 asset contracts.
401  */
402 interface IERC721Receiver {
403     /**
404      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
405      * by `operator` from `from`, this function is called.
406      *
407      * It must return its Solidity selector to confirm the token transfer.
408      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
409      *
410      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
411      */
412     function onERC721Received(
413         address operator,
414         address from,
415         uint256 tokenId,
416         bytes calldata data
417     ) external returns (bytes4);
418 }
419 
420 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
421 
422 
423 
424 pragma solidity ^0.8.0;
425 
426 /**
427  * @dev Interface of the ERC165 standard, as defined in the
428  * https://eips.ethereum.org/EIPS/eip-165[EIP].
429  *
430  * Implementers can declare support of contract interfaces, which can then be
431  * queried by others ({ERC165Checker}).
432  *
433  * For an implementation, see {ERC165}.
434  */
435 interface IERC165 {
436     /**
437      * @dev Returns true if this contract implements the interface defined by
438      * `interfaceId`. See the corresponding
439      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
440      * to learn more about how these ids are created.
441      *
442      * This function call must use less than 30 000 gas.
443      */
444     function supportsInterface(bytes4 interfaceId) external view returns (bool);
445 }
446 
447 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
448 
449 
450 
451 pragma solidity ^0.8.0;
452 
453 
454 /**
455  * @dev Implementation of the {IERC165} interface.
456  *
457  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
458  * for the additional interface id that will be supported. For example:
459  *
460  * ```solidity
461  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
462  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
463  * }
464  * ```
465  *
466  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
467  */
468 abstract contract ERC165 is IERC165 {
469     /**
470      * @dev See {IERC165-supportsInterface}.
471      */
472     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
473         return interfaceId == type(IERC165).interfaceId;
474     }
475 }
476 
477 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
478 
479 
480 
481 pragma solidity ^0.8.0;
482 
483 
484 /**
485  * @dev Required interface of an ERC721 compliant contract.
486  */
487 interface IERC721 is IERC165 {
488     /**
489      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
490      */
491     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
492 
493     /**
494      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
495      */
496     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
497 
498     /**
499      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
500      */
501     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
502 
503     /**
504      * @dev Returns the number of tokens in ``owner``'s account.
505      */
506     function balanceOf(address owner) external view returns (uint256 balance);
507 
508     /**
509      * @dev Returns the owner of the `tokenId` token.
510      *
511      * Requirements:
512      *
513      * - `tokenId` must exist.
514      */
515     function ownerOf(uint256 tokenId) external view returns (address owner);
516 
517     /**
518      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
519      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
520      *
521      * Requirements:
522      *
523      * - `from` cannot be the zero address.
524      * - `to` cannot be the zero address.
525      * - `tokenId` token must exist and be owned by `from`.
526      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
527      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
528      *
529      * Emits a {Transfer} event.
530      */
531     function safeTransferFrom(
532         address from,
533         address to,
534         uint256 tokenId
535     ) external;
536 
537     /**
538      * @dev Transfers `tokenId` token from `from` to `to`.
539      *
540      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
541      *
542      * Requirements:
543      *
544      * - `from` cannot be the zero address.
545      * - `to` cannot be the zero address.
546      * - `tokenId` token must be owned by `from`.
547      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
548      *
549      * Emits a {Transfer} event.
550      */
551     function transferFrom(
552         address from,
553         address to,
554         uint256 tokenId
555     ) external;
556 
557     /**
558      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
559      * The approval is cleared when the token is transferred.
560      *
561      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
562      *
563      * Requirements:
564      *
565      * - The caller must own the token or be an approved operator.
566      * - `tokenId` must exist.
567      *
568      * Emits an {Approval} event.
569      */
570     function approve(address to, uint256 tokenId) external;
571 
572     /**
573      * @dev Returns the account approved for `tokenId` token.
574      *
575      * Requirements:
576      *
577      * - `tokenId` must exist.
578      */
579     function getApproved(uint256 tokenId) external view returns (address operator);
580 
581     /**
582      * @dev Approve or remove `operator` as an operator for the caller.
583      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
584      *
585      * Requirements:
586      *
587      * - The `operator` cannot be the caller.
588      *
589      * Emits an {ApprovalForAll} event.
590      */
591     function setApprovalForAll(address operator, bool _approved) external;
592 
593     /**
594      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
595      *
596      * See {setApprovalForAll}
597      */
598     function isApprovedForAll(address owner, address operator) external view returns (bool);
599 
600     /**
601      * @dev Safely transfers `tokenId` token from `from` to `to`.
602      *
603      * Requirements:
604      *
605      * - `from` cannot be the zero address.
606      * - `to` cannot be the zero address.
607      * - `tokenId` token must exist and be owned by `from`.
608      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
609      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
610      *
611      * Emits a {Transfer} event.
612      */
613     function safeTransferFrom(
614         address from,
615         address to,
616         uint256 tokenId,
617         bytes calldata data
618     ) external;
619 }
620 
621 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
622 
623 
624 
625 pragma solidity ^0.8.0;
626 
627 
628 /**
629  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
630  * @dev See https://eips.ethereum.org/EIPS/eip-721
631  */
632 interface IERC721Metadata is IERC721 {
633     /**
634      * @dev Returns the token collection name.
635      */
636     function name() external view returns (string memory);
637 
638     /**
639      * @dev Returns the token collection symbol.
640      */
641     function symbol() external view returns (string memory);
642 
643     /**
644      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
645      */
646     function tokenURI(uint256 tokenId) external view returns (string memory);
647 }
648 
649 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
650 
651 
652 
653 pragma solidity ^0.8.0;
654 
655 
656 
657 
658 
659 
660 
661 
662 /**
663  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
664  * the Metadata extension, but not including the Enumerable extension, which is available separately as
665  * {ERC721Enumerable}.
666  */
667 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
668     using Address for address;
669     using Strings for uint256;
670 
671     // Token name
672     string private _name;
673 
674     // Token symbol
675     string private _symbol;
676 
677     // Mapping from token ID to owner address
678     mapping(uint256 => address) private _owners;
679 
680     // Mapping owner address to token count
681     mapping(address => uint256) private _balances;
682 
683     // Mapping from token ID to approved address
684     mapping(uint256 => address) private _tokenApprovals;
685 
686     // Mapping from owner to operator approvals
687     mapping(address => mapping(address => bool)) private _operatorApprovals;
688 
689     /**
690      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
691      */
692     constructor(string memory name_, string memory symbol_) {
693         _name = name_;
694         _symbol = symbol_;
695     }
696 
697     /**
698      * @dev See {IERC165-supportsInterface}.
699      */
700     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
701         return
702             interfaceId == type(IERC721).interfaceId ||
703             interfaceId == type(IERC721Metadata).interfaceId ||
704             super.supportsInterface(interfaceId);
705     }
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
741     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
742         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
743 
744         string memory baseURI = _baseURI();
745         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
746     }
747 
748     /**
749      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
750      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
751      * by default, can be overriden in child contracts.
752      */
753     function _baseURI() internal view virtual returns (string memory) {
754         return "";
755     }
756 
757     /**
758      * @dev See {IERC721-approve}.
759      */
760     function approve(address to, uint256 tokenId) public virtual override {
761         address owner = ERC721.ownerOf(tokenId);
762         require(to != owner, "ERC721: approval to current owner");
763 
764         require(
765             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
766             "ERC721: approve caller is not owner nor approved for all"
767         );
768 
769         _approve(to, tokenId);
770     }
771 
772     /**
773      * @dev See {IERC721-getApproved}.
774      */
775     function getApproved(uint256 tokenId) public view virtual override returns (address) {
776         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
777 
778         return _tokenApprovals[tokenId];
779     }
780 
781     /**
782      * @dev See {IERC721-setApprovalForAll}.
783      */
784     function setApprovalForAll(address operator, bool approved) public virtual override {
785         require(operator != _msgSender(), "ERC721: approve to caller");
786 
787         _operatorApprovals[_msgSender()][operator] = approved;
788         emit ApprovalForAll(_msgSender(), operator, approved);
789     }
790 
791     /**
792      * @dev See {IERC721-isApprovedForAll}.
793      */
794     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
795         return _operatorApprovals[owner][operator];
796     }
797 
798     /**
799      * @dev See {IERC721-transferFrom}.
800      */
801     function transferFrom(
802         address from,
803         address to,
804         uint256 tokenId
805     ) public virtual override {
806         //solhint-disable-next-line max-line-length
807         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
808 
809         _transfer(from, to, tokenId);
810     }
811 
812     /**
813      * @dev See {IERC721-safeTransferFrom}.
814      */
815     function safeTransferFrom(
816         address from,
817         address to,
818         uint256 tokenId
819     ) public virtual override {
820         safeTransferFrom(from, to, tokenId, "");
821     }
822 
823     /**
824      * @dev See {IERC721-safeTransferFrom}.
825      */
826     function safeTransferFrom(
827         address from,
828         address to,
829         uint256 tokenId,
830         bytes memory _data
831     ) public virtual override {
832         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
833         _safeTransfer(from, to, tokenId, _data);
834     }
835 
836     /**
837      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
838      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
839      *
840      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
841      *
842      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
843      * implement alternative mechanisms to perform token transfer, such as signature-based.
844      *
845      * Requirements:
846      *
847      * - `from` cannot be the zero address.
848      * - `to` cannot be the zero address.
849      * - `tokenId` token must exist and be owned by `from`.
850      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
851      *
852      * Emits a {Transfer} event.
853      */
854     function _safeTransfer(
855         address from,
856         address to,
857         uint256 tokenId,
858         bytes memory _data
859     ) internal virtual {
860         _transfer(from, to, tokenId);
861         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
862     }
863 
864     /**
865      * @dev Returns whether `tokenId` exists.
866      *
867      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
868      *
869      * Tokens start existing when they are minted (`_mint`),
870      * and stop existing when they are burned (`_burn`).
871      */
872     function _exists(uint256 tokenId) internal view virtual returns (bool) {
873         return _owners[tokenId] != address(0);
874     }
875 
876     /**
877      * @dev Returns whether `spender` is allowed to manage `tokenId`.
878      *
879      * Requirements:
880      *
881      * - `tokenId` must exist.
882      */
883     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
884         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
885         address owner = ERC721.ownerOf(tokenId);
886         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
887     }
888 
889     /**
890      * @dev Safely mints `tokenId` and transfers it to `to`.
891      *
892      * Requirements:
893      *
894      * - `tokenId` must not exist.
895      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
896      *
897      * Emits a {Transfer} event.
898      */
899     function _safeMint(address to, uint256 tokenId) internal virtual {
900         _safeMint(to, tokenId, "");
901     }
902 
903     /**
904      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
905      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
906      */
907     function _safeMint(
908         address to,
909         uint256 tokenId,
910         bytes memory _data
911     ) internal virtual {
912         _mint(to, tokenId);
913         require(
914             _checkOnERC721Received(address(0), to, tokenId, _data),
915             "ERC721: transfer to non ERC721Receiver implementer"
916         );
917     }
918 
919     /**
920      * @dev Mints `tokenId` and transfers it to `to`.
921      *
922      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
923      *
924      * Requirements:
925      *
926      * - `tokenId` must not exist.
927      * - `to` cannot be the zero address.
928      *
929      * Emits a {Transfer} event.
930      */
931     function _mint(address to, uint256 tokenId) internal virtual {
932         require(to != address(0), "ERC721: mint to the zero address");
933         require(!_exists(tokenId), "ERC721: token already minted");
934 
935         _beforeTokenTransfer(address(0), to, tokenId);
936 
937         _balances[to] += 1;
938         _owners[tokenId] = to;
939 
940         emit Transfer(address(0), to, tokenId);
941     }
942 
943     /**
944      * @dev Destroys `tokenId`.
945      * The approval is cleared when the token is burned.
946      *
947      * Requirements:
948      *
949      * - `tokenId` must exist.
950      *
951      * Emits a {Transfer} event.
952      */
953     function _burn(uint256 tokenId) internal virtual {
954         address owner = ERC721.ownerOf(tokenId);
955 
956         _beforeTokenTransfer(owner, address(0), tokenId);
957 
958         // Clear approvals
959         _approve(address(0), tokenId);
960 
961         _balances[owner] -= 1;
962         delete _owners[tokenId];
963 
964         emit Transfer(owner, address(0), tokenId);
965     }
966 
967     /**
968      * @dev Transfers `tokenId` from `from` to `to`.
969      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
970      *
971      * Requirements:
972      *
973      * - `to` cannot be the zero address.
974      * - `tokenId` token must be owned by `from`.
975      *
976      * Emits a {Transfer} event.
977      */
978     function _transfer(
979         address from,
980         address to,
981         uint256 tokenId
982     ) internal virtual {
983         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
984         require(to != address(0), "ERC721: transfer to the zero address");
985 
986         _beforeTokenTransfer(from, to, tokenId);
987 
988         // Clear approvals from the previous owner
989         _approve(address(0), tokenId);
990 
991         _balances[from] -= 1;
992         _balances[to] += 1;
993         _owners[tokenId] = to;
994 
995         emit Transfer(from, to, tokenId);
996     }
997 
998     /**
999      * @dev Approve `to` to operate on `tokenId`
1000      *
1001      * Emits a {Approval} event.
1002      */
1003     function _approve(address to, uint256 tokenId) internal virtual {
1004         _tokenApprovals[tokenId] = to;
1005         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1006     }
1007 
1008     /**
1009      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1010      * The call is not executed if the target address is not a contract.
1011      *
1012      * @param from address representing the previous owner of the given token ID
1013      * @param to target address that will receive the tokens
1014      * @param tokenId uint256 ID of the token to be transferred
1015      * @param _data bytes optional data to send along with the call
1016      * @return bool whether the call correctly returned the expected magic value
1017      */
1018     function _checkOnERC721Received(
1019         address from,
1020         address to,
1021         uint256 tokenId,
1022         bytes memory _data
1023     ) private returns (bool) {
1024         if (to.isContract()) {
1025             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1026                 return retval == IERC721Receiver.onERC721Received.selector;
1027             } catch (bytes memory reason) {
1028                 if (reason.length == 0) {
1029                     revert("ERC721: transfer to non ERC721Receiver implementer");
1030                 } else {
1031                     assembly {
1032                         revert(add(32, reason), mload(reason))
1033                     }
1034                 }
1035             }
1036         } else {
1037             return true;
1038         }
1039     }
1040 
1041     /**
1042      * @dev Hook that is called before any token transfer. This includes minting
1043      * and burning.
1044      *
1045      * Calling conditions:
1046      *
1047      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1048      * transferred to `to`.
1049      * - When `from` is zero, `tokenId` will be minted for `to`.
1050      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1051      * - `from` and `to` are never both zero.
1052      *
1053      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1054      */
1055     function _beforeTokenTransfer(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) internal virtual {}
1060 }
1061 
1062 // File: contracts/SpaceKubz.sol
1063 
1064 pragma solidity ^0.8.0;
1065 
1066 
1067 
1068 contract SpaceKubz is ERC721, Ownable {
1069 
1070     bool public saleActive = false;
1071     bool public presaleActive = false;
1072    
1073     string internal baseTokenURI;
1074 
1075     uint public price = 0.11 ether;
1076     uint public totalSupply = 8888;
1077     uint public nonce = 0;
1078     uint public maxTx = 8;
1079    
1080     event Mint(address owner, uint qty);
1081     event Giveaway(address to, uint qty);
1082     event Withdraw(uint amount);
1083 
1084     mapping (address => uint256) public presaleWallets;
1085     mapping (address => bool) public presaleWalletsList;
1086     constructor() ERC721("Space Kubz", "KUBZ") {}
1087    
1088     function setPrice(uint newPrice) external onlyOwner {
1089         price = newPrice;
1090     }
1091    
1092     function setBaseTokenURI(string calldata _uri) external onlyOwner {
1093         baseTokenURI = _uri;
1094     }
1095    
1096     function setTotalSupply(uint newSupply) external onlyOwner {
1097         totalSupply = newSupply;
1098     }
1099 
1100     function setPresaleActive(bool val) public onlyOwner {
1101         presaleActive = val;
1102     }
1103 
1104     function setSaleActive(bool val) public onlyOwner {
1105         saleActive = val;
1106     }
1107 
1108     function setPresaleWallets(address[] memory _a, uint256[] memory _amount) public onlyOwner {
1109         for(uint256 i; i < _a.length; i++){
1110             presaleWallets[_a[i]] = _amount[i];
1111             setWallet(_a[i]);
1112         }
1113     }
1114 
1115     function editPresaleWallets(address[] memory _a, uint256[] memory _amount) public onlyOwner {
1116         for(uint256 i; i < _a.length; i++){
1117             presaleWallets[_a[i]] = _amount[i];
1118             //presaleWallets[_a[i]+presaleWallets.length] = _amount[i];
1119             setWallet(_a[i]);
1120         }
1121     }
1122 
1123    
1124     function setMaxTx(uint newMax) external onlyOwner {
1125         maxTx = newMax;
1126     }
1127    
1128     function getAssetsByOwner(address _owner) public view returns(uint[] memory) {
1129         uint[] memory result = new uint[](balanceOf(_owner));
1130         uint counter = 0;
1131         for (uint i = 0; i < nonce; i++) {
1132             if (ownerOf(i) == _owner) {
1133                 result[counter] = i;
1134                 counter++;
1135             }
1136         }
1137         return result;
1138     }
1139    
1140     function getMyAssets() external view returns(uint[] memory){
1141         return getAssetsByOwner(tx.origin);
1142     }
1143 
1144     function _baseURI() internal override view returns (string memory) {
1145         return baseTokenURI;
1146     }
1147    
1148     function giveaway(address to, uint qty) external onlyOwner {
1149         require(qty + nonce <= totalSupply, "SUPPLY: Value exceeds totalSupply");
1150         for(uint i = 0; i < qty; i++){
1151             uint tokenId = nonce;
1152             _safeMint(to, tokenId);
1153             nonce++;
1154         }
1155         emit Giveaway(to, qty);
1156     }
1157 
1158     function buyPresale(uint qty) external payable {
1159         uint256 qtyAllowed = presaleWallets[msg.sender];
1160         require(presaleActive, "TRANSACTION: Presale is not active");
1161         require(contains(msg.sender), "TRANSACTION: You can't mint on presale");
1162         require(qtyAllowed > 0, "TRANSACTION: You can't mint on presale");
1163         require(qty + nonce <= totalSupply, "SUPPLY: max supply exceeded");
1164         require(qty <= qtyAllowed, "TRANSACTION: Mint amount authorized should be less");
1165         require(msg.value == price * qty, "PAYMENT: incorrect Ether value");
1166         presaleWallets[msg.sender] = qtyAllowed - qty;
1167         for(uint i = 0; i < qty; i++){
1168             uint tokenId = nonce;
1169             _safeMint(msg.sender, tokenId);
1170             nonce++;
1171         }
1172         emit Mint(msg.sender, qty);
1173     }
1174    
1175     function buy(uint qty) external payable {
1176         require(saleActive, "TRANSACTION: sale is not active");
1177         require(qty <= maxTx && qty > 0, "TRANSACTION: qty of mints not alowed");
1178         require(qty + nonce <= totalSupply, "SUPPLY: max supply exceeded");
1179         require(msg.value == price * qty, "PAYMENT: incorrect Ether value");
1180         for(uint i = 0; i < qty; i++){
1181             uint tokenId = nonce;
1182             _safeMint(msg.sender, tokenId);
1183             nonce++;
1184         }
1185         emit Mint(msg.sender, qty);
1186     }
1187    
1188     function withdrawOwner() external onlyOwner {
1189         payable(msg.sender).transfer(address(this).balance);
1190     }
1191 
1192 
1193     function setWallet(address _wallet) private {
1194         presaleWalletsList[_wallet]=true;
1195     }
1196 
1197     function contains(address _wallet) private returns (bool){
1198         return presaleWalletsList[_wallet];
1199     }
1200 }