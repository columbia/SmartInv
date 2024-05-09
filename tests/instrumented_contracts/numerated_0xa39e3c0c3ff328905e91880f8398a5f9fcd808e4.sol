1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 /*
6 This smart contract, and ownership of the NFT associated with it,
7 is governed by the terms and conditions located on quartermachine.io (the “Terms”). 
8 By purchasing the NFT on which this smart contract appears, you agree to be bound by the Terms.
9 */
10 
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev String operations.
16  */
17 library Strings {
18     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
19 
20     /**
21      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
22      */
23     function toString(uint256 value) internal pure returns (string memory) {
24         // Inspired by OraclizeAPI's implementation - MIT licence
25         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
26 
27         if (value == 0) {
28             return "0";
29         }
30         uint256 temp = value;
31         uint256 digits;
32         while (temp != 0) {
33             digits++;
34             temp /= 10;
35         }
36         bytes memory buffer = new bytes(digits);
37         while (value != 0) {
38             digits -= 1;
39             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
40             value /= 10;
41         }
42         return string(buffer);
43     }
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
47      */
48     function toHexString(uint256 value) internal pure returns (string memory) {
49         if (value == 0) {
50             return "0x00";
51         }
52         uint256 temp = value;
53         uint256 length = 0;
54         while (temp != 0) {
55             length++;
56             temp >>= 8;
57         }
58         return toHexString(value, length);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
63      */
64     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
65         bytes memory buffer = new bytes(2 * length + 2);
66         buffer[0] = "0";
67         buffer[1] = "x";
68         for (uint256 i = 2 * length + 1; i > 1; --i) {
69             buffer[i] = _HEX_SYMBOLS[value & 0xf];
70             value >>= 4;
71         }
72         require(value == 0, "Strings: hex length insufficient");
73         return string(buffer);
74     }
75 }
76 
77 // File: @openzeppelin/contracts/utils/Context.sol
78 
79 
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @dev Provides information about the current execution context, including the
85  * sender of the transaction and its data. While these are generally available
86  * via msg.sender and msg.data, they should not be accessed in such a direct
87  * manner, since when dealing with meta-transactions the account sending and
88  * paying for execution may not be the actual sender (as far as an application
89  * is concerned).
90  *
91  * This contract is only required for intermediate, library-like contracts.
92  */
93 abstract contract Context {
94     function _msgSender() internal view virtual returns (address) {
95         return msg.sender;
96     }
97 
98     function _msgData() internal view virtual returns (bytes calldata) {
99         return msg.data;
100     }
101 }
102 
103 // File: @openzeppelin/contracts/access/Ownable.sol
104 
105 
106 
107 pragma solidity ^0.8.0;
108 
109 
110 /**
111  * @dev Contract module which provides a basic access control mechanism, where
112  * there is an account (an owner) that can be granted exclusive access to
113  * specific functions.
114  *
115  * By default, the owner account will be the one that deploys the contract. This
116  * can later be changed with {transferOwnership}.
117  *
118  * This module is used through inheritance. It will make available the modifier
119  * `onlyOwner`, which can be applied to your functions to restrict their use to
120  * the owner.
121  */
122 abstract contract Ownable is Context {
123     address private _owner;
124 
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     /**
128      * @dev Initializes the contract setting the deployer as the initial owner.
129      */
130     constructor() {
131         _setOwner(_msgSender());
132     }
133 
134     /**
135      * @dev Returns the address of the current owner.
136      */
137     function owner() public view virtual returns (address) {
138         return _owner;
139     }
140 
141     /**
142      * @dev Throws if called by any account other than the owner.
143      */
144     modifier onlyOwner() {
145         require(owner() == _msgSender(), "Ownable: caller is not the owner");
146         _;
147     }
148 
149     /**
150      * @dev Leaves the contract without owner. It will not be possible to call
151      * `onlyOwner` functions anymore. Can only be called by the current owner.
152      *
153      * NOTE: Renouncing ownership will leave the contract without an owner,
154      * thereby removing any functionality that is only available to the owner.
155      */
156     function renounceOwnership() public virtual onlyOwner {
157         _setOwner(address(0));
158     }
159 
160     /**
161      * @dev Transfers ownership of the contract to a new account (`newOwner`).
162      * Can only be called by the current owner.
163      */
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(newOwner != address(0), "Ownable: new owner is the zero address");
166         _setOwner(newOwner);
167     }
168 
169     function _setOwner(address newOwner) private {
170         address oldOwner = _owner;
171         _owner = newOwner;
172         emit OwnershipTransferred(oldOwner, newOwner);
173     }
174 }
175 
176 // File: @openzeppelin/contracts/utils/Address.sol
177 
178 
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @dev Collection of functions related to the address type
184  */
185 library Address {
186     /**
187      * @dev Returns true if `account` is a contract.
188      *
189      * [IMPORTANT]
190      * ====
191      * It is unsafe to assume that an address for which this function returns
192      * false is an externally-owned account (EOA) and not a contract.
193      *
194      * Among others, `isContract` will return false for the following
195      * types of addresses:
196      *
197      *  - an externally-owned account
198      *  - a contract in construction
199      *  - an address where a contract will be created
200      *  - an address where a contract lived, but was destroyed
201      * ====
202      */
203     function isContract(address account) internal view returns (bool) {
204         // This method relies on extcodesize, which returns 0 for contracts in
205         // construction, since the code is only stored at the end of the
206         // constructor execution.
207 
208         uint256 size;
209         assembly {
210             size := extcodesize(account)
211         }
212         return size > 0;
213     }
214 
215     /**
216      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
217      * `recipient`, forwarding all available gas and reverting on errors.
218      *
219      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
220      * of certain opcodes, possibly making contracts go over the 2300 gas limit
221      * imposed by `transfer`, making them unable to receive funds via
222      * `transfer`. {sendValue} removes this limitation.
223      *
224      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
225      *
226      * IMPORTANT: because control is transferred to `recipient`, care must be
227      * taken to not create reentrancy vulnerabilities. Consider using
228      * {ReentrancyGuard} or the
229      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
230      */
231     function sendValue(address payable recipient, uint256 amount) internal {
232         require(address(this).balance >= amount, "Address: insufficient balance");
233 
234         (bool success, ) = recipient.call{value: amount}("");
235         require(success, "Address: unable to send value, recipient may have reverted");
236     }
237 
238     /**
239      * @dev Performs a Solidity function call using a low level `call`. A
240      * plain `call` is an unsafe replacement for a function call: use this
241      * function instead.
242      *
243      * If `target` reverts with a revert reason, it is bubbled up by this
244      * function (like regular Solidity function calls).
245      *
246      * Returns the raw returned data. To convert to the expected return value,
247      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
248      *
249      * Requirements:
250      *
251      * - `target` must be a contract.
252      * - calling `target` with `data` must not revert.
253      *
254      * _Available since v3.1._
255      */
256     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
257         return functionCall(target, data, "Address: low-level call failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
262      * `errorMessage` as a fallback revert reason when `target` reverts.
263      *
264      * _Available since v3.1._
265      */
266     function functionCall(
267         address target,
268         bytes memory data,
269         string memory errorMessage
270     ) internal returns (bytes memory) {
271         return functionCallWithValue(target, data, 0, errorMessage);
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
276      * but also transferring `value` wei to `target`.
277      *
278      * Requirements:
279      *
280      * - the calling contract must have an ETH balance of at least `value`.
281      * - the called Solidity function must be `payable`.
282      *
283      * _Available since v3.1._
284      */
285     function functionCallWithValue(
286         address target,
287         bytes memory data,
288         uint256 value
289     ) internal returns (bytes memory) {
290         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
295      * with `errorMessage` as a fallback revert reason when `target` reverts.
296      *
297      * _Available since v3.1._
298      */
299     function functionCallWithValue(
300         address target,
301         bytes memory data,
302         uint256 value,
303         string memory errorMessage
304     ) internal returns (bytes memory) {
305         require(address(this).balance >= value, "Address: insufficient balance for call");
306         require(isContract(target), "Address: call to non-contract");
307 
308         (bool success, bytes memory returndata) = target.call{value: value}(data);
309         return verifyCallResult(success, returndata, errorMessage);
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
314      * but performing a static call.
315      *
316      * _Available since v3.3._
317      */
318     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
319         return functionStaticCall(target, data, "Address: low-level static call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
324      * but performing a static call.
325      *
326      * _Available since v3.3._
327      */
328     function functionStaticCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal view returns (bytes memory) {
333         require(isContract(target), "Address: static call to non-contract");
334 
335         (bool success, bytes memory returndata) = target.staticcall(data);
336         return verifyCallResult(success, returndata, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but performing a delegate call.
342      *
343      * _Available since v3.4._
344      */
345     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
346         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
351      * but performing a delegate call.
352      *
353      * _Available since v3.4._
354      */
355     function functionDelegateCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal returns (bytes memory) {
360         require(isContract(target), "Address: delegate call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.delegatecall(data);
363         return verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
368      * revert reason using the provided one.
369      *
370      * _Available since v4.3._
371      */
372     function verifyCallResult(
373         bool success,
374         bytes memory returndata,
375         string memory errorMessage
376     ) internal pure returns (bytes memory) {
377         if (success) {
378             return returndata;
379         } else {
380             // Look for revert reason and bubble it up if present
381             if (returndata.length > 0) {
382                 // The easiest way to bubble the revert reason is using memory via assembly
383 
384                 assembly {
385                     let returndata_size := mload(returndata)
386                     revert(add(32, returndata), returndata_size)
387                 }
388             } else {
389                 revert(errorMessage);
390             }
391         }
392     }
393 }
394 
395 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
396 
397 
398 
399 pragma solidity ^0.8.0;
400 
401 /**
402  * @title ERC721 token receiver interface
403  * @dev Interface for any contract that wants to support safeTransfers
404  * from ERC721 asset contracts.
405  */
406 interface IERC721Receiver {
407     /**
408      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
409      * by `operator` from `from`, this function is called.
410      *
411      * It must return its Solidity selector to confirm the token transfer.
412      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
413      *
414      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
415      */
416     function onERC721Received(
417         address operator,
418         address from,
419         uint256 tokenId,
420         bytes calldata data
421     ) external returns (bytes4);
422 }
423 
424 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
425 
426 
427 
428 pragma solidity ^0.8.0;
429 
430 /**
431  * @dev Interface of the ERC165 standard, as defined in the
432  * https://eips.ethereum.org/EIPS/eip-165[EIP].
433  *
434  * Implementers can declare support of contract interfaces, which can then be
435  * queried by others ({ERC165Checker}).
436  *
437  * For an implementation, see {ERC165}.
438  */
439 interface IERC165 {
440     /**
441      * @dev Returns true if this contract implements the interface defined by
442      * `interfaceId`. See the corresponding
443      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
444      * to learn more about how these ids are created.
445      *
446      * This function call must use less than 30 000 gas.
447      */
448     function supportsInterface(bytes4 interfaceId) external view returns (bool);
449 }
450 
451 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
452 
453 
454 
455 pragma solidity ^0.8.0;
456 
457 
458 /**
459  * @dev Implementation of the {IERC165} interface.
460  *
461  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
462  * for the additional interface id that will be supported. For example:
463  *
464  * ```solidity
465  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
466  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
467  * }
468  * ```
469  *
470  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
471  */
472 abstract contract ERC165 is IERC165 {
473     /**
474      * @dev See {IERC165-supportsInterface}.
475      */
476     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
477         return interfaceId == type(IERC165).interfaceId;
478     }
479 }
480 
481 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
482 
483 
484 
485 pragma solidity ^0.8.0;
486 
487 
488 /**
489  * @dev Required interface of an ERC721 compliant contract.
490  */
491 interface IERC721 is IERC165 {
492     /**
493      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
494      */
495     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
496 
497     /**
498      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
499      */
500     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
501 
502     /**
503      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
504      */
505     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
506 
507     /**
508      * @dev Returns the number of tokens in ``owner``'s account.
509      */
510     function balanceOf(address owner) external view returns (uint256 balance);
511 
512     /**
513      * @dev Returns the owner of the `tokenId` token.
514      *
515      * Requirements:
516      *
517      * - `tokenId` must exist.
518      */
519     function ownerOf(uint256 tokenId) external view returns (address owner);
520 
521     /**
522      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
523      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
524      *
525      * Requirements:
526      *
527      * - `from` cannot be the zero address.
528      * - `to` cannot be the zero address.
529      * - `tokenId` token must exist and be owned by `from`.
530      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
531      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
532      *
533      * Emits a {Transfer} event.
534      */
535     function safeTransferFrom(
536         address from,
537         address to,
538         uint256 tokenId
539     ) external;
540 
541     /**
542      * @dev Transfers `tokenId` token from `from` to `to`.
543      *
544      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
545      *
546      * Requirements:
547      *
548      * - `from` cannot be the zero address.
549      * - `to` cannot be the zero address.
550      * - `tokenId` token must be owned by `from`.
551      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
552      *
553      * Emits a {Transfer} event.
554      */
555     function transferFrom(
556         address from,
557         address to,
558         uint256 tokenId
559     ) external;
560 
561     /**
562      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
563      * The approval is cleared when the token is transferred.
564      *
565      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
566      *
567      * Requirements:
568      *
569      * - The caller must own the token or be an approved operator.
570      * - `tokenId` must exist.
571      *
572      * Emits an {Approval} event.
573      */
574     function approve(address to, uint256 tokenId) external;
575 
576     /**
577      * @dev Returns the account approved for `tokenId` token.
578      *
579      * Requirements:
580      *
581      * - `tokenId` must exist.
582      */
583     function getApproved(uint256 tokenId) external view returns (address operator);
584 
585     /**
586      * @dev Approve or remove `operator` as an operator for the caller.
587      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
588      *
589      * Requirements:
590      *
591      * - The `operator` cannot be the caller.
592      *
593      * Emits an {ApprovalForAll} event.
594      */
595     function setApprovalForAll(address operator, bool _approved) external;
596 
597     /**
598      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
599      *
600      * See {setApprovalForAll}
601      */
602     function isApprovedForAll(address owner, address operator) external view returns (bool);
603 
604     /**
605      * @dev Safely transfers `tokenId` token from `from` to `to`.
606      *
607      * Requirements:
608      *
609      * - `from` cannot be the zero address.
610      * - `to` cannot be the zero address.
611      * - `tokenId` token must exist and be owned by `from`.
612      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
613      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
614      *
615      * Emits a {Transfer} event.
616      */
617     function safeTransferFrom(
618         address from,
619         address to,
620         uint256 tokenId,
621         bytes calldata data
622     ) external;
623 }
624 
625 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
626 
627 
628 
629 pragma solidity ^0.8.0;
630 
631 
632 /**
633  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
634  * @dev See https://eips.ethereum.org/EIPS/eip-721
635  */
636 interface IERC721Enumerable is IERC721 {
637     /**
638      * @dev Returns the total amount of tokens stored by the contract.
639      */
640     function totalSupply() external view returns (uint256);
641 
642     /**
643      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
644      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
645      */
646     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
647 
648     /**
649      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
650      * Use along with {totalSupply} to enumerate all tokens.
651      */
652     function tokenByIndex(uint256 index) external view returns (uint256);
653 }
654 
655 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
656 
657 
658 
659 pragma solidity ^0.8.0;
660 
661 
662 /**
663  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
664  * @dev See https://eips.ethereum.org/EIPS/eip-721
665  */
666 interface IERC721Metadata is IERC721 {
667     /**
668      * @dev Returns the token collection name.
669      */
670     function name() external view returns (string memory);
671 
672     /**
673      * @dev Returns the token collection symbol.
674      */
675     function symbol() external view returns (string memory);
676 
677     /**
678      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
679      */
680     function tokenURI(uint256 tokenId) external view returns (string memory);
681 }
682 
683 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
684 
685 
686 
687 pragma solidity ^0.8.0;
688 
689 
690 
691 
692 
693 
694 
695 
696 /**
697  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
698  * the Metadata extension, but not including the Enumerable extension, which is available separately as
699  * {ERC721Enumerable}.
700  */
701 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
702     using Address for address;
703     using Strings for uint256;
704 
705     // Token name
706     string private _name;
707 
708     // Token symbol
709     string private _symbol;
710 
711     // Mapping from token ID to owner address
712     mapping(uint256 => address) private _owners;
713 
714     // Mapping owner address to token count
715     mapping(address => uint256) private _balances;
716 
717     // Mapping from token ID to approved address
718     mapping(uint256 => address) private _tokenApprovals;
719 
720     // Mapping from owner to operator approvals
721     mapping(address => mapping(address => bool)) private _operatorApprovals;
722 
723     /**
724      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
725      */
726     constructor(string memory name_, string memory symbol_) {
727         _name = name_;
728         _symbol = symbol_;
729     }
730 
731     /**
732      * @dev See {IERC165-supportsInterface}.
733      */
734     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
735         return
736             interfaceId == type(IERC721).interfaceId ||
737             interfaceId == type(IERC721Metadata).interfaceId ||
738             super.supportsInterface(interfaceId);
739     }
740 
741     /**
742      * @dev See {IERC721-balanceOf}.
743      */
744     function balanceOf(address owner) public view virtual override returns (uint256) {
745         require(owner != address(0), "ERC721: balance query for the zero address");
746         return _balances[owner];
747     }
748 
749     /**
750      * @dev See {IERC721-ownerOf}.
751      */
752     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
753         address owner = _owners[tokenId];
754         require(owner != address(0), "ERC721: owner query for nonexistent token");
755         return owner;
756     }
757 
758     /**
759      * @dev See {IERC721Metadata-name}.
760      */
761     function name() public view virtual override returns (string memory) {
762         return _name;
763     }
764 
765     /**
766      * @dev See {IERC721Metadata-symbol}.
767      */
768     function symbol() public view virtual override returns (string memory) {
769         return _symbol;
770     }
771 
772     /**
773      * @dev See {IERC721Metadata-tokenURI}.
774      */
775     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
776         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
777 
778         string memory baseURI = _baseURI();
779         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
780     }
781 
782     /**
783      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
784      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
785      * by default, can be overriden in child contracts.
786      */
787     function _baseURI() internal view virtual returns (string memory) {
788         return "";
789     }
790 
791     /**
792      * @dev See {IERC721-approve}.
793      */
794     function approve(address to, uint256 tokenId) public virtual override {
795         address owner = ERC721.ownerOf(tokenId);
796         require(to != owner, "ERC721: approval to current owner");
797 
798         require(
799             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
800             "ERC721: approve caller is not owner nor approved for all"
801         );
802 
803         _approve(to, tokenId);
804     }
805 
806     /**
807      * @dev See {IERC721-getApproved}.
808      */
809     function getApproved(uint256 tokenId) public view virtual override returns (address) {
810         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
811 
812         return _tokenApprovals[tokenId];
813     }
814 
815     /**
816      * @dev See {IERC721-setApprovalForAll}.
817      */
818     function setApprovalForAll(address operator, bool approved) public virtual override {
819         require(operator != _msgSender(), "ERC721: approve to caller");
820 
821         _operatorApprovals[_msgSender()][operator] = approved;
822         emit ApprovalForAll(_msgSender(), operator, approved);
823     }
824 
825     /**
826      * @dev See {IERC721-isApprovedForAll}.
827      */
828     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
829         return _operatorApprovals[owner][operator];
830     }
831 
832     /**
833      * @dev See {IERC721-transferFrom}.
834      */
835     function transferFrom(
836         address from,
837         address to,
838         uint256 tokenId
839     ) public virtual override {
840         //solhint-disable-next-line max-line-length
841         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
842 
843         _transfer(from, to, tokenId);
844     }
845 
846     /**
847      * @dev See {IERC721-safeTransferFrom}.
848      */
849     function safeTransferFrom(
850         address from,
851         address to,
852         uint256 tokenId
853     ) public virtual override {
854         safeTransferFrom(from, to, tokenId, "");
855     }
856 
857     /**
858      * @dev See {IERC721-safeTransferFrom}.
859      */
860     function safeTransferFrom(
861         address from,
862         address to,
863         uint256 tokenId,
864         bytes memory _data
865     ) public virtual override {
866         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
867         _safeTransfer(from, to, tokenId, _data);
868     }
869 
870     /**
871      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
872      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
873      *
874      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
875      *
876      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
877      * implement alternative mechanisms to perform token transfer, such as signature-based.
878      *
879      * Requirements:
880      *
881      * - `from` cannot be the zero address.
882      * - `to` cannot be the zero address.
883      * - `tokenId` token must exist and be owned by `from`.
884      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _safeTransfer(
889         address from,
890         address to,
891         uint256 tokenId,
892         bytes memory _data
893     ) internal virtual {
894         _transfer(from, to, tokenId);
895         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
896     }
897 
898     /**
899      * @dev Returns whether `tokenId` exists.
900      *
901      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
902      *
903      * Tokens start existing when they are minted (`_mint`),
904      * and stop existing when they are burned (`_burn`).
905      */
906     function _exists(uint256 tokenId) internal view virtual returns (bool) {
907         return _owners[tokenId] != address(0);
908     }
909 
910     /**
911      * @dev Returns whether `spender` is allowed to manage `tokenId`.
912      *
913      * Requirements:
914      *
915      * - `tokenId` must exist.
916      */
917     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
918         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
919         address owner = ERC721.ownerOf(tokenId);
920         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
921     }
922 
923     /**
924      * @dev Safely mints `tokenId` and transfers it to `to`.
925      *
926      * Requirements:
927      *
928      * - `tokenId` must not exist.
929      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
930      *
931      * Emits a {Transfer} event.
932      */
933     function _safeMint(address to, uint256 tokenId) internal virtual {
934         _safeMint(to, tokenId, "");
935     }
936 
937     /**
938      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
939      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
940      */
941     function _safeMint(
942         address to,
943         uint256 tokenId,
944         bytes memory _data
945     ) internal virtual {
946         _mint(to, tokenId);
947         require(
948             _checkOnERC721Received(address(0), to, tokenId, _data),
949             "ERC721: transfer to non ERC721Receiver implementer"
950         );
951     }
952 
953     /**
954      * @dev Mints `tokenId` and transfers it to `to`.
955      *
956      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
957      *
958      * Requirements:
959      *
960      * - `tokenId` must not exist.
961      * - `to` cannot be the zero address.
962      *
963      * Emits a {Transfer} event.
964      */
965     function _mint(address to, uint256 tokenId) internal virtual {
966         require(to != address(0), "ERC721: mint to the zero address");
967         require(!_exists(tokenId), "ERC721: token already minted");
968 
969         _beforeTokenTransfer(address(0), to, tokenId);
970 
971         _balances[to] += 1;
972         _owners[tokenId] = to;
973 
974         emit Transfer(address(0), to, tokenId);
975     }
976 
977     /**
978      * @dev Destroys `tokenId`.
979      * The approval is cleared when the token is burned.
980      *
981      * Requirements:
982      *
983      * - `tokenId` must exist.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _burn(uint256 tokenId) internal virtual {
988         address owner = ERC721.ownerOf(tokenId);
989 
990         _beforeTokenTransfer(owner, address(0), tokenId);
991 
992         // Clear approvals
993         _approve(address(0), tokenId);
994 
995         _balances[owner] -= 1;
996         delete _owners[tokenId];
997 
998         emit Transfer(owner, address(0), tokenId);
999     }
1000 
1001     /**
1002      * @dev Transfers `tokenId` from `from` to `to`.
1003      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1004      *
1005      * Requirements:
1006      *
1007      * - `to` cannot be the zero address.
1008      * - `tokenId` token must be owned by `from`.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function _transfer(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) internal virtual {
1017         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1018         require(to != address(0), "ERC721: transfer to the zero address");
1019 
1020         _beforeTokenTransfer(from, to, tokenId);
1021 
1022         // Clear approvals from the previous owner
1023         _approve(address(0), tokenId);
1024 
1025         _balances[from] -= 1;
1026         _balances[to] += 1;
1027         _owners[tokenId] = to;
1028 
1029         emit Transfer(from, to, tokenId);
1030     }
1031 
1032     /**
1033      * @dev Approve `to` to operate on `tokenId`
1034      *
1035      * Emits a {Approval} event.
1036      */
1037     function _approve(address to, uint256 tokenId) internal virtual {
1038         _tokenApprovals[tokenId] = to;
1039         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1040     }
1041 
1042     /**
1043      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1044      * The call is not executed if the target address is not a contract.
1045      *
1046      * @param from address representing the previous owner of the given token ID
1047      * @param to target address that will receive the tokens
1048      * @param tokenId uint256 ID of the token to be transferred
1049      * @param _data bytes optional data to send along with the call
1050      * @return bool whether the call correctly returned the expected magic value
1051      */
1052     function _checkOnERC721Received(
1053         address from,
1054         address to,
1055         uint256 tokenId,
1056         bytes memory _data
1057     ) private returns (bool) {
1058         if (to.isContract()) {
1059             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1060                 return retval == IERC721Receiver.onERC721Received.selector;
1061             } catch (bytes memory reason) {
1062                 if (reason.length == 0) {
1063                     revert("ERC721: transfer to non ERC721Receiver implementer");
1064                 } else {
1065                     assembly {
1066                         revert(add(32, reason), mload(reason))
1067                     }
1068                 }
1069             }
1070         } else {
1071             return true;
1072         }
1073     }
1074 
1075     /**
1076      * @dev Hook that is called before any token transfer. This includes minting
1077      * and burning.
1078      *
1079      * Calling conditions:
1080      *
1081      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1082      * transferred to `to`.
1083      * - When `from` is zero, `tokenId` will be minted for `to`.
1084      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1085      * - `from` and `to` are never both zero.
1086      *
1087      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1088      */
1089     function _beforeTokenTransfer(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) internal virtual {}
1094 }
1095 
1096 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1097 
1098 
1099 
1100 pragma solidity ^0.8.0;
1101 
1102 
1103 
1104 /**
1105  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1106  * enumerability of all the token ids in the contract as well as all token ids owned by each
1107  * account.
1108  */
1109 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1110     // Mapping from owner to list of owned token IDs
1111     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1112 
1113     // Mapping from token ID to index of the owner tokens list
1114     mapping(uint256 => uint256) private _ownedTokensIndex;
1115 
1116     // Array with all token ids, used for enumeration
1117     uint256[] private _allTokens;
1118 
1119     // Mapping from token id to position in the allTokens array
1120     mapping(uint256 => uint256) private _allTokensIndex;
1121 
1122     /**
1123      * @dev See {IERC165-supportsInterface}.
1124      */
1125     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1126         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1127     }
1128 
1129     /**
1130      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1131      */
1132     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1133         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1134         return _ownedTokens[owner][index];
1135     }
1136 
1137     /**
1138      * @dev See {IERC721Enumerable-totalSupply}.
1139      */
1140     function totalSupply() public view virtual override returns (uint256) {
1141         return _allTokens.length;
1142     }
1143 
1144     /**
1145      * @dev See {IERC721Enumerable-tokenByIndex}.
1146      */
1147     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1148         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1149         return _allTokens[index];
1150     }
1151 
1152     /**
1153      * @dev Hook that is called before any token transfer. This includes minting
1154      * and burning.
1155      *
1156      * Calling conditions:
1157      *
1158      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1159      * transferred to `to`.
1160      * - When `from` is zero, `tokenId` will be minted for `to`.
1161      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1162      * - `from` cannot be the zero address.
1163      * - `to` cannot be the zero address.
1164      *
1165      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1166      */
1167     function _beforeTokenTransfer(
1168         address from,
1169         address to,
1170         uint256 tokenId
1171     ) internal virtual override {
1172         super._beforeTokenTransfer(from, to, tokenId);
1173 
1174         if (from == address(0)) {
1175             _addTokenToAllTokensEnumeration(tokenId);
1176         } else if (from != to) {
1177             _removeTokenFromOwnerEnumeration(from, tokenId);
1178         }
1179         if (to == address(0)) {
1180             _removeTokenFromAllTokensEnumeration(tokenId);
1181         } else if (to != from) {
1182             _addTokenToOwnerEnumeration(to, tokenId);
1183         }
1184     }
1185 
1186     /**
1187      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1188      * @param to address representing the new owner of the given token ID
1189      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1190      */
1191     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1192         uint256 length = ERC721.balanceOf(to);
1193         _ownedTokens[to][length] = tokenId;
1194         _ownedTokensIndex[tokenId] = length;
1195     }
1196 
1197     /**
1198      * @dev Private function to add a token to this extension's token tracking data structures.
1199      * @param tokenId uint256 ID of the token to be added to the tokens list
1200      */
1201     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1202         _allTokensIndex[tokenId] = _allTokens.length;
1203         _allTokens.push(tokenId);
1204     }
1205 
1206     /**
1207      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1208      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1209      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1210      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1211      * @param from address representing the previous owner of the given token ID
1212      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1213      */
1214     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1215         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1216         // then delete the last slot (swap and pop).
1217 
1218         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1219         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1220 
1221         // When the token to delete is the last token, the swap operation is unnecessary
1222         if (tokenIndex != lastTokenIndex) {
1223             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1224 
1225             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1226             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1227         }
1228 
1229         // This also deletes the contents at the last position of the array
1230         delete _ownedTokensIndex[tokenId];
1231         delete _ownedTokens[from][lastTokenIndex];
1232     }
1233 
1234     /**
1235      * @dev Private function to remove a token from this extension's token tracking data structures.
1236      * This has O(1) time complexity, but alters the order of the _allTokens array.
1237      * @param tokenId uint256 ID of the token to be removed from the tokens list
1238      */
1239     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1240         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1241         // then delete the last slot (swap and pop).
1242 
1243         uint256 lastTokenIndex = _allTokens.length - 1;
1244         uint256 tokenIndex = _allTokensIndex[tokenId];
1245 
1246         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1247         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1248         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1249         uint256 lastTokenId = _allTokens[lastTokenIndex];
1250 
1251         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1252         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1253 
1254         // This also deletes the contents at the last position of the array
1255         delete _allTokensIndex[tokenId];
1256         _allTokens.pop();
1257     }
1258 }
1259 
1260 // File: contracts/QuarterMachine.sol
1261 
1262 
1263 pragma solidity >=0.7.0 <0.9.0;
1264 
1265 
1266 
1267 contract NFT is ERC721Enumerable, Ownable {
1268   using Strings for uint256;
1269 
1270   string public baseURI;
1271   string public baseExtension = ".json";
1272   string public notRevealedUri;
1273   uint256 public cost = 0.25 ether;
1274   uint256 public maxSupply = 2525;
1275   uint256 public maxMintAmount = 75;
1276   uint256 public nftPerAddressLimit = 1;
1277   bool public paused = false;
1278   bool public revealed = false;
1279   bool public onlyWhitelisted = true;
1280   address[] public whitelistedAddresses;
1281   mapping(address => uint256) public addressMintedBalance;
1282 
1283   constructor(
1284     string memory _name,
1285     string memory _symbol,
1286     string memory _initBaseURI,
1287     string memory _initNotRevealedUri
1288   ) ERC721(_name, _symbol) {
1289     setBaseURI(_initBaseURI);
1290     setNotRevealedURI(_initNotRevealedUri);
1291     mint(75);
1292   }
1293 
1294   // internal
1295   function _baseURI() internal view virtual override returns (string memory) {
1296     return baseURI;
1297   }
1298 
1299   // public
1300   function mint(uint256 _mintAmount) public payable {
1301     require(!paused, "the contract is paused");
1302     uint256 supply = totalSupply();
1303     require(_mintAmount > 0, "need to mint at least 1 NFT");
1304     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1305     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1306 
1307     if (msg.sender != owner()) {
1308         if(onlyWhitelisted == true) {
1309             require(isWhitelisted(msg.sender), "user is not whitelisted");
1310         }
1311         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1312         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1313         require(msg.value >= cost * _mintAmount, "insufficient funds");
1314     }
1315 
1316     for (uint256 i = 1; i <= _mintAmount; i++) {
1317       addressMintedBalance[msg.sender]++;
1318       _safeMint(msg.sender, supply + i);
1319     }
1320   }
1321   
1322   function isWhitelisted(address _user) public view returns (bool) {
1323     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1324       if (whitelistedAddresses[i] == _user) {
1325           return true;
1326       }
1327     }
1328     return false;
1329   }
1330 
1331   function walletOfOwner(address _owner)
1332     public
1333     view
1334     returns (uint256[] memory)
1335   {
1336     uint256 ownerTokenCount = balanceOf(_owner);
1337     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1338     for (uint256 i; i < ownerTokenCount; i++) {
1339       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1340     }
1341     return tokenIds;
1342   }
1343 
1344   function tokenURI(uint256 tokenId)
1345     public
1346     view
1347     virtual
1348     override
1349     returns (string memory)
1350   {
1351     require(
1352       _exists(tokenId),
1353       "ERC721Metadata: URI query for nonexistent token"
1354     );
1355     
1356     if(revealed == false) {
1357         return string(abi.encodePacked(notRevealedUri, tokenId.toString(), baseExtension));
1358     }
1359 
1360     string memory currentBaseURI = _baseURI();
1361     return bytes(currentBaseURI).length > 0
1362         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1363         : "";
1364   }
1365 
1366   //only owner
1367   function reveal() public onlyOwner() {
1368       revealed = true;
1369   }
1370   
1371   function setNftPerAddressLimit(uint256 _limit) public onlyOwner() {
1372     nftPerAddressLimit = _limit;
1373   }
1374   
1375   function setCost(uint256 _newCost) public onlyOwner() {
1376     cost = _newCost;
1377   }
1378 
1379   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1380     maxMintAmount = _newmaxMintAmount;
1381   }
1382 
1383   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1384     baseURI = _newBaseURI;
1385   }
1386 
1387   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1388     baseExtension = _newBaseExtension;
1389   }
1390   
1391   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1392     notRevealedUri = _notRevealedURI;
1393   }
1394 
1395   function pause(bool _state) public onlyOwner {
1396     paused = _state;
1397   }
1398   
1399   function setOnlyWhitelisted(bool _state) public onlyOwner {
1400     onlyWhitelisted = _state;
1401   }
1402   
1403   function whitelistUsers(address[] calldata _users) public onlyOwner {
1404     delete whitelistedAddresses;
1405     whitelistedAddresses = _users;
1406   }
1407  
1408   function withdraw() public payable onlyOwner {
1409     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1410     require(success);
1411   }
1412 }