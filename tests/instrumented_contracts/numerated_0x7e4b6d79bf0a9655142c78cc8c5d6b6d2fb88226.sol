1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
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
58     function toHexString(uint256 value, uint256 length)
59         internal
60         pure
61         returns (string memory)
62     {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/Context.sol
76 
77 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Provides information about the current execution context, including the
83  * sender of the transaction and its data. While these are generally available
84  * via msg.sender and msg.data, they should not be accessed in such a direct
85  * manner, since when dealing with meta-transactions the account sending and
86  * paying for execution may not be the actual sender (as far as an application
87  * is concerned).
88  *
89  * This contract is only required for intermediate, library-like contracts.
90  */
91 abstract contract Context {
92     function _msgSender() internal view virtual returns (address) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view virtual returns (bytes calldata) {
97         return msg.data;
98     }
99 }
100 
101 // File: @openzeppelin/contracts/access/Ownable.sol
102 
103 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 /**
108  * @dev Contract module which provides a basic access control mechanism, where
109  * there is an account (an owner) that can be granted exclusive access to
110  * specific functions.
111  *
112  * By default, the owner account will be the one that deploys the contract. This
113  * can later be changed with {transferOwnership}.
114  *
115  * This module is used through inheritance. It will make available the modifier
116  * `onlyOwner`, which can be applied to your functions to restrict their use to
117  * the owner.
118  */
119 abstract contract Ownable is Context {
120     address private _owner;
121 
122     event OwnershipTransferred(
123         address indexed previousOwner,
124         address indexed newOwner
125     );
126 
127     /**
128      * @dev Initializes the contract setting the deployer as the initial owner.
129      */
130     constructor() {
131         _transferOwnership(_msgSender());
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
157         _transferOwnership(address(0));
158     }
159 
160     /**
161      * @dev Transfers ownership of the contract to a new account (`newOwner`).
162      * Can only be called by the current owner.
163      */
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(
166             newOwner != address(0),
167             "Ownable: new owner is the zero address"
168         );
169         _transferOwnership(newOwner);
170     }
171 
172     /**
173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
174      * Internal function without access restriction.
175      */
176     function _transferOwnership(address newOwner) internal virtual {
177         address oldOwner = _owner;
178         _owner = newOwner;
179         emit OwnershipTransferred(oldOwner, newOwner);
180     }
181 }
182 
183 // File: @openzeppelin/contracts/utils/Address.sol
184 
185 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
186 
187 pragma solidity ^0.8.0;
188 
189 /**
190  * @dev Collection of functions related to the address type
191  */
192 library Address {
193     /**
194      * @dev Returns true if `account` is a contract.
195      *
196      * [IMPORTANT]
197      * ====
198      * It is unsafe to assume that an address for which this function returns
199      * false is an externally-owned account (EOA) and not a contract.
200      *
201      * Among others, `isContract` will return false for the following
202      * types of addresses:
203      *
204      *  - an externally-owned account
205      *  - a contract in construction
206      *  - an address where a contract will be created
207      *  - an address where a contract lived, but was destroyed
208      * ====
209      */
210     function isContract(address account) internal view returns (bool) {
211         // This method relies on extcodesize, which returns 0 for contracts in
212         // construction, since the code is only stored at the end of the
213         // constructor execution.
214 
215         uint256 size;
216         assembly {
217             size := extcodesize(account)
218         }
219         return size > 0;
220     }
221 
222     /**
223      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
224      * `recipient`, forwarding all available gas and reverting on errors.
225      *
226      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
227      * of certain opcodes, possibly making contracts go over the 2300 gas limit
228      * imposed by `transfer`, making them unable to receive funds via
229      * `transfer`. {sendValue} removes this limitation.
230      *
231      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
232      *
233      * IMPORTANT: because control is transferred to `recipient`, care must be
234      * taken to not create reentrancy vulnerabilities. Consider using
235      * {ReentrancyGuard} or the
236      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
237      */
238     function sendValue(address payable recipient, uint256 amount) internal {
239         require(
240             address(this).balance >= amount,
241             "Address: insufficient balance"
242         );
243 
244         (bool success, ) = recipient.call{value: amount}("");
245         require(
246             success,
247             "Address: unable to send value, recipient may have reverted"
248         );
249     }
250 
251     /**
252      * @dev Performs a Solidity function call using a low level `call`. A
253      * plain `call` is an unsafe replacement for a function call: use this
254      * function instead.
255      *
256      * If `target` reverts with a revert reason, it is bubbled up by this
257      * function (like regular Solidity function calls).
258      *
259      * Returns the raw returned data. To convert to the expected return value,
260      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
261      *
262      * Requirements:
263      *
264      * - `target` must be a contract.
265      * - calling `target` with `data` must not revert.
266      *
267      * _Available since v3.1._
268      */
269     function functionCall(address target, bytes memory data)
270         internal
271         returns (bytes memory)
272     {
273         return functionCall(target, data, "Address: low-level call failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
278      * `errorMessage` as a fallback revert reason when `target` reverts.
279      *
280      * _Available since v3.1._
281      */
282     function functionCall(
283         address target,
284         bytes memory data,
285         string memory errorMessage
286     ) internal returns (bytes memory) {
287         return functionCallWithValue(target, data, 0, errorMessage);
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
292      * but also transferring `value` wei to `target`.
293      *
294      * Requirements:
295      *
296      * - the calling contract must have an ETH balance of at least `value`.
297      * - the called Solidity function must be `payable`.
298      *
299      * _Available since v3.1._
300      */
301     function functionCallWithValue(
302         address target,
303         bytes memory data,
304         uint256 value
305     ) internal returns (bytes memory) {
306         return
307             functionCallWithValue(
308                 target,
309                 data,
310                 value,
311                 "Address: low-level call with value failed"
312             );
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
317      * with `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCallWithValue(
322         address target,
323         bytes memory data,
324         uint256 value,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         require(
328             address(this).balance >= value,
329             "Address: insufficient balance for call"
330         );
331         require(isContract(target), "Address: call to non-contract");
332 
333         (bool success, bytes memory returndata) = target.call{value: value}(
334             data
335         );
336         return verifyCallResult(success, returndata, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but performing a static call.
342      *
343      * _Available since v3.3._
344      */
345     function functionStaticCall(address target, bytes memory data)
346         internal
347         view
348         returns (bytes memory)
349     {
350         return
351             functionStaticCall(
352                 target,
353                 data,
354                 "Address: low-level static call failed"
355             );
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
360      * but performing a static call.
361      *
362      * _Available since v3.3._
363      */
364     function functionStaticCall(
365         address target,
366         bytes memory data,
367         string memory errorMessage
368     ) internal view returns (bytes memory) {
369         require(isContract(target), "Address: static call to non-contract");
370 
371         (bool success, bytes memory returndata) = target.staticcall(data);
372         return verifyCallResult(success, returndata, errorMessage);
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
377      * but performing a delegate call.
378      *
379      * _Available since v3.4._
380      */
381     function functionDelegateCall(address target, bytes memory data)
382         internal
383         returns (bytes memory)
384     {
385         return
386             functionDelegateCall(
387                 target,
388                 data,
389                 "Address: low-level delegate call failed"
390             );
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
395      * but performing a delegate call.
396      *
397      * _Available since v3.4._
398      */
399     function functionDelegateCall(
400         address target,
401         bytes memory data,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         require(isContract(target), "Address: delegate call to non-contract");
405 
406         (bool success, bytes memory returndata) = target.delegatecall(data);
407         return verifyCallResult(success, returndata, errorMessage);
408     }
409 
410     /**
411      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
412      * revert reason using the provided one.
413      *
414      * _Available since v4.3._
415      */
416     function verifyCallResult(
417         bool success,
418         bytes memory returndata,
419         string memory errorMessage
420     ) internal pure returns (bytes memory) {
421         if (success) {
422             return returndata;
423         } else {
424             // Look for revert reason and bubble it up if present
425             if (returndata.length > 0) {
426                 // The easiest way to bubble the revert reason is using memory via assembly
427 
428                 assembly {
429                     let returndata_size := mload(returndata)
430                     revert(add(32, returndata), returndata_size)
431                 }
432             } else {
433                 revert(errorMessage);
434             }
435         }
436     }
437 }
438 
439 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
440 
441 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
442 
443 pragma solidity ^0.8.0;
444 
445 /**
446  * @title ERC721 token receiver interface
447  * @dev Interface for any contract that wants to support safeTransfers
448  * from ERC721 asset contracts.
449  */
450 interface IERC721Receiver {
451     /**
452      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
453      * by `operator` from `from`, this function is called.
454      *
455      * It must return its Solidity selector to confirm the token transfer.
456      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
457      *
458      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
459      */
460     function onERC721Received(
461         address operator,
462         address from,
463         uint256 tokenId,
464         bytes calldata data
465     ) external returns (bytes4);
466 }
467 
468 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
469 
470 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
471 
472 pragma solidity ^0.8.0;
473 
474 /**
475  * @dev Interface of the ERC165 standard, as defined in the
476  * https://eips.ethereum.org/EIPS/eip-165[EIP].
477  *
478  * Implementers can declare support of contract interfaces, which can then be
479  * queried by others ({ERC165Checker}).
480  *
481  * For an implementation, see {ERC165}.
482  */
483 interface IERC165 {
484     /**
485      * @dev Returns true if this contract implements the interface defined by
486      * `interfaceId`. See the corresponding
487      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
488      * to learn more about how these ids are created.
489      *
490      * This function call must use less than 30 000 gas.
491      */
492     function supportsInterface(bytes4 interfaceId) external view returns (bool);
493 }
494 
495 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
496 
497 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @dev Implementation of the {IERC165} interface.
503  *
504  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
505  * for the additional interface id that will be supported. For example:
506  *
507  * ```solidity
508  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
509  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
510  * }
511  * ```
512  *
513  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
514  */
515 abstract contract ERC165 is IERC165 {
516     /**
517      * @dev See {IERC165-supportsInterface}.
518      */
519     function supportsInterface(bytes4 interfaceId)
520         public
521         view
522         virtual
523         override
524         returns (bool)
525     {
526         return interfaceId == type(IERC165).interfaceId;
527     }
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
531 
532 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 /**
537  * @dev Required interface of an ERC721 compliant contract.
538  */
539 interface IERC721 is IERC165 {
540     /**
541      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
542      */
543     event Transfer(
544         address indexed from,
545         address indexed to,
546         uint256 indexed tokenId
547     );
548 
549     /**
550      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
551      */
552     event Approval(
553         address indexed owner,
554         address indexed approved,
555         uint256 indexed tokenId
556     );
557 
558     /**
559      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
560      */
561     event ApprovalForAll(
562         address indexed owner,
563         address indexed operator,
564         bool approved
565     );
566 
567     /**
568      * @dev Returns the number of tokens in ``owner``'s account.
569      */
570     function balanceOf(address owner) external view returns (uint256 balance);
571 
572     /**
573      * @dev Returns the owner of the `tokenId` token.
574      *
575      * Requirements:
576      *
577      * - `tokenId` must exist.
578      */
579     function ownerOf(uint256 tokenId) external view returns (address owner);
580 
581     /**
582      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
583      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
584      *
585      * Requirements:
586      *
587      * - `from` cannot be the zero address.
588      * - `to` cannot be the zero address.
589      * - `tokenId` token must exist and be owned by `from`.
590      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
591      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
592      *
593      * Emits a {Transfer} event.
594      */
595     function safeTransferFrom(
596         address from,
597         address to,
598         uint256 tokenId
599     ) external;
600 
601     /**
602      * @dev Transfers `tokenId` token from `from` to `to`.
603      *
604      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
605      *
606      * Requirements:
607      *
608      * - `from` cannot be the zero address.
609      * - `to` cannot be the zero address.
610      * - `tokenId` token must be owned by `from`.
611      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
612      *
613      * Emits a {Transfer} event.
614      */
615     function transferFrom(
616         address from,
617         address to,
618         uint256 tokenId
619     ) external;
620 
621     /**
622      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
623      * The approval is cleared when the token is transferred.
624      *
625      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
626      *
627      * Requirements:
628      *
629      * - The caller must own the token or be an approved operator.
630      * - `tokenId` must exist.
631      *
632      * Emits an {Approval} event.
633      */
634     function approve(address to, uint256 tokenId) external;
635 
636     /**
637      * @dev Returns the account approved for `tokenId` token.
638      *
639      * Requirements:
640      *
641      * - `tokenId` must exist.
642      */
643     function getApproved(uint256 tokenId)
644         external
645         view
646         returns (address operator);
647 
648     /**
649      * @dev Approve or remove `operator` as an operator for the caller.
650      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
651      *
652      * Requirements:
653      *
654      * - The `operator` cannot be the caller.
655      *
656      * Emits an {ApprovalForAll} event.
657      */
658     function setApprovalForAll(address operator, bool _approved) external;
659 
660     /**
661      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
662      *
663      * See {setApprovalForAll}
664      */
665     function isApprovedForAll(address owner, address operator)
666         external
667         view
668         returns (bool);
669 
670     /**
671      * @dev Safely transfers `tokenId` token from `from` to `to`.
672      *
673      * Requirements:
674      *
675      * - `from` cannot be the zero address.
676      * - `to` cannot be the zero address.
677      * - `tokenId` token must exist and be owned by `from`.
678      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
679      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
680      *
681      * Emits a {Transfer} event.
682      */
683     function safeTransferFrom(
684         address from,
685         address to,
686         uint256 tokenId,
687         bytes calldata data
688     ) external;
689 }
690 
691 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
692 
693 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
694 
695 pragma solidity ^0.8.0;
696 
697 /**
698  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
699  * @dev See https://eips.ethereum.org/EIPS/eip-721
700  */
701 interface IERC721Enumerable is IERC721 {
702     /**
703      * @dev Returns the total amount of tokens stored by the contract.
704      */
705     function totalSupply() external view returns (uint256);
706 
707     /**
708      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
709      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
710      */
711     function tokenOfOwnerByIndex(address owner, uint256 index)
712         external
713         view
714         returns (uint256 tokenId);
715 
716     /**
717      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
718      * Use along with {totalSupply} to enumerate all tokens.
719      */
720     function tokenByIndex(uint256 index) external view returns (uint256);
721 }
722 
723 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
724 
725 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
726 
727 pragma solidity ^0.8.0;
728 
729 /**
730  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
731  * @dev See https://eips.ethereum.org/EIPS/eip-721
732  */
733 interface IERC721Metadata is IERC721 {
734     /**
735      * @dev Returns the token collection name.
736      */
737     function name() external view returns (string memory);
738 
739     /**
740      * @dev Returns the token collection symbol.
741      */
742     function symbol() external view returns (string memory);
743 
744     /**
745      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
746      */
747     function tokenURI(uint256 tokenId) external view returns (string memory);
748 }
749 
750 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
751 
752 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
753 
754 pragma solidity ^0.8.0;
755 
756 /**
757  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
758  * the Metadata extension, but not including the Enumerable extension, which is available separately as
759  * {ERC721Enumerable}.
760  */
761 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
762     using Address for address;
763     using Strings for uint256;
764 
765     // Token name
766     string private _name;
767 
768     // Token symbol
769     string private _symbol;
770 
771     // Mapping from token ID to owner address
772     mapping(uint256 => address) private _owners;
773 
774     // Mapping owner address to token count
775     mapping(address => uint256) private _balances;
776 
777     // Mapping from token ID to approved address
778     mapping(uint256 => address) private _tokenApprovals;
779 
780     // Mapping from owner to operator approvals
781     mapping(address => mapping(address => bool)) private _operatorApprovals;
782 
783     /**
784      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
785      */
786     constructor(string memory name_, string memory symbol_) {
787         _name = name_;
788         _symbol = symbol_;
789     }
790 
791     /**
792      * @dev See {IERC165-supportsInterface}.
793      */
794     function supportsInterface(bytes4 interfaceId)
795         public
796         view
797         virtual
798         override(ERC165, IERC165)
799         returns (bool)
800     {
801         return
802             interfaceId == type(IERC721).interfaceId ||
803             interfaceId == type(IERC721Metadata).interfaceId ||
804             super.supportsInterface(interfaceId);
805     }
806 
807     /**
808      * @dev See {IERC721-balanceOf}.
809      */
810     function balanceOf(address owner)
811         public
812         view
813         virtual
814         override
815         returns (uint256)
816     {
817         require(
818             owner != address(0),
819             "ERC721: balance query for the zero address"
820         );
821         return _balances[owner];
822     }
823 
824     /**
825      * @dev See {IERC721-ownerOf}.
826      */
827     function ownerOf(uint256 tokenId)
828         public
829         view
830         virtual
831         override
832         returns (address)
833     {
834         address owner = _owners[tokenId];
835         require(
836             owner != address(0),
837             "ERC721: owner query for nonexistent token"
838         );
839         return owner;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-name}.
844      */
845     function name() public view virtual override returns (string memory) {
846         return _name;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-symbol}.
851      */
852     function symbol() public view virtual override returns (string memory) {
853         return _symbol;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-tokenURI}.
858      */
859     function tokenURI(uint256 tokenId)
860         public
861         view
862         virtual
863         override
864         returns (string memory)
865     {
866         require(
867             _exists(tokenId),
868             "ERC721Metadata: URI query for nonexistent token"
869         );
870 
871         string memory baseURI = _baseURI();
872         return
873             bytes(baseURI).length > 0
874                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
875                 : "";
876     }
877 
878     /**
879      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
880      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
881      * by default, can be overriden in child contracts.
882      */
883     function _baseURI() internal view virtual returns (string memory) {
884         return "";
885     }
886 
887     /**
888      * @dev See {IERC721-approve}.
889      */
890     function approve(address to, uint256 tokenId) public virtual override {
891         address owner = ERC721.ownerOf(tokenId);
892         require(to != owner, "ERC721: approval to current owner");
893 
894         require(
895             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
896             "ERC721: approve caller is not owner nor approved for all"
897         );
898 
899         _approve(to, tokenId);
900     }
901 
902     /**
903      * @dev See {IERC721-getApproved}.
904      */
905     function getApproved(uint256 tokenId)
906         public
907         view
908         virtual
909         override
910         returns (address)
911     {
912         require(
913             _exists(tokenId),
914             "ERC721: approved query for nonexistent token"
915         );
916 
917         return _tokenApprovals[tokenId];
918     }
919 
920     /**
921      * @dev See {IERC721-setApprovalForAll}.
922      */
923     function setApprovalForAll(address operator, bool approved)
924         public
925         virtual
926         override
927     {
928         _setApprovalForAll(_msgSender(), operator, approved);
929     }
930 
931     /**
932      * @dev See {IERC721-isApprovedForAll}.
933      */
934     function isApprovedForAll(address owner, address operator)
935         public
936         view
937         virtual
938         override
939         returns (bool)
940     {
941         return _operatorApprovals[owner][operator];
942     }
943 
944     /**
945      * @dev See {IERC721-transferFrom}.
946      */
947     function transferFrom(
948         address from,
949         address to,
950         uint256 tokenId
951     ) public virtual override {
952         //solhint-disable-next-line max-line-length
953         require(
954             _isApprovedOrOwner(_msgSender(), tokenId),
955             "ERC721: transfer caller is not owner nor approved"
956         );
957 
958         _transfer(from, to, tokenId);
959     }
960 
961     /**
962      * @dev See {IERC721-safeTransferFrom}.
963      */
964     function safeTransferFrom(
965         address from,
966         address to,
967         uint256 tokenId
968     ) public virtual override {
969         safeTransferFrom(from, to, tokenId, "");
970     }
971 
972     /**
973      * @dev See {IERC721-safeTransferFrom}.
974      */
975     function safeTransferFrom(
976         address from,
977         address to,
978         uint256 tokenId,
979         bytes memory _data
980     ) public virtual override {
981         require(
982             _isApprovedOrOwner(_msgSender(), tokenId),
983             "ERC721: transfer caller is not owner nor approved"
984         );
985         _safeTransfer(from, to, tokenId, _data);
986     }
987 
988     /**
989      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
990      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
991      *
992      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
993      *
994      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
995      * implement alternative mechanisms to perform token transfer, such as signature-based.
996      *
997      * Requirements:
998      *
999      * - `from` cannot be the zero address.
1000      * - `to` cannot be the zero address.
1001      * - `tokenId` token must exist and be owned by `from`.
1002      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _safeTransfer(
1007         address from,
1008         address to,
1009         uint256 tokenId,
1010         bytes memory _data
1011     ) internal virtual {
1012         _transfer(from, to, tokenId);
1013         require(
1014             _checkOnERC721Received(from, to, tokenId, _data),
1015             "ERC721: transfer to non ERC721Receiver implementer"
1016         );
1017     }
1018 
1019     /**
1020      * @dev Returns whether `tokenId` exists.
1021      *
1022      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1023      *
1024      * Tokens start existing when they are minted (`_mint`),
1025      * and stop existing when they are burned (`_burn`).
1026      */
1027     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1028         return _owners[tokenId] != address(0);
1029     }
1030 
1031     /**
1032      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1033      *
1034      * Requirements:
1035      *
1036      * - `tokenId` must exist.
1037      */
1038     function _isApprovedOrOwner(address spender, uint256 tokenId)
1039         internal
1040         view
1041         virtual
1042         returns (bool)
1043     {
1044         require(
1045             _exists(tokenId),
1046             "ERC721: operator query for nonexistent token"
1047         );
1048         address owner = ERC721.ownerOf(tokenId);
1049         return (spender == owner ||
1050             getApproved(tokenId) == spender ||
1051             isApprovedForAll(owner, spender));
1052     }
1053 
1054     /**
1055      * @dev Safely mints `tokenId` and transfers it to `to`.
1056      *
1057      * Requirements:
1058      *
1059      * - `tokenId` must not exist.
1060      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function _safeMint(address to, uint256 tokenId) internal virtual {
1065         _safeMint(to, tokenId, "");
1066     }
1067 
1068     /**
1069      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1070      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1071      */
1072     function _safeMint(
1073         address to,
1074         uint256 tokenId,
1075         bytes memory _data
1076     ) internal virtual {
1077         _mint(to, tokenId);
1078         require(
1079             _checkOnERC721Received(address(0), to, tokenId, _data),
1080             "ERC721: transfer to non ERC721Receiver implementer"
1081         );
1082     }
1083 
1084     /**
1085      * @dev Mints `tokenId` and transfers it to `to`.
1086      *
1087      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1088      *
1089      * Requirements:
1090      *
1091      * - `tokenId` must not exist.
1092      * - `to` cannot be the zero address.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function _mint(address to, uint256 tokenId) internal virtual {
1097         require(to != address(0), "ERC721: mint to the zero address");
1098         require(!_exists(tokenId), "ERC721: token already minted");
1099 
1100         _beforeTokenTransfer(address(0), to, tokenId);
1101 
1102         _balances[to] += 1;
1103         _owners[tokenId] = to;
1104 
1105         emit Transfer(address(0), to, tokenId);
1106     }
1107 
1108     /**
1109      * @dev Destroys `tokenId`.
1110      * The approval is cleared when the token is burned.
1111      *
1112      * Requirements:
1113      *
1114      * - `tokenId` must exist.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function _burn(uint256 tokenId) internal virtual {
1119         address owner = ERC721.ownerOf(tokenId);
1120 
1121         _beforeTokenTransfer(owner, address(0), tokenId);
1122 
1123         // Clear approvals
1124         _approve(address(0), tokenId);
1125 
1126         _balances[owner] -= 1;
1127         delete _owners[tokenId];
1128 
1129         emit Transfer(owner, address(0), tokenId);
1130     }
1131 
1132     /**
1133      * @dev Transfers `tokenId` from `from` to `to`.
1134      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1135      *
1136      * Requirements:
1137      *
1138      * - `to` cannot be the zero address.
1139      * - `tokenId` token must be owned by `from`.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function _transfer(
1144         address from,
1145         address to,
1146         uint256 tokenId
1147     ) internal virtual {
1148         require(
1149             ERC721.ownerOf(tokenId) == from,
1150             "ERC721: transfer of token that is not own"
1151         );
1152         require(to != address(0), "ERC721: transfer to the zero address");
1153 
1154         _beforeTokenTransfer(from, to, tokenId);
1155 
1156         // Clear approvals from the previous owner
1157         _approve(address(0), tokenId);
1158 
1159         _balances[from] -= 1;
1160         _balances[to] += 1;
1161         _owners[tokenId] = to;
1162 
1163         emit Transfer(from, to, tokenId);
1164     }
1165 
1166     /**
1167      * @dev Approve `to` to operate on `tokenId`
1168      *
1169      * Emits a {Approval} event.
1170      */
1171     function _approve(address to, uint256 tokenId) internal virtual {
1172         _tokenApprovals[tokenId] = to;
1173         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1174     }
1175 
1176     /**
1177      * @dev Approve `operator` to operate on all of `owner` tokens
1178      *
1179      * Emits a {ApprovalForAll} event.
1180      */
1181     function _setApprovalForAll(
1182         address owner,
1183         address operator,
1184         bool approved
1185     ) internal virtual {
1186         require(owner != operator, "ERC721: approve to caller");
1187         _operatorApprovals[owner][operator] = approved;
1188         emit ApprovalForAll(owner, operator, approved);
1189     }
1190 
1191     /**
1192      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1193      * The call is not executed if the target address is not a contract.
1194      *
1195      * @param from address representing the previous owner of the given token ID
1196      * @param to target address that will receive the tokens
1197      * @param tokenId uint256 ID of the token to be transferred
1198      * @param _data bytes optional data to send along with the call
1199      * @return bool whether the call correctly returned the expected magic value
1200      */
1201     function _checkOnERC721Received(
1202         address from,
1203         address to,
1204         uint256 tokenId,
1205         bytes memory _data
1206     ) private returns (bool) {
1207         if (to.isContract()) {
1208             try
1209                 IERC721Receiver(to).onERC721Received(
1210                     _msgSender(),
1211                     from,
1212                     tokenId,
1213                     _data
1214                 )
1215             returns (bytes4 retval) {
1216                 return retval == IERC721Receiver.onERC721Received.selector;
1217             } catch (bytes memory reason) {
1218                 if (reason.length == 0) {
1219                     revert(
1220                         "ERC721: transfer to non ERC721Receiver implementer"
1221                     );
1222                 } else {
1223                     assembly {
1224                         revert(add(32, reason), mload(reason))
1225                     }
1226                 }
1227             }
1228         } else {
1229             return true;
1230         }
1231     }
1232 
1233     /**
1234      * @dev Hook that is called before any token transfer. This includes minting
1235      * and burning.
1236      *
1237      * Calling conditions:
1238      *
1239      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1240      * transferred to `to`.
1241      * - When `from` is zero, `tokenId` will be minted for `to`.
1242      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1243      * - `from` and `to` are never both zero.
1244      *
1245      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1246      */
1247     function _beforeTokenTransfer(
1248         address from,
1249         address to,
1250         uint256 tokenId
1251     ) internal virtual {}
1252 }
1253 
1254 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1255 
1256 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1257 
1258 pragma solidity ^0.8.0;
1259 
1260 /**
1261  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1262  * enumerability of all the token ids in the contract as well as all token ids owned by each
1263  * account.
1264  */
1265 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1266     // Mapping from owner to list of owned token IDs
1267     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1268 
1269     // Mapping from token ID to index of the owner tokens list
1270     mapping(uint256 => uint256) private _ownedTokensIndex;
1271 
1272     // Array with all token ids, used for enumeration
1273     uint256[] private _allTokens;
1274 
1275     // Mapping from token id to position in the allTokens array
1276     mapping(uint256 => uint256) private _allTokensIndex;
1277 
1278     /**
1279      * @dev See {IERC165-supportsInterface}.
1280      */
1281     function supportsInterface(bytes4 interfaceId)
1282         public
1283         view
1284         virtual
1285         override(IERC165, ERC721)
1286         returns (bool)
1287     {
1288         return
1289             interfaceId == type(IERC721Enumerable).interfaceId ||
1290             super.supportsInterface(interfaceId);
1291     }
1292 
1293     /**
1294      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1295      */
1296     function tokenOfOwnerByIndex(address owner, uint256 index)
1297         public
1298         view
1299         virtual
1300         override
1301         returns (uint256)
1302     {
1303         require(
1304             index < ERC721.balanceOf(owner),
1305             "ERC721Enumerable: owner index out of bounds"
1306         );
1307         return _ownedTokens[owner][index];
1308     }
1309 
1310     /**
1311      * @dev See {IERC721Enumerable-totalSupply}.
1312      */
1313     function totalSupply() public view virtual override returns (uint256) {
1314         return _allTokens.length;
1315     }
1316 
1317     /**
1318      * @dev See {IERC721Enumerable-tokenByIndex}.
1319      */
1320     function tokenByIndex(uint256 index)
1321         public
1322         view
1323         virtual
1324         override
1325         returns (uint256)
1326     {
1327         require(
1328             index < ERC721Enumerable.totalSupply(),
1329             "ERC721Enumerable: global index out of bounds"
1330         );
1331         return _allTokens[index];
1332     }
1333 
1334     /**
1335      * @dev Hook that is called before any token transfer. This includes minting
1336      * and burning.
1337      *
1338      * Calling conditions:
1339      *
1340      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1341      * transferred to `to`.
1342      * - When `from` is zero, `tokenId` will be minted for `to`.
1343      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1344      * - `from` cannot be the zero address.
1345      * - `to` cannot be the zero address.
1346      *
1347      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1348      */
1349     function _beforeTokenTransfer(
1350         address from,
1351         address to,
1352         uint256 tokenId
1353     ) internal virtual override {
1354         super._beforeTokenTransfer(from, to, tokenId);
1355 
1356         if (from == address(0)) {
1357             _addTokenToAllTokensEnumeration(tokenId);
1358         } else if (from != to) {
1359             _removeTokenFromOwnerEnumeration(from, tokenId);
1360         }
1361         if (to == address(0)) {
1362             _removeTokenFromAllTokensEnumeration(tokenId);
1363         } else if (to != from) {
1364             _addTokenToOwnerEnumeration(to, tokenId);
1365         }
1366     }
1367 
1368     /**
1369      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1370      * @param to address representing the new owner of the given token ID
1371      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1372      */
1373     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1374         uint256 length = ERC721.balanceOf(to);
1375         _ownedTokens[to][length] = tokenId;
1376         _ownedTokensIndex[tokenId] = length;
1377     }
1378 
1379     /**
1380      * @dev Private function to add a token to this extension's token tracking data structures.
1381      * @param tokenId uint256 ID of the token to be added to the tokens list
1382      */
1383     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1384         _allTokensIndex[tokenId] = _allTokens.length;
1385         _allTokens.push(tokenId);
1386     }
1387 
1388     /**
1389      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1390      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1391      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1392      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1393      * @param from address representing the previous owner of the given token ID
1394      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1395      */
1396     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1397         private
1398     {
1399         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1400         // then delete the last slot (swap and pop).
1401 
1402         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1403         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1404 
1405         // When the token to delete is the last token, the swap operation is unnecessary
1406         if (tokenIndex != lastTokenIndex) {
1407             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1408 
1409             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1410             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1411         }
1412 
1413         // This also deletes the contents at the last position of the array
1414         delete _ownedTokensIndex[tokenId];
1415         delete _ownedTokens[from][lastTokenIndex];
1416     }
1417 
1418     /**
1419      * @dev Private function to remove a token from this extension's token tracking data structures.
1420      * This has O(1) time complexity, but alters the order of the _allTokens array.
1421      * @param tokenId uint256 ID of the token to be removed from the tokens list
1422      */
1423     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1424         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1425         // then delete the last slot (swap and pop).
1426 
1427         uint256 lastTokenIndex = _allTokens.length - 1;
1428         uint256 tokenIndex = _allTokensIndex[tokenId];
1429 
1430         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1431         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1432         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1433         uint256 lastTokenId = _allTokens[lastTokenIndex];
1434 
1435         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1436         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1437 
1438         // This also deletes the contents at the last position of the array
1439         delete _allTokensIndex[tokenId];
1440         _allTokens.pop();
1441     }
1442 }
1443 
1444 // File: contracts/rainboyclub.sol
1445 
1446 pragma solidity >=0.7.0 <0.9.0;
1447 
1448 contract RBC is ERC721Enumerable, Ownable {
1449     using Strings for uint256;
1450 
1451     string baseURI;
1452     string public baseExtension = ".json";
1453     uint256 public cost = 95700000000000000;
1454     uint256 public maxSupply = 7979;
1455     uint256 public reserved = 200;
1456     uint256 public maxMintAmount = 100;
1457     bytes32 public root;
1458     bool public paused = true;
1459     bool public revealed = false;
1460     bool public whitelistedSale = true;
1461     string public notRevealedUri;
1462 
1463     constructor(
1464         string memory _name,
1465         string memory _symbol,
1466         string memory _notRevealedUri
1467     ) ERC721(_name, _symbol) {
1468         notRevealedUri = _notRevealedUri;
1469     }
1470 
1471     // internal
1472     function _baseURI() internal view virtual override returns (string memory) {
1473         return baseURI;
1474     }
1475 
1476     // presale
1477     function presaleMint(uint256 _mintAmount, uint256 _mintableAmount, bytes32[] memory _proof)
1478         public
1479         payable
1480     {
1481         bytes32 leaf = keccak256(abi.encode(msg.sender, _mintableAmount));
1482 
1483         require(!paused, "Contract is paused");
1484 
1485         require(whitelistedSale, "Whitelist sale is not started");
1486 
1487         require(verify(_proof, leaf), "Invalid proof");
1488 
1489         require(_mintAmount > 0, "Must mint more than 0");
1490         
1491         require(msg.sender != owner());
1492 
1493         uint256 supply = totalSupply();
1494         uint256 totalAmount;
1495         uint256 tokenCount = balanceOf(msg.sender);
1496 
1497         // each address can mint at most *_mintableAmount* NFTs
1498         require(
1499             tokenCount + _mintAmount <= _mintableAmount,
1500             string(abi.encodePacked("Limit token ", tokenCount.toString()))
1501         );
1502 
1503         require(
1504             supply + _mintAmount <= maxSupply - reserved,
1505             "Max Supply"
1506         );
1507 
1508         totalAmount = cost * _mintAmount;
1509 
1510         require(
1511             msg.value >= totalAmount,
1512             string(
1513                 abi.encodePacked(
1514                     "Incorrect amount ",
1515                     totalAmount.toString(),
1516                     " ",
1517                     msg.value.toString()
1518                 )
1519             )
1520         );
1521 
1522         for (uint256 i = 1; i <= _mintAmount; i++) {
1523             _safeMint(msg.sender, supply + i);
1524         }
1525     }
1526 
1527     // public sale
1528     function mint(uint256 _mintAmount) public payable {
1529 
1530         require(!paused, "Contract is paused");
1531 
1532         require(!whitelistedSale, "Whitelist sale is not closed");
1533 
1534         require(_mintAmount > 0, "Must mint more than 0");
1535 
1536         uint256 supply = totalSupply();
1537         uint256 totalAmount;
1538         // uint256 tokenCount = balanceOf(msg.sender);
1539 
1540         // each address can mint at most *maxMintAmount* NFTs
1541         // require(
1542         //     tokenCount + _mintAmount <= maxMintAmount,
1543         //     string(abi.encodePacked("Limit token ", tokenCount.toString()))
1544         // );
1545 
1546         require(
1547             supply + _mintAmount <= maxSupply - reserved,
1548             "Max Supply"
1549         );
1550         
1551         totalAmount = cost * _mintAmount;
1552 
1553         require(
1554             msg.value >= totalAmount,
1555             string(
1556                 abi.encodePacked(
1557                     "Incorrect amount ",
1558                     totalAmount.toString(),
1559                     " ",
1560                     msg.value.toString()
1561                 )
1562             )
1563         );
1564 
1565         for (uint256 i = 1; i <= _mintAmount; i++) {
1566             _safeMint(msg.sender, supply + i);
1567         }
1568     }
1569 
1570     function walletOfOwner(address _owner)
1571         public
1572         view
1573         returns (uint256[] memory)
1574     {
1575         uint256 ownerTokenCount = balanceOf(_owner);
1576 
1577         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1578 
1579         for (uint256 i; i < ownerTokenCount; i++) {
1580             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1581         }
1582 
1583         return tokenIds;
1584     }
1585 
1586     function tokenURI(uint256 tokenId)
1587         public
1588         view
1589         virtual
1590         override
1591         returns (string memory)
1592     {
1593         require(
1594             _exists(tokenId),
1595             "ERC721Metadata: URI query for nonexistent token"
1596         );
1597 
1598         if (revealed == false) {
1599             return bytes(notRevealedUri).length > 0
1600                 ? string(
1601                     abi.encodePacked(
1602                         notRevealedUri,
1603                         tokenId.toString(),
1604                         baseExtension
1605                     )
1606                 )
1607                 : "";
1608         }
1609 
1610         string memory currentBaseURI = _baseURI();
1611 
1612         return
1613             bytes(currentBaseURI).length > 0
1614                 ? string(
1615                     abi.encodePacked(
1616                         currentBaseURI,
1617                         tokenId.toString(),
1618                         baseExtension
1619                     )
1620                 )
1621                 : "";
1622     }
1623 
1624     //only owner
1625     function switchToReserve(bytes32 _root) public onlyOwner {
1626         root = _root;
1627         reserved = 0;
1628         cost = 0;
1629         whitelistedSale = true;
1630     }
1631 
1632     function setReveal(bool _revealed) public onlyOwner {
1633         revealed = _revealed;
1634     }
1635 
1636     function setReserved(uint256 _reserved) public onlyOwner {
1637         reserved = _reserved;
1638     }
1639 
1640     function setCost(uint256 _newCost) public onlyOwner {
1641         cost = _newCost;
1642     }
1643 
1644     function setMaxMintAmount(uint256 _maxMintAmount) public onlyOwner {
1645         maxMintAmount = _maxMintAmount;
1646     }
1647 
1648     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1649         notRevealedUri = _notRevealedURI;
1650     }
1651 
1652     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1653         baseURI = _newBaseURI;
1654     }
1655 
1656     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1657         baseExtension = _newBaseExtension;
1658     }
1659 
1660     function setPause(bool _state) public onlyOwner {
1661         paused = _state;
1662     }
1663 
1664     function setWhitelistSale(bool _whitelistSale) public onlyOwner {
1665         whitelistedSale = _whitelistSale;
1666     }
1667 
1668     function setRoot(bytes32 _root) public onlyOwner {
1669         root = _root;
1670     }
1671 
1672     function withdraw() public payable onlyOwner {
1673         (bool oa, ) = payable(owner()).call{value: address(this).balance}("");
1674 
1675         require(oa);
1676     }
1677 
1678     function partialWithdraw(uint256 _amount) public payable onlyOwner {
1679         (bool success, ) = payable(owner()).call{value: _amount}("");
1680 
1681         require(success);
1682     }
1683 
1684     function getBalance() public view onlyOwner returns (uint256) {
1685         return address(this).balance;
1686     }
1687 
1688     function verify(bytes32[] memory _proof, bytes32 _leaf) public view returns (bool) {
1689         bytes32 computedHash = _leaf;
1690 
1691         for (uint256 i = 0; i < _proof.length; i++) {
1692             bytes32 proofElement = _proof[i];
1693             
1694             if (computedHash <= proofElement) {
1695                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1696             } else {
1697                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1698             }
1699         }
1700 
1701         // Check if the computed hash (root) is equal to the provided root
1702         return computedHash == root;
1703     }
1704 
1705     function verifyParams(address _address, uint256 _mintableAmount, bytes32[] memory _proof) public view returns (bool) {
1706         bytes32 leaf = keccak256(abi.encode(_address, _mintableAmount));
1707         return verify(_proof, leaf);
1708     }
1709 }