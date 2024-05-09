1 // Sources flattened with hardhat v2.6.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.1
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(
49         address indexed previousOwner,
50         address indexed newOwner
51     );
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _setOwner(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), 'Ownable: caller is not the owner');
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _setOwner(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(
92             newOwner != address(0),
93             'Ownable: new owner is the zero address'
94         );
95         _setOwner(newOwner);
96     }
97 
98     function _setOwner(address newOwner) private {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.1
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev Interface of the ERC165 standard, as defined in the
111  * https://eips.ethereum.org/EIPS/eip-165[EIP].
112  *
113  * Implementers can declare support of contract interfaces, which can then be
114  * queried by others ({ERC165Checker}).
115  *
116  * For an implementation, see {ERC165}.
117  */
118 interface IERC165 {
119     /**
120      * @dev Returns true if this contract implements the interface defined by
121      * `interfaceId`. See the corresponding
122      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
123      * to learn more about how these ids are created.
124      *
125      * This function call must use less than 30 000 gas.
126      */
127     function supportsInterface(bytes4 interfaceId) external view returns (bool);
128 }
129 
130 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.1
131 
132 pragma solidity ^0.8.0;
133 
134 /**
135  * @dev Required interface of an ERC721 compliant contract.
136  */
137 interface IERC721 is IERC165 {
138     /**
139      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
140      */
141     event Transfer(
142         address indexed from,
143         address indexed to,
144         uint256 indexed tokenId
145     );
146 
147     /**
148      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
149      */
150     event Approval(
151         address indexed owner,
152         address indexed approved,
153         uint256 indexed tokenId
154     );
155 
156     /**
157      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
158      */
159     event ApprovalForAll(
160         address indexed owner,
161         address indexed operator,
162         bool approved
163     );
164 
165     /**
166      * @dev Returns the number of tokens in ``owner``'s account.
167      */
168     function balanceOf(address owner) external view returns (uint256 balance);
169 
170     /**
171      * @dev Returns the owner of the `tokenId` token.
172      *
173      * Requirements:
174      *
175      * - `tokenId` must exist.
176      */
177     function ownerOf(uint256 tokenId) external view returns (address owner);
178 
179     /**
180      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
181      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
182      *
183      * Requirements:
184      *
185      * - `from` cannot be the zero address.
186      * - `to` cannot be the zero address.
187      * - `tokenId` token must exist and be owned by `from`.
188      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
189      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
190      *
191      * Emits a {Transfer} event.
192      */
193     function safeTransferFrom(
194         address from,
195         address to,
196         uint256 tokenId
197     ) external;
198 
199     /**
200      * @dev Transfers `tokenId` token from `from` to `to`.
201      *
202      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
203      *
204      * Requirements:
205      *
206      * - `from` cannot be the zero address.
207      * - `to` cannot be the zero address.
208      * - `tokenId` token must be owned by `from`.
209      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
210      *
211      * Emits a {Transfer} event.
212      */
213     function transferFrom(
214         address from,
215         address to,
216         uint256 tokenId
217     ) external;
218 
219     /**
220      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
221      * The approval is cleared when the token is transferred.
222      *
223      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
224      *
225      * Requirements:
226      *
227      * - The caller must own the token or be an approved operator.
228      * - `tokenId` must exist.
229      *
230      * Emits an {Approval} event.
231      */
232     function approve(address to, uint256 tokenId) external;
233 
234     /**
235      * @dev Returns the account approved for `tokenId` token.
236      *
237      * Requirements:
238      *
239      * - `tokenId` must exist.
240      */
241     function getApproved(uint256 tokenId)
242         external
243         view
244         returns (address operator);
245 
246     /**
247      * @dev Approve or remove `operator` as an operator for the caller.
248      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
249      *
250      * Requirements:
251      *
252      * - The `operator` cannot be the caller.
253      *
254      * Emits an {ApprovalForAll} event.
255      */
256     function setApprovalForAll(address operator, bool _approved) external;
257 
258     /**
259      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
260      *
261      * See {setApprovalForAll}
262      */
263     function isApprovedForAll(address owner, address operator)
264         external
265         view
266         returns (bool);
267 
268     /**
269      * @dev Safely transfers `tokenId` token from `from` to `to`.
270      *
271      * Requirements:
272      *
273      * - `from` cannot be the zero address.
274      * - `to` cannot be the zero address.
275      * - `tokenId` token must exist and be owned by `from`.
276      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
277      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
278      *
279      * Emits a {Transfer} event.
280      */
281     function safeTransferFrom(
282         address from,
283         address to,
284         uint256 tokenId,
285         bytes calldata data
286     ) external;
287 }
288 
289 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.1
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @title ERC721 token receiver interface
295  * @dev Interface for any contract that wants to support safeTransfers
296  * from ERC721 asset contracts.
297  */
298 interface IERC721Receiver {
299     /**
300      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
301      * by `operator` from `from`, this function is called.
302      *
303      * It must return its Solidity selector to confirm the token transfer.
304      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
305      *
306      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
307      */
308     function onERC721Received(
309         address operator,
310         address from,
311         uint256 tokenId,
312         bytes calldata data
313     ) external returns (bytes4);
314 }
315 
316 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.1
317 
318 pragma solidity ^0.8.0;
319 
320 /**
321  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
322  * @dev See https://eips.ethereum.org/EIPS/eip-721
323  */
324 interface IERC721Metadata is IERC721 {
325     /**
326      * @dev Returns the token collection name.
327      */
328     function name() external view returns (string memory);
329 
330     /**
331      * @dev Returns the token collection symbol.
332      */
333     function symbol() external view returns (string memory);
334 
335     /**
336      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
337      */
338     function tokenURI(uint256 tokenId) external view returns (string memory);
339 }
340 
341 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @dev Collection of functions related to the address type
347  */
348 library Address {
349     /**
350      * @dev Returns true if `account` is a contract.
351      *
352      * [IMPORTANT]
353      * ====
354      * It is unsafe to assume that an address for which this function returns
355      * false is an externally-owned account (EOA) and not a contract.
356      *
357      * Among others, `isContract` will return false for the following
358      * types of addresses:
359      *
360      *  - an externally-owned account
361      *  - a contract in construction
362      *  - an address where a contract will be created
363      *  - an address where a contract lived, but was destroyed
364      * ====
365      */
366     function isContract(address account) internal view returns (bool) {
367         // This method relies on extcodesize, which returns 0 for contracts in
368         // construction, since the code is only stored at the end of the
369         // constructor execution.
370 
371         uint256 size;
372         assembly {
373             size := extcodesize(account)
374         }
375         return size > 0;
376     }
377 
378     /**
379      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
380      * `recipient`, forwarding all available gas and reverting on errors.
381      *
382      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
383      * of certain opcodes, possibly making contracts go over the 2300 gas limit
384      * imposed by `transfer`, making them unable to receive funds via
385      * `transfer`. {sendValue} removes this limitation.
386      *
387      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
388      *
389      * IMPORTANT: because control is transferred to `recipient`, care must be
390      * taken to not create reentrancy vulnerabilities. Consider using
391      * {ReentrancyGuard} or the
392      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
393      */
394     function sendValue(address payable recipient, uint256 amount) internal {
395         require(
396             address(this).balance >= amount,
397             'Address: insufficient balance'
398         );
399 
400         (bool success, ) = recipient.call{value: amount}('');
401         require(
402             success,
403             'Address: unable to send value, recipient may have reverted'
404         );
405     }
406 
407     /**
408      * @dev Performs a Solidity function call using a low level `call`. A
409      * plain `call` is an unsafe replacement for a function call: use this
410      * function instead.
411      *
412      * If `target` reverts with a revert reason, it is bubbled up by this
413      * function (like regular Solidity function calls).
414      *
415      * Returns the raw returned data. To convert to the expected return value,
416      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
417      *
418      * Requirements:
419      *
420      * - `target` must be a contract.
421      * - calling `target` with `data` must not revert.
422      *
423      * _Available since v3.1._
424      */
425     function functionCall(address target, bytes memory data)
426         internal
427         returns (bytes memory)
428     {
429         return functionCall(target, data, 'Address: low-level call failed');
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
434      * `errorMessage` as a fallback revert reason when `target` reverts.
435      *
436      * _Available since v3.1._
437      */
438     function functionCall(
439         address target,
440         bytes memory data,
441         string memory errorMessage
442     ) internal returns (bytes memory) {
443         return functionCallWithValue(target, data, 0, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but also transferring `value` wei to `target`.
449      *
450      * Requirements:
451      *
452      * - the calling contract must have an ETH balance of at least `value`.
453      * - the called Solidity function must be `payable`.
454      *
455      * _Available since v3.1._
456      */
457     function functionCallWithValue(
458         address target,
459         bytes memory data,
460         uint256 value
461     ) internal returns (bytes memory) {
462         return
463             functionCallWithValue(
464                 target,
465                 data,
466                 value,
467                 'Address: low-level call with value failed'
468             );
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
473      * with `errorMessage` as a fallback revert reason when `target` reverts.
474      *
475      * _Available since v3.1._
476      */
477     function functionCallWithValue(
478         address target,
479         bytes memory data,
480         uint256 value,
481         string memory errorMessage
482     ) internal returns (bytes memory) {
483         require(
484             address(this).balance >= value,
485             'Address: insufficient balance for call'
486         );
487         require(isContract(target), 'Address: call to non-contract');
488 
489         (bool success, bytes memory returndata) = target.call{value: value}(
490             data
491         );
492         return verifyCallResult(success, returndata, errorMessage);
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
497      * but performing a static call.
498      *
499      * _Available since v3.3._
500      */
501     function functionStaticCall(address target, bytes memory data)
502         internal
503         view
504         returns (bytes memory)
505     {
506         return
507             functionStaticCall(
508                 target,
509                 data,
510                 'Address: low-level static call failed'
511             );
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
516      * but performing a static call.
517      *
518      * _Available since v3.3._
519      */
520     function functionStaticCall(
521         address target,
522         bytes memory data,
523         string memory errorMessage
524     ) internal view returns (bytes memory) {
525         require(isContract(target), 'Address: static call to non-contract');
526 
527         (bool success, bytes memory returndata) = target.staticcall(data);
528         return verifyCallResult(success, returndata, errorMessage);
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
533      * but performing a delegate call.
534      *
535      * _Available since v3.4._
536      */
537     function functionDelegateCall(address target, bytes memory data)
538         internal
539         returns (bytes memory)
540     {
541         return
542             functionDelegateCall(
543                 target,
544                 data,
545                 'Address: low-level delegate call failed'
546             );
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
551      * but performing a delegate call.
552      *
553      * _Available since v3.4._
554      */
555     function functionDelegateCall(
556         address target,
557         bytes memory data,
558         string memory errorMessage
559     ) internal returns (bytes memory) {
560         require(isContract(target), 'Address: delegate call to non-contract');
561 
562         (bool success, bytes memory returndata) = target.delegatecall(data);
563         return verifyCallResult(success, returndata, errorMessage);
564     }
565 
566     /**
567      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
568      * revert reason using the provided one.
569      *
570      * _Available since v4.3._
571      */
572     function verifyCallResult(
573         bool success,
574         bytes memory returndata,
575         string memory errorMessage
576     ) internal pure returns (bytes memory) {
577         if (success) {
578             return returndata;
579         } else {
580             // Look for revert reason and bubble it up if present
581             if (returndata.length > 0) {
582                 // The easiest way to bubble the revert reason is using memory via assembly
583 
584                 assembly {
585                     let returndata_size := mload(returndata)
586                     revert(add(32, returndata), returndata_size)
587                 }
588             } else {
589                 revert(errorMessage);
590             }
591         }
592     }
593 }
594 
595 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.1
596 
597 pragma solidity ^0.8.0;
598 
599 /**
600  * @dev String operations.
601  */
602 library Strings {
603     bytes16 private constant _HEX_SYMBOLS = '0123456789abcdef';
604 
605     /**
606      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
607      */
608     function toString(uint256 value) internal pure returns (string memory) {
609         // Inspired by OraclizeAPI's implementation - MIT licence
610         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
611 
612         if (value == 0) {
613             return '0';
614         }
615         uint256 temp = value;
616         uint256 digits;
617         while (temp != 0) {
618             digits++;
619             temp /= 10;
620         }
621         bytes memory buffer = new bytes(digits);
622         while (value != 0) {
623             digits -= 1;
624             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
625             value /= 10;
626         }
627         return string(buffer);
628     }
629 
630     /**
631      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
632      */
633     function toHexString(uint256 value) internal pure returns (string memory) {
634         if (value == 0) {
635             return '0x00';
636         }
637         uint256 temp = value;
638         uint256 length = 0;
639         while (temp != 0) {
640             length++;
641             temp >>= 8;
642         }
643         return toHexString(value, length);
644     }
645 
646     /**
647      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
648      */
649     function toHexString(uint256 value, uint256 length)
650         internal
651         pure
652         returns (string memory)
653     {
654         bytes memory buffer = new bytes(2 * length + 2);
655         buffer[0] = '0';
656         buffer[1] = 'x';
657         for (uint256 i = 2 * length + 1; i > 1; --i) {
658             buffer[i] = _HEX_SYMBOLS[value & 0xf];
659             value >>= 4;
660         }
661         require(value == 0, 'Strings: hex length insufficient');
662         return string(buffer);
663     }
664 }
665 
666 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.1
667 
668 pragma solidity ^0.8.0;
669 
670 /**
671  * @dev Implementation of the {IERC165} interface.
672  *
673  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
674  * for the additional interface id that will be supported. For example:
675  *
676  * ```solidity
677  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
678  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
679  * }
680  * ```
681  *
682  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
683  */
684 abstract contract ERC165 is IERC165 {
685     /**
686      * @dev See {IERC165-supportsInterface}.
687      */
688     function supportsInterface(bytes4 interfaceId)
689         public
690         view
691         virtual
692         override
693         returns (bool)
694     {
695         return interfaceId == type(IERC165).interfaceId;
696     }
697 }
698 
699 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.1
700 
701 pragma solidity ^0.8.0;
702 
703 /**
704  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
705  * the Metadata extension, but not including the Enumerable extension, which is available separately as
706  * {ERC721Enumerable}.
707  */
708 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
709     using Address for address;
710     using Strings for uint256;
711 
712     // Token name
713     string private _name;
714 
715     // Token symbol
716     string private _symbol;
717 
718     // Mapping from token ID to owner address
719     mapping(uint256 => address) private _owners;
720 
721     // Mapping owner address to token count
722     mapping(address => uint256) private _balances;
723 
724     // Mapping from token ID to approved address
725     mapping(uint256 => address) private _tokenApprovals;
726 
727     // Mapping from owner to operator approvals
728     mapping(address => mapping(address => bool)) private _operatorApprovals;
729 
730     /**
731      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
732      */
733     constructor(string memory name_, string memory symbol_) {
734         _name = name_;
735         _symbol = symbol_;
736     }
737 
738     /**
739      * @dev See {IERC165-supportsInterface}.
740      */
741     function supportsInterface(bytes4 interfaceId)
742         public
743         view
744         virtual
745         override(ERC165, IERC165)
746         returns (bool)
747     {
748         return
749             interfaceId == type(IERC721).interfaceId ||
750             interfaceId == type(IERC721Metadata).interfaceId ||
751             super.supportsInterface(interfaceId);
752     }
753 
754     /**
755      * @dev See {IERC721-balanceOf}.
756      */
757     function balanceOf(address owner)
758         public
759         view
760         virtual
761         override
762         returns (uint256)
763     {
764         require(
765             owner != address(0),
766             'ERC721: balance query for the zero address'
767         );
768         return _balances[owner];
769     }
770 
771     /**
772      * @dev See {IERC721-ownerOf}.
773      */
774     function ownerOf(uint256 tokenId)
775         public
776         view
777         virtual
778         override
779         returns (address)
780     {
781         address owner = _owners[tokenId];
782         require(
783             owner != address(0),
784             'ERC721: owner query for nonexistent token'
785         );
786         return owner;
787     }
788 
789     /**
790      * @dev See {IERC721Metadata-name}.
791      */
792     function name() public view virtual override returns (string memory) {
793         return _name;
794     }
795 
796     /**
797      * @dev See {IERC721Metadata-symbol}.
798      */
799     function symbol() public view virtual override returns (string memory) {
800         return _symbol;
801     }
802 
803     /**
804      * @dev See {IERC721Metadata-tokenURI}.
805      */
806     function tokenURI(uint256 tokenId)
807         public
808         view
809         virtual
810         override
811         returns (string memory)
812     {
813         require(
814             _exists(tokenId),
815             'ERC721Metadata: URI query for nonexistent token'
816         );
817 
818         string memory baseURI = _baseURI();
819         return
820             bytes(baseURI).length > 0
821                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
822                 : '';
823     }
824 
825     /**
826      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
827      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
828      * by default, can be overriden in child contracts.
829      */
830     function _baseURI() internal view virtual returns (string memory) {
831         return '';
832     }
833 
834     /**
835      * @dev See {IERC721-approve}.
836      */
837     function approve(address to, uint256 tokenId) public virtual override {
838         address owner = ERC721.ownerOf(tokenId);
839         require(to != owner, 'ERC721: approval to current owner');
840 
841         require(
842             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
843             'ERC721: approve caller is not owner nor approved for all'
844         );
845 
846         _approve(to, tokenId);
847     }
848 
849     /**
850      * @dev See {IERC721-getApproved}.
851      */
852     function getApproved(uint256 tokenId)
853         public
854         view
855         virtual
856         override
857         returns (address)
858     {
859         require(
860             _exists(tokenId),
861             'ERC721: approved query for nonexistent token'
862         );
863 
864         return _tokenApprovals[tokenId];
865     }
866 
867     /**
868      * @dev See {IERC721-setApprovalForAll}.
869      */
870     function setApprovalForAll(address operator, bool approved)
871         public
872         virtual
873         override
874     {
875         require(operator != _msgSender(), 'ERC721: approve to caller');
876 
877         _operatorApprovals[_msgSender()][operator] = approved;
878         emit ApprovalForAll(_msgSender(), operator, approved);
879     }
880 
881     /**
882      * @dev See {IERC721-isApprovedForAll}.
883      */
884     function isApprovedForAll(address owner, address operator)
885         public
886         view
887         virtual
888         override
889         returns (bool)
890     {
891         return _operatorApprovals[owner][operator];
892     }
893 
894     /**
895      * @dev See {IERC721-transferFrom}.
896      */
897     function transferFrom(
898         address from,
899         address to,
900         uint256 tokenId
901     ) public virtual override {
902         //solhint-disable-next-line max-line-length
903         require(
904             _isApprovedOrOwner(_msgSender(), tokenId),
905             'ERC721: transfer caller is not owner nor approved'
906         );
907 
908         _transfer(from, to, tokenId);
909     }
910 
911     /**
912      * @dev See {IERC721-safeTransferFrom}.
913      */
914     function safeTransferFrom(
915         address from,
916         address to,
917         uint256 tokenId
918     ) public virtual override {
919         safeTransferFrom(from, to, tokenId, '');
920     }
921 
922     /**
923      * @dev See {IERC721-safeTransferFrom}.
924      */
925     function safeTransferFrom(
926         address from,
927         address to,
928         uint256 tokenId,
929         bytes memory _data
930     ) public virtual override {
931         require(
932             _isApprovedOrOwner(_msgSender(), tokenId),
933             'ERC721: transfer caller is not owner nor approved'
934         );
935         _safeTransfer(from, to, tokenId, _data);
936     }
937 
938     /**
939      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
940      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
941      *
942      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
943      *
944      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
945      * implement alternative mechanisms to perform token transfer, such as signature-based.
946      *
947      * Requirements:
948      *
949      * - `from` cannot be the zero address.
950      * - `to` cannot be the zero address.
951      * - `tokenId` token must exist and be owned by `from`.
952      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
953      *
954      * Emits a {Transfer} event.
955      */
956     function _safeTransfer(
957         address from,
958         address to,
959         uint256 tokenId,
960         bytes memory _data
961     ) internal virtual {
962         _transfer(from, to, tokenId);
963         require(
964             _checkOnERC721Received(from, to, tokenId, _data),
965             'ERC721: transfer to non ERC721Receiver implementer'
966         );
967     }
968 
969     /**
970      * @dev Returns whether `tokenId` exists.
971      *
972      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
973      *
974      * Tokens start existing when they are minted (`_mint`),
975      * and stop existing when they are burned (`_burn`).
976      */
977     function _exists(uint256 tokenId) internal view virtual returns (bool) {
978         return _owners[tokenId] != address(0);
979     }
980 
981     /**
982      * @dev Returns whether `spender` is allowed to manage `tokenId`.
983      *
984      * Requirements:
985      *
986      * - `tokenId` must exist.
987      */
988     function _isApprovedOrOwner(address spender, uint256 tokenId)
989         internal
990         view
991         virtual
992         returns (bool)
993     {
994         require(
995             _exists(tokenId),
996             'ERC721: operator query for nonexistent token'
997         );
998         address owner = ERC721.ownerOf(tokenId);
999         return (spender == owner ||
1000             getApproved(tokenId) == spender ||
1001             isApprovedForAll(owner, spender));
1002     }
1003 
1004     /**
1005      * @dev Safely mints `tokenId` and transfers it to `to`.
1006      *
1007      * Requirements:
1008      *
1009      * - `tokenId` must not exist.
1010      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _safeMint(address to, uint256 tokenId) internal virtual {
1015         _safeMint(to, tokenId, '');
1016     }
1017 
1018     /**
1019      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1020      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1021      */
1022     function _safeMint(
1023         address to,
1024         uint256 tokenId,
1025         bytes memory _data
1026     ) internal virtual {
1027         _mint(to, tokenId);
1028         require(
1029             _checkOnERC721Received(address(0), to, tokenId, _data),
1030             'ERC721: transfer to non ERC721Receiver implementer'
1031         );
1032     }
1033 
1034     /**
1035      * @dev Mints `tokenId` and transfers it to `to`.
1036      *
1037      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1038      *
1039      * Requirements:
1040      *
1041      * - `tokenId` must not exist.
1042      * - `to` cannot be the zero address.
1043      *
1044      * Emits a {Transfer} event.
1045      */
1046     function _mint(address to, uint256 tokenId) internal virtual {
1047         require(to != address(0), 'ERC721: mint to the zero address');
1048         require(!_exists(tokenId), 'ERC721: token already minted');
1049 
1050         _beforeTokenTransfer(address(0), to, tokenId);
1051 
1052         _balances[to] += 1;
1053         _owners[tokenId] = to;
1054 
1055         emit Transfer(address(0), to, tokenId);
1056     }
1057 
1058     /**
1059      * @dev Destroys `tokenId`.
1060      * The approval is cleared when the token is burned.
1061      *
1062      * Requirements:
1063      *
1064      * - `tokenId` must exist.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _burn(uint256 tokenId) internal virtual {
1069         address owner = ERC721.ownerOf(tokenId);
1070 
1071         _beforeTokenTransfer(owner, address(0), tokenId);
1072 
1073         // Clear approvals
1074         _approve(address(0), tokenId);
1075 
1076         _balances[owner] -= 1;
1077         delete _owners[tokenId];
1078 
1079         emit Transfer(owner, address(0), tokenId);
1080     }
1081 
1082     /**
1083      * @dev Transfers `tokenId` from `from` to `to`.
1084      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1085      *
1086      * Requirements:
1087      *
1088      * - `to` cannot be the zero address.
1089      * - `tokenId` token must be owned by `from`.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function _transfer(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) internal virtual {
1098         require(
1099             ERC721.ownerOf(tokenId) == from,
1100             'ERC721: transfer of token that is not own'
1101         );
1102         require(to != address(0), 'ERC721: transfer to the zero address');
1103 
1104         _beforeTokenTransfer(from, to, tokenId);
1105 
1106         // Clear approvals from the previous owner
1107         _approve(address(0), tokenId);
1108 
1109         _balances[from] -= 1;
1110         _balances[to] += 1;
1111         _owners[tokenId] = to;
1112 
1113         emit Transfer(from, to, tokenId);
1114     }
1115 
1116     /**
1117      * @dev Approve `to` to operate on `tokenId`
1118      *
1119      * Emits a {Approval} event.
1120      */
1121     function _approve(address to, uint256 tokenId) internal virtual {
1122         _tokenApprovals[tokenId] = to;
1123         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1124     }
1125 
1126     /**
1127      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1128      * The call is not executed if the target address is not a contract.
1129      *
1130      * @param from address representing the previous owner of the given token ID
1131      * @param to target address that will receive the tokens
1132      * @param tokenId uint256 ID of the token to be transferred
1133      * @param _data bytes optional data to send along with the call
1134      * @return bool whether the call correctly returned the expected magic value
1135      */
1136     function _checkOnERC721Received(
1137         address from,
1138         address to,
1139         uint256 tokenId,
1140         bytes memory _data
1141     ) private returns (bool) {
1142         if (to.isContract()) {
1143             try
1144                 IERC721Receiver(to).onERC721Received(
1145                     _msgSender(),
1146                     from,
1147                     tokenId,
1148                     _data
1149                 )
1150             returns (bytes4 retval) {
1151                 return retval == IERC721Receiver.onERC721Received.selector;
1152             } catch (bytes memory reason) {
1153                 if (reason.length == 0) {
1154                     revert(
1155                         'ERC721: transfer to non ERC721Receiver implementer'
1156                     );
1157                 } else {
1158                     assembly {
1159                         revert(add(32, reason), mload(reason))
1160                     }
1161                 }
1162             }
1163         } else {
1164             return true;
1165         }
1166     }
1167 
1168     /**
1169      * @dev Hook that is called before any token transfer. This includes minting
1170      * and burning.
1171      *
1172      * Calling conditions:
1173      *
1174      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1175      * transferred to `to`.
1176      * - When `from` is zero, `tokenId` will be minted for `to`.
1177      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1178      * - `from` and `to` are never both zero.
1179      *
1180      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1181      */
1182     function _beforeTokenTransfer(
1183         address from,
1184         address to,
1185         uint256 tokenId
1186     ) internal virtual {}
1187 }
1188 
1189 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.1
1190 
1191 pragma solidity ^0.8.0;
1192 
1193 /**
1194  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1195  * @dev See https://eips.ethereum.org/EIPS/eip-721
1196  */
1197 interface IERC721Enumerable is IERC721 {
1198     /**
1199      * @dev Returns the total amount of tokens stored by the contract.
1200      */
1201     function totalSupply() external view returns (uint256);
1202 
1203     /**
1204      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1205      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1206      */
1207     function tokenOfOwnerByIndex(address owner, uint256 index)
1208         external
1209         view
1210         returns (uint256 tokenId);
1211 
1212     /**
1213      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1214      * Use along with {totalSupply} to enumerate all tokens.
1215      */
1216     function tokenByIndex(uint256 index) external view returns (uint256);
1217 }
1218 
1219 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.1
1220 
1221 pragma solidity ^0.8.0;
1222 
1223 /**
1224  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1225  * enumerability of all the token ids in the contract as well as all token ids owned by each
1226  * account.
1227  */
1228 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1229     // Mapping from owner to list of owned token IDs
1230     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1231 
1232     // Mapping from token ID to index of the owner tokens list
1233     mapping(uint256 => uint256) private _ownedTokensIndex;
1234 
1235     // Array with all token ids, used for enumeration
1236     uint256[] private _allTokens;
1237 
1238     // Mapping from token id to position in the allTokens array
1239     mapping(uint256 => uint256) private _allTokensIndex;
1240 
1241     /**
1242      * @dev See {IERC165-supportsInterface}.
1243      */
1244     function supportsInterface(bytes4 interfaceId)
1245         public
1246         view
1247         virtual
1248         override(IERC165, ERC721)
1249         returns (bool)
1250     {
1251         return
1252             interfaceId == type(IERC721Enumerable).interfaceId ||
1253             super.supportsInterface(interfaceId);
1254     }
1255 
1256     /**
1257      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1258      */
1259     function tokenOfOwnerByIndex(address owner, uint256 index)
1260         public
1261         view
1262         virtual
1263         override
1264         returns (uint256)
1265     {
1266         require(
1267             index < ERC721.balanceOf(owner),
1268             'ERC721Enumerable: owner index out of bounds'
1269         );
1270         return _ownedTokens[owner][index];
1271     }
1272 
1273     /**
1274      * @dev See {IERC721Enumerable-totalSupply}.
1275      */
1276     function totalSupply() public view virtual override returns (uint256) {
1277         return _allTokens.length;
1278     }
1279 
1280     /**
1281      * @dev See {IERC721Enumerable-tokenByIndex}.
1282      */
1283     function tokenByIndex(uint256 index)
1284         public
1285         view
1286         virtual
1287         override
1288         returns (uint256)
1289     {
1290         require(
1291             index < ERC721Enumerable.totalSupply(),
1292             'ERC721Enumerable: global index out of bounds'
1293         );
1294         return _allTokens[index];
1295     }
1296 
1297     /**
1298      * @dev Hook that is called before any token transfer. This includes minting
1299      * and burning.
1300      *
1301      * Calling conditions:
1302      *
1303      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1304      * transferred to `to`.
1305      * - When `from` is zero, `tokenId` will be minted for `to`.
1306      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1307      * - `from` cannot be the zero address.
1308      * - `to` cannot be the zero address.
1309      *
1310      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1311      */
1312     function _beforeTokenTransfer(
1313         address from,
1314         address to,
1315         uint256 tokenId
1316     ) internal virtual override {
1317         super._beforeTokenTransfer(from, to, tokenId);
1318 
1319         if (from == address(0)) {
1320             _addTokenToAllTokensEnumeration(tokenId);
1321         } else if (from != to) {
1322             _removeTokenFromOwnerEnumeration(from, tokenId);
1323         }
1324         if (to == address(0)) {
1325             _removeTokenFromAllTokensEnumeration(tokenId);
1326         } else if (to != from) {
1327             _addTokenToOwnerEnumeration(to, tokenId);
1328         }
1329     }
1330 
1331     /**
1332      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1333      * @param to address representing the new owner of the given token ID
1334      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1335      */
1336     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1337         uint256 length = ERC721.balanceOf(to);
1338         _ownedTokens[to][length] = tokenId;
1339         _ownedTokensIndex[tokenId] = length;
1340     }
1341 
1342     /**
1343      * @dev Private function to add a token to this extension's token tracking data structures.
1344      * @param tokenId uint256 ID of the token to be added to the tokens list
1345      */
1346     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1347         _allTokensIndex[tokenId] = _allTokens.length;
1348         _allTokens.push(tokenId);
1349     }
1350 
1351     /**
1352      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1353      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1354      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1355      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1356      * @param from address representing the previous owner of the given token ID
1357      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1358      */
1359     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1360         private
1361     {
1362         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1363         // then delete the last slot (swap and pop).
1364 
1365         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1366         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1367 
1368         // When the token to delete is the last token, the swap operation is unnecessary
1369         if (tokenIndex != lastTokenIndex) {
1370             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1371 
1372             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1373             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1374         }
1375 
1376         // This also deletes the contents at the last position of the array
1377         delete _ownedTokensIndex[tokenId];
1378         delete _ownedTokens[from][lastTokenIndex];
1379     }
1380 
1381     /**
1382      * @dev Private function to remove a token from this extension's token tracking data structures.
1383      * This has O(1) time complexity, but alters the order of the _allTokens array.
1384      * @param tokenId uint256 ID of the token to be removed from the tokens list
1385      */
1386     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1387         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1388         // then delete the last slot (swap and pop).
1389 
1390         uint256 lastTokenIndex = _allTokens.length - 1;
1391         uint256 tokenIndex = _allTokensIndex[tokenId];
1392 
1393         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1394         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1395         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1396         uint256 lastTokenId = _allTokens[lastTokenIndex];
1397 
1398         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1399         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1400 
1401         // This also deletes the contents at the last position of the array
1402         delete _allTokensIndex[tokenId];
1403         _allTokens.pop();
1404     }
1405 }
1406 
1407 // File contracts/OpenSeaTradableNFT.sol
1408 
1409 pragma solidity ^0.8.0;
1410 
1411 contract OpenSeaOwnableDelegateProxy {}
1412 
1413 contract OpenSeaProxyRegistry {
1414     mapping(address => OpenSeaOwnableDelegateProxy) public proxies;
1415 }
1416 
1417 contract OpenSeaTradableNFT {
1418     address openSeaProxyRegistryAddress;
1419 
1420     function _setProxyRegistryAddress(address _openSeaProxyRegistryAddress)
1421         internal
1422     {
1423         openSeaProxyRegistryAddress = _openSeaProxyRegistryAddress;
1424     }
1425 
1426     function isApprovedForAll(address owner, address operator)
1427         public
1428         view
1429         virtual
1430         returns (bool)
1431     {
1432         // Whitelist OpenSea proxy contract for easy trading.
1433         OpenSeaProxyRegistry openSeaProxyRegistry = OpenSeaProxyRegistry(
1434             openSeaProxyRegistryAddress
1435         );
1436         if (address(openSeaProxyRegistry.proxies(owner)) == operator) {
1437             return true;
1438         }
1439 
1440         return false;
1441     }
1442 }
1443 
1444 // File contracts/SilverbackNFT.sol
1445 
1446 pragma solidity ^0.8.0;
1447 
1448 interface ISilverToken {
1449     /**
1450      * @dev Called from silverbacks when one is transfered/minted/burned
1451      */
1452     function updateRewards(address _user) external;
1453 }
1454 
1455 contract SilverbackNFT is Ownable, ERC721Enumerable, OpenSeaTradableNFT {
1456     using Strings for uint256;
1457 
1458     /* Base URI for token URIs */
1459     string public baseURI = '';
1460 
1461     /* Amount of PSS required to perform a sacrifice */
1462     uint256 public amountRequiredForSacrifice = 5;
1463 
1464     /* Mapping of PSS that are not allowed to be used in sacrifices */
1465     mapping(uint256 => bool) public invalidTokensForSacrifices;
1466     /* Mapping of PSS used in sacrifice for silverbacks */
1467     mapping(uint256 => uint256[]) public silverbackSacrifices;
1468     /* Mapping of silverbacks created by address */
1469     mapping(uint256 => address) public createdBy;
1470     /* Mapping of address created silverbacks */
1471     mapping(address => uint256) public createdCount;
1472 
1473     /* PSS NFT contract */
1474     IERC721 public primateSocialSocietyNFT;
1475     /* Silver Token contract */
1476     ISilverToken public silverToken;
1477 
1478     /* Keep track of mintId */
1479     uint256 tokensMinted = 0;
1480 
1481     /**
1482      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1483      * transfers.
1484      */
1485     event TransferBatch(
1486         address indexed operator,
1487         address indexed from,
1488         address indexed to,
1489         uint256[] tokenIds
1490     );
1491 
1492     constructor(
1493         string memory _initialBaseURI,
1494         IERC721 _primateSocialSocietyNFT,
1495         address _openSeaProxyRegistryAddress
1496     ) ERC721('Silverback', 'SILVERBACK') {
1497         baseURI = _initialBaseURI;
1498         primateSocialSocietyNFT = _primateSocialSocietyNFT;
1499         OpenSeaTradableNFT._setProxyRegistryAddress(
1500             _openSeaProxyRegistryAddress
1501         );
1502     }
1503 
1504     /**
1505      * @dev Getter to get array of PSS sacrificed for a silverback
1506      */
1507     function getSacrificesUsedFor(uint256 tokenId)
1508         external
1509         view
1510         returns (uint256[] memory)
1511     {
1512         return silverbackSacrifices[tokenId];
1513     }
1514 
1515     /**
1516      * @dev Sacrifice PSS to mint a silverback
1517      */
1518     function sacrifice(uint256[] calldata _tokenIds) external {
1519         require(
1520             _tokenIds.length == amountRequiredForSacrifice,
1521             'Incorrect amount of tokens for sacrifice'
1522         );
1523 
1524         for (uint256 i = 0; i < _tokenIds.length; i++) {
1525             require(
1526                 !invalidTokensForSacrifices[_tokenIds[i]],
1527                 string(
1528                     abi.encodePacked(
1529                         'SilverbackNFT: sacrifice is not valid for ',
1530                         _tokenIds[i].toString()
1531                     )
1532                 )
1533             );
1534 
1535             primateSocialSocietyNFT.transferFrom(
1536                 _msgSender(),
1537                 address(this),
1538                 _tokenIds[i]
1539             );
1540         }
1541 
1542         _safeMint(_msgSender(), tokensMinted);
1543         createdCount[_msgSender()] = createdCount[_msgSender()] + 1;
1544         createdBy[tokensMinted] = _msgSender();
1545         silverbackSacrifices[tokensMinted] = _tokenIds;
1546         tokensMinted = tokensMinted + 1;
1547     }
1548 
1549     /**
1550      * @dev Override to if default approved for OS proxy accounts or normal approval
1551      */
1552     function isApprovedForAll(address owner, address operator)
1553         public
1554         view
1555         override(ERC721, OpenSeaTradableNFT)
1556         returns (bool)
1557     {
1558         if (OpenSeaTradableNFT.isApprovedForAll(owner, operator)) {
1559             return true;
1560         }
1561 
1562         return ERC721.isApprovedForAll(owner, operator);
1563     }
1564 
1565     /**
1566      * @dev Perform burn on a token
1567      */
1568     function burn(uint256 _tokenId) public virtual {
1569         require(
1570             _isApprovedOrOwner(_msgSender(), _tokenId),
1571             'ERC721Burnable: caller is not owner nor approved'
1572         );
1573         _burn(_tokenId);
1574     }
1575 
1576     /**
1577      * @dev Perform burn on a batch of tokens
1578      */
1579     function batchBurn(uint256[] memory _tokenIds) public virtual {
1580         for (uint256 i = 0; i < _tokenIds.length; ++i) {
1581             require(
1582                 _isApprovedOrOwner(_msgSender(), _tokenIds[i]),
1583                 string(
1584                     abi.encodePacked(
1585                         'ERC721Burnable: caller is not owner nor approved for ',
1586                         _tokenIds[i].toString()
1587                     )
1588                 )
1589             );
1590             _burn(_tokenIds[i]);
1591         }
1592     }
1593 
1594     /**
1595      * @dev Perform transferFrom on a batch of tokens
1596      */
1597     function batchTransferFrom(
1598         address from,
1599         address to,
1600         uint256[] memory tokenIds
1601     ) public virtual {
1602         for (uint256 i = 0; i < tokenIds.length; ++i) {
1603             require(
1604                 _isApprovedOrOwner(_msgSender(), tokenIds[i]),
1605                 string(
1606                     abi.encodePacked(
1607                         'ERC721: transfer caller is not owner nor approved for ',
1608                         tokenIds[i].toString()
1609                     )
1610                 )
1611             );
1612             _transfer(from, to, tokenIds[i]);
1613         }
1614 
1615         emit TransferBatch(_msgSender(), from, to, tokenIds);
1616     }
1617 
1618     /**
1619      * @dev Perform safeTransferFrom on a batch of tokens
1620      */
1621     function safeBatchTransferFrom(
1622         address from,
1623         address to,
1624         uint256[] memory tokenIds
1625     ) public virtual {
1626         safeBatchTransferFrom(from, to, tokenIds, '');
1627     }
1628 
1629     /**
1630      * @dev Perform safeTransferFrom on a batch of tokens
1631      */
1632     function safeBatchTransferFrom(
1633         address from,
1634         address to,
1635         uint256[] memory tokenIds,
1636         bytes memory _data
1637     ) public virtual {
1638         for (uint256 i = 0; i < tokenIds.length; ++i) {
1639             require(
1640                 _isApprovedOrOwner(_msgSender(), tokenIds[i]),
1641                 string(
1642                     abi.encodePacked(
1643                         'ERC721: transfer caller is not owner nor approved for ',
1644                         tokenIds[i].toString()
1645                     )
1646                 )
1647             );
1648             _safeTransfer(from, to, tokenIds[i], _data);
1649         }
1650 
1651         emit TransferBatch(_msgSender(), from, to, tokenIds);
1652     }
1653 
1654     /**
1655      * @dev Override to change the baseURI used in tokenURI
1656      */
1657     function _baseURI() internal view virtual override returns (string memory) {
1658         return baseURI;
1659     }
1660 
1661     /**
1662      * @dev Override so we can update silver token rewards before transfer happens
1663      */
1664     function _beforeTokenTransfer(
1665         address from,
1666         address to,
1667         uint256 tokenId
1668     ) internal virtual override {
1669         if (to == address(0)) {
1670             address creator = createdBy[tokenId];
1671             createdCount[creator] = createdCount[creator] - 1;
1672         }
1673 
1674         silverToken.updateRewards(from);
1675         silverToken.updateRewards(to);
1676 
1677         super._beforeTokenTransfer(from, to, tokenId);
1678     }
1679 
1680     /**
1681      * @dev Set the base uri for token metadata
1682      */
1683     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1684         baseURI = _newBaseURI;
1685     }
1686 
1687     /**
1688      * @dev Set the pss nft contract
1689      */
1690     function setPrimateSocialSocietyNFT(IERC721 _primateSocialSocietyNFT)
1691         external
1692         onlyOwner
1693     {
1694         primateSocialSocietyNFT = _primateSocialSocietyNFT;
1695     }
1696 
1697     /**
1698      * @dev Set the silver token contract
1699      */
1700     function setSilverToken(ISilverToken _silverToken) external onlyOwner {
1701         silverToken = _silverToken;
1702     }
1703 
1704     /**
1705      * @dev Updated required amount of PSS needed for sacrifice
1706      */
1707     function updateAmountRequiredForSacrifice(uint256 amount)
1708         external
1709         onlyOwner
1710     {
1711         amountRequiredForSacrifice = amount;
1712     }
1713 
1714     /**
1715      * @dev Configures invalidTokensForSacrifices
1716      */
1717     function configureInvalidTokensForSacrifices(
1718         uint256[] calldata _tokenIds,
1719         bool _invalid
1720     ) external onlyOwner {
1721         for (uint256 i = 0; i < _tokenIds.length; ++i) {
1722             invalidTokensForSacrifices[_tokenIds[i]] = _invalid;
1723         }
1724     }
1725 
1726     /**
1727      * @dev Configures approvalForAll PSS that are sacrificed
1728      */
1729     function configureApprovalForAllPSS(address _operator, bool _approved)
1730         external
1731         onlyOwner
1732     {
1733         primateSocialSocietyNFT.setApprovalForAll(_operator, _approved);
1734     }
1735 }