1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
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
59     function toHexString(uint256 value, uint256 length)
60         internal
61         pure
62         returns (string memory)
63     {
64         bytes memory buffer = new bytes(2 * length + 2);
65         buffer[0] = "0";
66         buffer[1] = "x";
67         for (uint256 i = 2 * length + 1; i > 1; --i) {
68             buffer[i] = _HEX_SYMBOLS[value & 0xf];
69             value >>= 4;
70         }
71         require(value == 0, "Strings: hex length insufficient");
72         return string(buffer);
73     }
74 }
75 
76 // File: @openzeppelin/contracts/utils/Context.sol
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Provides information about the current execution context, including the
84  * sender of the transaction and its data. While these are generally available
85  * via msg.sender and msg.data, they should not be accessed in such a direct
86  * manner, since when dealing with meta-transactions the account sending and
87  * paying for execution may not be the actual sender (as far as an application
88  * is concerned).
89  *
90  * This contract is only required for intermediate, library-like contracts.
91  */
92 abstract contract Context {
93     function _msgSender() internal view virtual returns (address) {
94         return msg.sender;
95     }
96 
97     function _msgData() internal view virtual returns (bytes calldata) {
98         return msg.data;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/access/Ownable.sol
103 
104 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Contract module which provides a basic access control mechanism, where
110  * there is an account (an owner) that can be granted exclusive access to
111  * specific functions.
112  *
113  * By default, the owner account will be the one that deploys the contract. This
114  * can later be changed with {transferOwnership}.
115  *
116  * This module is used through inheritance. It will make available the modifier
117  * `onlyOwner`, which can be applied to your functions to restrict their use to
118  * the owner.
119  */
120 abstract contract Ownable is Context {
121     address private _owner;
122 
123     event OwnershipTransferred(
124         address indexed previousOwner,
125         address indexed newOwner
126     );
127 
128     /**
129      * @dev Initializes the contract setting the deployer as the initial owner.
130      */
131     constructor() {
132         _transferOwnership(_msgSender());
133     }
134 
135     /**
136      * @dev Returns the address of the current owner.
137      */
138     function owner() public view virtual returns (address) {
139         return _owner;
140     }
141 
142     /**
143      * @dev Throws if called by any account other than the owner.
144      */
145     modifier onlyOwner() {
146         require(owner() == _msgSender(), "Ownable: caller is not the owner");
147         _;
148     }
149 
150     /**
151      * @dev Leaves the contract without owner. It will not be possible to call
152      * `onlyOwner` functions anymore. Can only be called by the current owner.
153      *
154      * NOTE: Renouncing ownership will leave the contract without an owner,
155      * thereby removing any functionality that is only available to the owner.
156      */
157     function renounceOwnership() public virtual onlyOwner {
158         _transferOwnership(address(0));
159     }
160 
161     /**
162      * @dev Transfers ownership of the contract to a new account (`newOwner`).
163      * Can only be called by the current owner.
164      */
165     function transferOwnership(address newOwner) public virtual onlyOwner {
166         require(
167             newOwner != address(0),
168             "Ownable: new owner is the zero address"
169         );
170         _transferOwnership(newOwner);
171     }
172 
173     /**
174      * @dev Transfers ownership of the contract to a new account (`newOwner`).
175      * Internal function without access restriction.
176      */
177     function _transferOwnership(address newOwner) internal virtual {
178         address oldOwner = _owner;
179         _owner = newOwner;
180         emit OwnershipTransferred(oldOwner, newOwner);
181     }
182 }
183 
184 // File: @openzeppelin/contracts/utils/Address.sol
185 
186 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
187 
188 pragma solidity ^0.8.0;
189 
190 /**
191  * @dev Collection of functions related to the address type
192  */
193 library Address {
194     /**
195      * @dev Returns true if `account` is a contract.
196      *
197      * [IMPORTANT]
198      * ====
199      * It is unsafe to assume that an address for which this function returns
200      * false is an externally-owned account (EOA) and not a contract.
201      *
202      * Among others, `isContract` will return false for the following
203      * types of addresses:
204      *
205      *  - an externally-owned account
206      *  - a contract in construction
207      *  - an address where a contract will be created
208      *  - an address where a contract lived, but was destroyed
209      * ====
210      */
211     function isContract(address account) internal view returns (bool) {
212         // This method relies on extcodesize, which returns 0 for contracts in
213         // construction, since the code is only stored at the end of the
214         // constructor execution.
215 
216         uint256 size;
217         assembly {
218             size := extcodesize(account)
219         }
220         return size > 0;
221     }
222 
223     /**
224      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
225      * `recipient`, forwarding all available gas and reverting on errors.
226      *
227      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
228      * of certain opcodes, possibly making contracts go over the 2300 gas limit
229      * imposed by `transfer`, making them unable to receive funds via
230      * `transfer`. {sendValue} removes this limitation.
231      *
232      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
233      *
234      * IMPORTANT: because control is transferred to `recipient`, care must be
235      * taken to not create reentrancy vulnerabilities. Consider using
236      * {ReentrancyGuard} or the
237      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
238      */
239     function sendValue(address payable recipient, uint256 amount) internal {
240         require(
241             address(this).balance >= amount,
242             "Address: insufficient balance"
243         );
244 
245         (bool success, ) = recipient.call{value: amount}("");
246         require(
247             success,
248             "Address: unable to send value, recipient may have reverted"
249         );
250     }
251 
252     /**
253      * @dev Performs a Solidity function call using a low level `call`. A
254      * plain `call` is an unsafe replacement for a function call: use this
255      * function instead.
256      *
257      * If `target` reverts with a revert reason, it is bubbled up by this
258      * function (like regular Solidity function calls).
259      *
260      * Returns the raw returned data. To convert to the expected return value,
261      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
262      *
263      * Requirements:
264      *
265      * - `target` must be a contract.
266      * - calling `target` with `data` must not revert.
267      *
268      * _Available since v3.1._
269      */
270     function functionCall(address target, bytes memory data)
271         internal
272         returns (bytes memory)
273     {
274         return functionCall(target, data, "Address: low-level call failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
279      * `errorMessage` as a fallback revert reason when `target` reverts.
280      *
281      * _Available since v3.1._
282      */
283     function functionCall(
284         address target,
285         bytes memory data,
286         string memory errorMessage
287     ) internal returns (bytes memory) {
288         return functionCallWithValue(target, data, 0, errorMessage);
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
293      * but also transferring `value` wei to `target`.
294      *
295      * Requirements:
296      *
297      * - the calling contract must have an ETH balance of at least `value`.
298      * - the called Solidity function must be `payable`.
299      *
300      * _Available since v3.1._
301      */
302     function functionCallWithValue(
303         address target,
304         bytes memory data,
305         uint256 value
306     ) internal returns (bytes memory) {
307         return
308             functionCallWithValue(
309                 target,
310                 data,
311                 value,
312                 "Address: low-level call with value failed"
313             );
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
318      * with `errorMessage` as a fallback revert reason when `target` reverts.
319      *
320      * _Available since v3.1._
321      */
322     function functionCallWithValue(
323         address target,
324         bytes memory data,
325         uint256 value,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         require(
329             address(this).balance >= value,
330             "Address: insufficient balance for call"
331         );
332         require(isContract(target), "Address: call to non-contract");
333 
334         (bool success, bytes memory returndata) = target.call{value: value}(
335             data
336         );
337         return verifyCallResult(success, returndata, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but performing a static call.
343      *
344      * _Available since v3.3._
345      */
346     function functionStaticCall(address target, bytes memory data)
347         internal
348         view
349         returns (bytes memory)
350     {
351         return
352             functionStaticCall(
353                 target,
354                 data,
355                 "Address: low-level static call failed"
356             );
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
361      * but performing a static call.
362      *
363      * _Available since v3.3._
364      */
365     function functionStaticCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal view returns (bytes memory) {
370         require(isContract(target), "Address: static call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.staticcall(data);
373         return verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but performing a delegate call.
379      *
380      * _Available since v3.4._
381      */
382     function functionDelegateCall(address target, bytes memory data)
383         internal
384         returns (bytes memory)
385     {
386         return
387             functionDelegateCall(
388                 target,
389                 data,
390                 "Address: low-level delegate call failed"
391             );
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
396      * but performing a delegate call.
397      *
398      * _Available since v3.4._
399      */
400     function functionDelegateCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         require(isContract(target), "Address: delegate call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.delegatecall(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
413      * revert reason using the provided one.
414      *
415      * _Available since v4.3._
416      */
417     function verifyCallResult(
418         bool success,
419         bytes memory returndata,
420         string memory errorMessage
421     ) internal pure returns (bytes memory) {
422         if (success) {
423             return returndata;
424         } else {
425             // Look for revert reason and bubble it up if present
426             if (returndata.length > 0) {
427                 // The easiest way to bubble the revert reason is using memory via assembly
428 
429                 assembly {
430                     let returndata_size := mload(returndata)
431                     revert(add(32, returndata), returndata_size)
432                 }
433             } else {
434                 revert(errorMessage);
435             }
436         }
437     }
438 }
439 
440 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
441 
442 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
443 
444 pragma solidity ^0.8.0;
445 
446 /**
447  * @title ERC721 token receiver interface
448  * @dev Interface for any contract that wants to support safeTransfers
449  * from ERC721 asset contracts.
450  */
451 interface IERC721Receiver {
452     /**
453      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
454      * by `operator` from `from`, this function is called.
455      *
456      * It must return its Solidity selector to confirm the token transfer.
457      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
458      *
459      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
460      */
461     function onERC721Received(
462         address operator,
463         address from,
464         uint256 tokenId,
465         bytes calldata data
466     ) external returns (bytes4);
467 }
468 
469 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
470 
471 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
472 
473 pragma solidity ^0.8.0;
474 
475 /**
476  * @dev Interface of the ERC165 standard, as defined in the
477  * https://eips.ethereum.org/EIPS/eip-165[EIP].
478  *
479  * Implementers can declare support of contract interfaces, which can then be
480  * queried by others ({ERC165Checker}).
481  *
482  * For an implementation, see {ERC165}.
483  */
484 interface IERC165 {
485     /**
486      * @dev Returns true if this contract implements the interface defined by
487      * `interfaceId`. See the corresponding
488      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
489      * to learn more about how these ids are created.
490      *
491      * This function call must use less than 30 000 gas.
492      */
493     function supportsInterface(bytes4 interfaceId) external view returns (bool);
494 }
495 
496 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
497 
498 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @dev Implementation of the {IERC165} interface.
504  *
505  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
506  * for the additional interface id that will be supported. For example:
507  *
508  * ```solidity
509  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
510  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
511  * }
512  * ```
513  *
514  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
515  */
516 abstract contract ERC165 is IERC165 {
517     /**
518      * @dev See {IERC165-supportsInterface}.
519      */
520     function supportsInterface(bytes4 interfaceId)
521         public
522         view
523         virtual
524         override
525         returns (bool)
526     {
527         return interfaceId == type(IERC165).interfaceId;
528     }
529 }
530 
531 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
532 
533 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 /**
538  * @dev Required interface of an ERC721 compliant contract.
539  */
540 interface IERC721 is IERC165 {
541     /**
542      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
543      */
544     event Transfer(
545         address indexed from,
546         address indexed to,
547         uint256 indexed tokenId
548     );
549 
550     /**
551      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
552      */
553     event Approval(
554         address indexed owner,
555         address indexed approved,
556         uint256 indexed tokenId
557     );
558 
559     /**
560      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
561      */
562     event ApprovalForAll(
563         address indexed owner,
564         address indexed operator,
565         bool approved
566     );
567 
568     /**
569      * @dev Returns the number of tokens in ``owner``'s account.
570      */
571     function balanceOf(address owner) external view returns (uint256 balance);
572 
573     /**
574      * @dev Returns the owner of the `tokenId` token.
575      *
576      * Requirements:
577      *
578      * - `tokenId` must exist.
579      */
580     function ownerOf(uint256 tokenId) external view returns (address owner);
581 
582     /**
583      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
584      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
585      *
586      * Requirements:
587      *
588      * - `from` cannot be the zero address.
589      * - `to` cannot be the zero address.
590      * - `tokenId` token must exist and be owned by `from`.
591      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
592      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
593      *
594      * Emits a {Transfer} event.
595      */
596     function safeTransferFrom(
597         address from,
598         address to,
599         uint256 tokenId
600     ) external;
601 
602     /**
603      * @dev Transfers `tokenId` token from `from` to `to`.
604      *
605      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
606      *
607      * Requirements:
608      *
609      * - `from` cannot be the zero address.
610      * - `to` cannot be the zero address.
611      * - `tokenId` token must be owned by `from`.
612      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
613      *
614      * Emits a {Transfer} event.
615      */
616     function transferFrom(
617         address from,
618         address to,
619         uint256 tokenId
620     ) external;
621 
622     /**
623      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
624      * The approval is cleared when the token is transferred.
625      *
626      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
627      *
628      * Requirements:
629      *
630      * - The caller must own the token or be an approved operator.
631      * - `tokenId` must exist.
632      *
633      * Emits an {Approval} event.
634      */
635     function approve(address to, uint256 tokenId) external;
636 
637     /**
638      * @dev Returns the account approved for `tokenId` token.
639      *
640      * Requirements:
641      *
642      * - `tokenId` must exist.
643      */
644     function getApproved(uint256 tokenId)
645         external
646         view
647         returns (address operator);
648 
649     /**
650      * @dev Approve or remove `operator` as an operator for the caller.
651      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
652      *
653      * Requirements:
654      *
655      * - The `operator` cannot be the caller.
656      *
657      * Emits an {ApprovalForAll} event.
658      */
659     function setApprovalForAll(address operator, bool _approved) external;
660 
661     /**
662      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
663      *
664      * See {setApprovalForAll}
665      */
666     function isApprovedForAll(address owner, address operator)
667         external
668         view
669         returns (bool);
670 
671     /**
672      * @dev Safely transfers `tokenId` token from `from` to `to`.
673      *
674      * Requirements:
675      *
676      * - `from` cannot be the zero address.
677      * - `to` cannot be the zero address.
678      * - `tokenId` token must exist and be owned by `from`.
679      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
680      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
681      *
682      * Emits a {Transfer} event.
683      */
684     function safeTransferFrom(
685         address from,
686         address to,
687         uint256 tokenId,
688         bytes calldata data
689     ) external;
690 }
691 
692 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
693 
694 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
695 
696 pragma solidity ^0.8.0;
697 
698 /**
699  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
700  * @dev See https://eips.ethereum.org/EIPS/eip-721
701  */
702 interface IERC721Enumerable is IERC721 {
703     /**
704      * @dev Returns the total amount of tokens stored by the contract.
705      */
706     function totalSupply() external view returns (uint256);
707 
708     /**
709      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
710      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
711      */
712     function tokenOfOwnerByIndex(address owner, uint256 index)
713         external
714         view
715         returns (uint256 tokenId);
716 
717     /**
718      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
719      * Use along with {totalSupply} to enumerate all tokens.
720      */
721     function tokenByIndex(uint256 index) external view returns (uint256);
722 }
723 
724 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
725 
726 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
727 
728 pragma solidity ^0.8.0;
729 
730 /**
731  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
732  * @dev See https://eips.ethereum.org/EIPS/eip-721
733  */
734 interface IERC721Metadata is IERC721 {
735     /**
736      * @dev Returns the token collection name.
737      */
738     function name() external view returns (string memory);
739 
740     /**
741      * @dev Returns the token collection symbol.
742      */
743     function symbol() external view returns (string memory);
744 
745     /**
746      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
747      */
748     function tokenURI(uint256 tokenId) external view returns (string memory);
749 }
750 
751 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
752 
753 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
754 
755 pragma solidity ^0.8.0;
756 
757 /**
758  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
759  * the Metadata extension, but not including the Enumerable extension, which is available separately as
760  * {ERC721Enumerable}.
761  */
762 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
763     using Address for address;
764     using Strings for uint256;
765 
766     // Token name
767     string private _name;
768 
769     // Token symbol
770     string private _symbol;
771 
772     // Mapping from token ID to owner address
773     mapping(uint256 => address) private _owners;
774 
775     // Mapping owner address to token count
776     mapping(address => uint256) private _balances;
777 
778     // Mapping from token ID to approved address
779     mapping(uint256 => address) private _tokenApprovals;
780 
781     // Mapping from owner to operator approvals
782     mapping(address => mapping(address => bool)) private _operatorApprovals;
783 
784     /**
785      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
786      */
787     constructor(string memory name_, string memory symbol_) {
788         _name = name_;
789         _symbol = symbol_;
790     }
791 
792     /**
793      * @dev See {IERC165-supportsInterface}.
794      */
795     function supportsInterface(bytes4 interfaceId)
796         public
797         view
798         virtual
799         override(ERC165, IERC165)
800         returns (bool)
801     {
802         return
803             interfaceId == type(IERC721).interfaceId ||
804             interfaceId == type(IERC721Metadata).interfaceId ||
805             super.supportsInterface(interfaceId);
806     }
807 
808     /**
809      * @dev See {IERC721-balanceOf}.
810      */
811     function balanceOf(address owner)
812         public
813         view
814         virtual
815         override
816         returns (uint256)
817     {
818         require(
819             owner != address(0),
820             "ERC721: balance query for the zero address"
821         );
822         return _balances[owner];
823     }
824 
825     /**
826      * @dev See {IERC721-ownerOf}.
827      */
828     function ownerOf(uint256 tokenId)
829         public
830         view
831         virtual
832         override
833         returns (address)
834     {
835         address owner = _owners[tokenId];
836         require(
837             owner != address(0),
838             "ERC721: owner query for nonexistent token"
839         );
840         return owner;
841     }
842 
843     /**
844      * @dev See {IERC721Metadata-name}.
845      */
846     function name() public view virtual override returns (string memory) {
847         return _name;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-symbol}.
852      */
853     function symbol() public view virtual override returns (string memory) {
854         return _symbol;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-tokenURI}.
859      */
860     function tokenURI(uint256 tokenId)
861         public
862         view
863         virtual
864         override
865         returns (string memory)
866     {
867         require(
868             _exists(tokenId),
869             "ERC721Metadata: URI query for nonexistent token"
870         );
871 
872         string memory baseURI = _baseURI();
873         return
874             bytes(baseURI).length > 0
875                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
876                 : "";
877     }
878 
879     /**
880      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
881      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
882      * by default, can be overriden in child contracts.
883      */
884     function _baseURI() internal view virtual returns (string memory) {
885         return "";
886     }
887 
888     /**
889      * @dev See {IERC721-approve}.
890      */
891     function approve(address to, uint256 tokenId) public virtual override {
892         address owner = ERC721.ownerOf(tokenId);
893         require(to != owner, "ERC721: approval to current owner");
894 
895         require(
896             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
897             "ERC721: approve caller is not owner nor approved for all"
898         );
899 
900         _approve(to, tokenId);
901     }
902 
903     /**
904      * @dev See {IERC721-getApproved}.
905      */
906     function getApproved(uint256 tokenId)
907         public
908         view
909         virtual
910         override
911         returns (address)
912     {
913         require(
914             _exists(tokenId),
915             "ERC721: approved query for nonexistent token"
916         );
917 
918         return _tokenApprovals[tokenId];
919     }
920 
921     /**
922      * @dev See {IERC721-setApprovalForAll}.
923      */
924     function setApprovalForAll(address operator, bool approved)
925         public
926         virtual
927         override
928     {
929         _setApprovalForAll(_msgSender(), operator, approved);
930     }
931 
932     /**
933      * @dev See {IERC721-isApprovedForAll}.
934      */
935     function isApprovedForAll(address owner, address operator)
936         public
937         view
938         virtual
939         override
940         returns (bool)
941     {
942         return _operatorApprovals[owner][operator];
943     }
944 
945     /**
946      * @dev See {IERC721-transferFrom}.
947      */
948     function transferFrom(
949         address from,
950         address to,
951         uint256 tokenId
952     ) public virtual override {
953         //solhint-disable-next-line max-line-length
954         require(
955             _isApprovedOrOwner(_msgSender(), tokenId),
956             "ERC721: transfer caller is not owner nor approved"
957         );
958 
959         _transfer(from, to, tokenId);
960     }
961 
962     /**
963      * @dev See {IERC721-safeTransferFrom}.
964      */
965     function safeTransferFrom(
966         address from,
967         address to,
968         uint256 tokenId
969     ) public virtual override {
970         safeTransferFrom(from, to, tokenId, "");
971     }
972 
973     /**
974      * @dev See {IERC721-safeTransferFrom}.
975      */
976     function safeTransferFrom(
977         address from,
978         address to,
979         uint256 tokenId,
980         bytes memory _data
981     ) public virtual override {
982         require(
983             _isApprovedOrOwner(_msgSender(), tokenId),
984             "ERC721: transfer caller is not owner nor approved"
985         );
986         _safeTransfer(from, to, tokenId, _data);
987     }
988 
989     /**
990      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
991      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
992      *
993      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
994      *
995      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
996      * implement alternative mechanisms to perform token transfer, such as signature-based.
997      *
998      * Requirements:
999      *
1000      * - `from` cannot be the zero address.
1001      * - `to` cannot be the zero address.
1002      * - `tokenId` token must exist and be owned by `from`.
1003      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _safeTransfer(
1008         address from,
1009         address to,
1010         uint256 tokenId,
1011         bytes memory _data
1012     ) internal virtual {
1013         _transfer(from, to, tokenId);
1014         require(
1015             _checkOnERC721Received(from, to, tokenId, _data),
1016             "ERC721: transfer to non ERC721Receiver implementer"
1017         );
1018     }
1019 
1020     /**
1021      * @dev Returns whether `tokenId` exists.
1022      *
1023      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1024      *
1025      * Tokens start existing when they are minted (`_mint`),
1026      * and stop existing when they are burned (`_burn`).
1027      */
1028     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1029         return _owners[tokenId] != address(0);
1030     }
1031 
1032     /**
1033      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1034      *
1035      * Requirements:
1036      *
1037      * - `tokenId` must exist.
1038      */
1039     function _isApprovedOrOwner(address spender, uint256 tokenId)
1040         internal
1041         view
1042         virtual
1043         returns (bool)
1044     {
1045         require(
1046             _exists(tokenId),
1047             "ERC721: operator query for nonexistent token"
1048         );
1049         address owner = ERC721.ownerOf(tokenId);
1050         return (spender == owner ||
1051             getApproved(tokenId) == spender ||
1052             isApprovedForAll(owner, spender));
1053     }
1054 
1055     /**
1056      * @dev Safely mints `tokenId` and transfers it to `to`.
1057      *
1058      * Requirements:
1059      *
1060      * - `tokenId` must not exist.
1061      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function _safeMint(address to, uint256 tokenId) internal virtual {
1066         _safeMint(to, tokenId, "");
1067     }
1068 
1069     /**
1070      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1071      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1072      */
1073     function _safeMint(
1074         address to,
1075         uint256 tokenId,
1076         bytes memory _data
1077     ) internal virtual {
1078         _mint(to, tokenId);
1079         require(
1080             _checkOnERC721Received(address(0), to, tokenId, _data),
1081             "ERC721: transfer to non ERC721Receiver implementer"
1082         );
1083     }
1084 
1085     /**
1086      * @dev Mints `tokenId` and transfers it to `to`.
1087      *
1088      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1089      *
1090      * Requirements:
1091      *
1092      * - `tokenId` must not exist.
1093      * - `to` cannot be the zero address.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function _mint(address to, uint256 tokenId) internal virtual {
1098         require(to != address(0), "ERC721: mint to the zero address");
1099         require(!_exists(tokenId), "ERC721: token already minted");
1100 
1101         _beforeTokenTransfer(address(0), to, tokenId);
1102 
1103         _balances[to] += 1;
1104         _owners[tokenId] = to;
1105 
1106         emit Transfer(address(0), to, tokenId);
1107     }
1108 
1109     /**
1110      * @dev Destroys `tokenId`.
1111      * The approval is cleared when the token is burned.
1112      *
1113      * Requirements:
1114      *
1115      * - `tokenId` must exist.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _burn(uint256 tokenId) internal virtual {
1120         address owner = ERC721.ownerOf(tokenId);
1121 
1122         _beforeTokenTransfer(owner, address(0), tokenId);
1123 
1124         // Clear approvals
1125         _approve(address(0), tokenId);
1126 
1127         _balances[owner] -= 1;
1128         delete _owners[tokenId];
1129 
1130         emit Transfer(owner, address(0), tokenId);
1131     }
1132 
1133     /**
1134      * @dev Transfers `tokenId` from `from` to `to`.
1135      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1136      *
1137      * Requirements:
1138      *
1139      * - `to` cannot be the zero address.
1140      * - `tokenId` token must be owned by `from`.
1141      *
1142      * Emits a {Transfer} event.
1143      */
1144     function _transfer(
1145         address from,
1146         address to,
1147         uint256 tokenId
1148     ) internal virtual {
1149         require(
1150             ERC721.ownerOf(tokenId) == from,
1151             "ERC721: transfer of token that is not own"
1152         );
1153         require(to != address(0), "ERC721: transfer to the zero address");
1154 
1155         _beforeTokenTransfer(from, to, tokenId);
1156 
1157         // Clear approvals from the previous owner
1158         _approve(address(0), tokenId);
1159 
1160         _balances[from] -= 1;
1161         _balances[to] += 1;
1162         _owners[tokenId] = to;
1163 
1164         emit Transfer(from, to, tokenId);
1165     }
1166 
1167     /**
1168      * @dev Approve `to` to operate on `tokenId`
1169      *
1170      * Emits a {Approval} event.
1171      */
1172     function _approve(address to, uint256 tokenId) internal virtual {
1173         _tokenApprovals[tokenId] = to;
1174         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1175     }
1176 
1177     /**
1178      * @dev Approve `operator` to operate on all of `owner` tokens
1179      *
1180      * Emits a {ApprovalForAll} event.
1181      */
1182     function _setApprovalForAll(
1183         address owner,
1184         address operator,
1185         bool approved
1186     ) internal virtual {
1187         require(owner != operator, "ERC721: approve to caller");
1188         _operatorApprovals[owner][operator] = approved;
1189         emit ApprovalForAll(owner, operator, approved);
1190     }
1191 
1192     /**
1193      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1194      * The call is not executed if the target address is not a contract.
1195      *
1196      * @param from address representing the previous owner of the given token ID
1197      * @param to target address that will receive the tokens
1198      * @param tokenId uint256 ID of the token to be transferred
1199      * @param _data bytes optional data to send along with the call
1200      * @return bool whether the call correctly returned the expected magic value
1201      */
1202     function _checkOnERC721Received(
1203         address from,
1204         address to,
1205         uint256 tokenId,
1206         bytes memory _data
1207     ) private returns (bool) {
1208         if (to.isContract()) {
1209             try
1210                 IERC721Receiver(to).onERC721Received(
1211                     _msgSender(),
1212                     from,
1213                     tokenId,
1214                     _data
1215                 )
1216             returns (bytes4 retval) {
1217                 return retval == IERC721Receiver.onERC721Received.selector;
1218             } catch (bytes memory reason) {
1219                 if (reason.length == 0) {
1220                     revert(
1221                         "ERC721: transfer to non ERC721Receiver implementer"
1222                     );
1223                 } else {
1224                     assembly {
1225                         revert(add(32, reason), mload(reason))
1226                     }
1227                 }
1228             }
1229         } else {
1230             return true;
1231         }
1232     }
1233 
1234     /**
1235      * @dev Hook that is called before any token transfer. This includes minting
1236      * and burning.
1237      *
1238      * Calling conditions:
1239      *
1240      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1241      * transferred to `to`.
1242      * - When `from` is zero, `tokenId` will be minted for `to`.
1243      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1244      * - `from` and `to` are never both zero.
1245      *
1246      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1247      */
1248     function _beforeTokenTransfer(
1249         address from,
1250         address to,
1251         uint256 tokenId
1252     ) internal virtual {}
1253 }
1254 
1255 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1256 
1257 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1258 
1259 pragma solidity ^0.8.0;
1260 
1261 /**
1262  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1263  * enumerability of all the token ids in the contract as well as all token ids owned by each
1264  * account.
1265  */
1266 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1267     // Mapping from owner to list of owned token IDs
1268     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1269 
1270     // Mapping from token ID to index of the owner tokens list
1271     mapping(uint256 => uint256) private _ownedTokensIndex;
1272 
1273     // Array with all token ids, used for enumeration
1274     uint256[] private _allTokens;
1275 
1276     // Mapping from token id to position in the allTokens array
1277     mapping(uint256 => uint256) private _allTokensIndex;
1278 
1279     /**
1280      * @dev See {IERC165-supportsInterface}.
1281      */
1282     function supportsInterface(bytes4 interfaceId)
1283         public
1284         view
1285         virtual
1286         override(IERC165, ERC721)
1287         returns (bool)
1288     {
1289         return
1290             interfaceId == type(IERC721Enumerable).interfaceId ||
1291             super.supportsInterface(interfaceId);
1292     }
1293 
1294     /**
1295      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1296      */
1297     function tokenOfOwnerByIndex(address owner, uint256 index)
1298         public
1299         view
1300         virtual
1301         override
1302         returns (uint256)
1303     {
1304         require(
1305             index < ERC721.balanceOf(owner),
1306             "ERC721Enumerable: owner index out of bounds"
1307         );
1308         return _ownedTokens[owner][index];
1309     }
1310 
1311     /**
1312      * @dev See {IERC721Enumerable-totalSupply}.
1313      */
1314     function totalSupply() public view virtual override returns (uint256) {
1315         return _allTokens.length;
1316     }
1317 
1318     /**
1319      * @dev See {IERC721Enumerable-tokenByIndex}.
1320      */
1321     function tokenByIndex(uint256 index)
1322         public
1323         view
1324         virtual
1325         override
1326         returns (uint256)
1327     {
1328         require(
1329             index < ERC721Enumerable.totalSupply(),
1330             "ERC721Enumerable: global index out of bounds"
1331         );
1332         return _allTokens[index];
1333     }
1334 
1335     /**
1336      * @dev Hook that is called before any token transfer. This includes minting
1337      * and burning.
1338      *
1339      * Calling conditions:
1340      *
1341      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1342      * transferred to `to`.
1343      * - When `from` is zero, `tokenId` will be minted for `to`.
1344      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1345      * - `from` cannot be the zero address.
1346      * - `to` cannot be the zero address.
1347      *
1348      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1349      */
1350     function _beforeTokenTransfer(
1351         address from,
1352         address to,
1353         uint256 tokenId
1354     ) internal virtual override {
1355         super._beforeTokenTransfer(from, to, tokenId);
1356 
1357         if (from == address(0)) {
1358             _addTokenToAllTokensEnumeration(tokenId);
1359         } else if (from != to) {
1360             _removeTokenFromOwnerEnumeration(from, tokenId);
1361         }
1362         if (to == address(0)) {
1363             _removeTokenFromAllTokensEnumeration(tokenId);
1364         } else if (to != from) {
1365             _addTokenToOwnerEnumeration(to, tokenId);
1366         }
1367     }
1368 
1369     /**
1370      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1371      * @param to address representing the new owner of the given token ID
1372      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1373      */
1374     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1375         uint256 length = ERC721.balanceOf(to);
1376         _ownedTokens[to][length] = tokenId;
1377         _ownedTokensIndex[tokenId] = length;
1378     }
1379 
1380     /**
1381      * @dev Private function to add a token to this extension's token tracking data structures.
1382      * @param tokenId uint256 ID of the token to be added to the tokens list
1383      */
1384     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1385         _allTokensIndex[tokenId] = _allTokens.length;
1386         _allTokens.push(tokenId);
1387     }
1388 
1389     /**
1390      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1391      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1392      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1393      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1394      * @param from address representing the previous owner of the given token ID
1395      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1396      */
1397     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1398         private
1399     {
1400         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1401         // then delete the last slot (swap and pop).
1402 
1403         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1404         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1405 
1406         // When the token to delete is the last token, the swap operation is unnecessary
1407         if (tokenIndex != lastTokenIndex) {
1408             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1409 
1410             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1411             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1412         }
1413 
1414         // This also deletes the contents at the last position of the array
1415         delete _ownedTokensIndex[tokenId];
1416         delete _ownedTokens[from][lastTokenIndex];
1417     }
1418 
1419     /**
1420      * @dev Private function to remove a token from this extension's token tracking data structures.
1421      * This has O(1) time complexity, but alters the order of the _allTokens array.
1422      * @param tokenId uint256 ID of the token to be removed from the tokens list
1423      */
1424     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1425         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1426         // then delete the last slot (swap and pop).
1427 
1428         uint256 lastTokenIndex = _allTokens.length - 1;
1429         uint256 tokenIndex = _allTokensIndex[tokenId];
1430 
1431         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1432         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1433         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1434         uint256 lastTokenId = _allTokens[lastTokenIndex];
1435 
1436         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1437         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1438 
1439         // This also deletes the contents at the last position of the array
1440         delete _allTokensIndex[tokenId];
1441         _allTokens.pop();
1442     }
1443 }
1444 
1445 // File: contracts/Lord.sol
1446 
1447 pragma solidity >=0.7.0 <0.9.0;
1448 
1449 contract LordSocietyNFT is ERC721Enumerable, Ownable {
1450     using Strings for uint256;
1451 
1452     string baseURI;
1453     string public baseExtension = ".json";
1454     uint256 public cost = 270000000000000000;
1455     uint256 public maxSupply = 7777;
1456     uint256 public maxMintAmount = 2;
1457     uint256 public reservedForTeam = 15;
1458 
1459     string private signature;
1460 
1461     bool public paused = false;
1462     bool public revealed = false;
1463 
1464     bool private whitelistedSale = true;
1465     string public notRevealedUri;
1466 
1467     constructor(
1468         string memory _name,
1469         string memory _symbol,
1470         string memory _initBaseURI,
1471         string memory _initNotRevealedUri
1472     ) ERC721(_name, _symbol) {
1473         setBaseURI(_initBaseURI);
1474         setNotRevealedURI(_initNotRevealedUri);
1475     }
1476 
1477     // internal
1478     function _baseURI() internal view virtual override returns (string memory) {
1479         return baseURI;
1480     }
1481 
1482     function presaleMint(uint256 _mintAmount, string memory _signature)
1483         public
1484         payable
1485     {
1486         require(!paused, "Contract is paused");
1487         require(whitelistedSale);
1488         require(
1489             keccak256(abi.encodePacked((signature))) ==
1490                 keccak256(abi.encodePacked((_signature))),
1491             "Invalid signature"
1492         );
1493         require(msg.sender != owner());
1494 
1495         uint256 supply = totalSupply();
1496         uint256 totalAmount;
1497 
1498         uint256 tokenCount = balanceOf(msg.sender);
1499 
1500         require(
1501             tokenCount + _mintAmount <= maxMintAmount,
1502             string(abi.encodePacked("Limit token ", tokenCount.toString()))
1503         );
1504         require(
1505             supply + _mintAmount <= maxSupply - reservedForTeam,
1506             "Max Supply"
1507         );
1508 
1509         totalAmount = cost * _mintAmount;
1510 
1511         require(
1512             msg.value >= totalAmount,
1513             string(
1514                 abi.encodePacked(
1515                     "Incorrect amount ",
1516                     totalAmount.toString(),
1517                     " ",
1518                     msg.value.toString()
1519                 )
1520             )
1521         );
1522 
1523         for (uint256 i = 1; i <= _mintAmount; i++) {
1524             _safeMint(msg.sender, supply + i);
1525         }
1526     }
1527 
1528     // public
1529     function mint(uint256 _mintAmount) public payable {
1530         uint256 supply = totalSupply();
1531         uint256 totalAmount;
1532 
1533         require(!paused);
1534         require(_mintAmount > 0);
1535 
1536         // Owner
1537         if (msg.sender == owner()) {
1538             require(reservedForTeam >= _mintAmount);
1539             reservedForTeam -= _mintAmount;
1540         }
1541 
1542         if (msg.sender != owner()) {
1543             require(!whitelistedSale);
1544             uint256 tokenCount = balanceOf(msg.sender);
1545 
1546             require(
1547                 tokenCount + _mintAmount <= maxMintAmount,
1548                 string(abi.encodePacked("Limit token ", tokenCount.toString()))
1549             );
1550             require(
1551                 supply + _mintAmount <= maxSupply - reservedForTeam,
1552                 "Max Supply"
1553             );
1554 
1555             totalAmount = cost * _mintAmount;
1556 
1557             require(
1558                 msg.value >= totalAmount,
1559                 string(
1560                     abi.encodePacked(
1561                         "Incorrect amount ",
1562                         totalAmount.toString(),
1563                         " ",
1564                         msg.value.toString()
1565                     )
1566                 )
1567             );
1568         }
1569 
1570         for (uint256 i = 1; i <= _mintAmount; i++) {
1571             _safeMint(msg.sender, supply + i);
1572         }
1573     }
1574 
1575     function walletOfOwner(address _owner)
1576         public
1577         view
1578         returns (uint256[] memory)
1579     {
1580         uint256 ownerTokenCount = balanceOf(_owner);
1581         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1582 
1583         for (uint256 i; i < ownerTokenCount; i++) {
1584             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1585         }
1586         return tokenIds;
1587     }
1588 
1589     function tokenURI(uint256 tokenId)
1590         public
1591         view
1592         virtual
1593         override
1594         returns (string memory)
1595     {
1596         require(
1597             _exists(tokenId),
1598             "ERC721Metadata: URI query for nonexistent token"
1599         );
1600 
1601         if (revealed == false) {
1602             return notRevealedUri;
1603         }
1604 
1605         string memory currentBaseURI = _baseURI();
1606         return
1607             bytes(currentBaseURI).length > 0
1608                 ? string(
1609                     abi.encodePacked(
1610                         currentBaseURI,
1611                         tokenId.toString(),
1612                         baseExtension
1613                     )
1614                 )
1615                 : "";
1616     }
1617 
1618     //only owner
1619     function reveal() public onlyOwner {
1620         revealed = true;
1621     }
1622 
1623     function setReserved(uint256 _reserved) public onlyOwner {
1624         reservedForTeam = _reserved;
1625     }
1626 
1627     function setCost(uint256 _newCost) public onlyOwner {
1628         cost = _newCost;
1629     }
1630 
1631     function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1632         maxMintAmount = _newmaxMintAmount;
1633     }
1634 
1635     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1636         notRevealedUri = _notRevealedURI;
1637     }
1638 
1639     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1640         baseURI = _newBaseURI;
1641     }
1642 
1643     function setBaseExtension(string memory _newBaseExtension)
1644         public
1645         onlyOwner
1646     {
1647         baseExtension = _newBaseExtension;
1648     }
1649 
1650     function pause(bool _state) public onlyOwner {
1651         paused = _state;
1652     }
1653 
1654     function whitelistSale(bool _state) public onlyOwner {
1655         whitelistedSale = _state;
1656     }
1657 
1658     function setSignature(string memory _signature) public onlyOwner {
1659         signature = _signature;
1660     }
1661 
1662     function withdraw() public payable onlyOwner {
1663         // (bool sa, ) = payable(/*addresstobeupdatedlater*/).call{value: address(this).balance * 5 / 100}("");
1664         // require(sa);
1665 
1666         (bool oa, ) = payable(owner()).call{value: address(this).balance}("");
1667         require(oa);
1668     }
1669 
1670     function partialWithdraw(uint256 _amount) public payable onlyOwner {
1671         uint256 splt_amount = (_amount * 5) / 1000;
1672 
1673         (bool sa, ) = payable(0x689f96DF01126339851AD0D276C7baCD0Cbe78ed).call{value: splt_amount}("");
1674      require(sa);
1675 
1676         (bool success, ) = payable(owner()).call{value: _amount - splt_amount}("");
1677         require(success);
1678     }
1679 
1680     function getBalance() public view onlyOwner returns (uint256) {
1681         return address(this).balance;
1682     }
1683 
1684     function isWhitelisted() public view returns (bool) {
1685         return whitelistedSale;
1686     }
1687 }