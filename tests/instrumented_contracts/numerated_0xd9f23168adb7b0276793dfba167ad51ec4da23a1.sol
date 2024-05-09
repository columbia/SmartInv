1 // SPDX-License-Identifier: Unlicense
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // This method relies on extcodesize, which returns 0 for contracts in
28         // construction, since the code is only stored at the end of the
29         // constructor execution.
30 
31         uint256 size;
32         assembly {
33             size := extcodesize(account)
34         }
35         return size > 0;
36     }
37 
38     /**
39      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
40      * `recipient`, forwarding all available gas and reverting on errors.
41      *
42      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
43      * of certain opcodes, possibly making contracts go over the 2300 gas limit
44      * imposed by `transfer`, making them unable to receive funds via
45      * `transfer`. {sendValue} removes this limitation.
46      *
47      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
48      *
49      * IMPORTANT: because control is transferred to `recipient`, care must be
50      * taken to not create reentrancy vulnerabilities. Consider using
51      * {ReentrancyGuard} or the
52      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
53      */
54     function sendValue(address payable recipient, uint256 amount) internal {
55         require(
56             address(this).balance >= amount,
57             "Address: insufficient balance"
58         );
59 
60         (bool success, ) = recipient.call{value: amount}("");
61         require(
62             success,
63             "Address: unable to send value, recipient may have reverted"
64         );
65     }
66 
67     /**
68      * @dev Performs a Solidity function call using a low level `call`. A
69      * plain `call` is an unsafe replacement for a function call: use this
70      * function instead.
71      *
72      * If `target` reverts with a revert reason, it is bubbled up by this
73      * function (like regular Solidity function calls).
74      *
75      * Returns the raw returned data. To convert to the expected return value,
76      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
77      *
78      * Requirements:
79      *
80      * - `target` must be a contract.
81      * - calling `target` with `data` must not revert.
82      *
83      * _Available since v3.1._
84      */
85     function functionCall(address target, bytes memory data)
86         internal
87         returns (bytes memory)
88     {
89         return functionCall(target, data, "Address: low-level call failed");
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
94      * `errorMessage` as a fallback revert reason when `target` reverts.
95      *
96      * _Available since v3.1._
97      */
98     function functionCall(
99         address target,
100         bytes memory data,
101         string memory errorMessage
102     ) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, 0, errorMessage);
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
108      * but also transferring `value` wei to `target`.
109      *
110      * Requirements:
111      *
112      * - the calling contract must have an ETH balance of at least `value`.
113      * - the called Solidity function must be `payable`.
114      *
115      * _Available since v3.1._
116      */
117     function functionCallWithValue(
118         address target,
119         bytes memory data,
120         uint256 value
121     ) internal returns (bytes memory) {
122         return
123             functionCallWithValue(
124                 target,
125                 data,
126                 value,
127                 "Address: low-level call with value failed"
128             );
129     }
130 
131     /**
132      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
133      * with `errorMessage` as a fallback revert reason when `target` reverts.
134      *
135      * _Available since v3.1._
136      */
137     function functionCallWithValue(
138         address target,
139         bytes memory data,
140         uint256 value,
141         string memory errorMessage
142     ) internal returns (bytes memory) {
143         require(
144             address(this).balance >= value,
145             "Address: insufficient balance for call"
146         );
147         require(isContract(target), "Address: call to non-contract");
148 
149         (bool success, bytes memory returndata) = target.call{value: value}(
150             data
151         );
152         return _verifyCallResult(success, returndata, errorMessage);
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
157      * but performing a static call.
158      *
159      * _Available since v3.3._
160      */
161     function functionStaticCall(address target, bytes memory data)
162         internal
163         view
164         returns (bytes memory)
165     {
166         return
167             functionStaticCall(
168                 target,
169                 data,
170                 "Address: low-level static call failed"
171             );
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
176      * but performing a static call.
177      *
178      * _Available since v3.3._
179      */
180     function functionStaticCall(
181         address target,
182         bytes memory data,
183         string memory errorMessage
184     ) internal view returns (bytes memory) {
185         require(isContract(target), "Address: static call to non-contract");
186 
187         (bool success, bytes memory returndata) = target.staticcall(data);
188         return _verifyCallResult(success, returndata, errorMessage);
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
193      * but performing a delegate call.
194      *
195      * _Available since v3.4._
196      */
197     function functionDelegateCall(address target, bytes memory data)
198         internal
199         returns (bytes memory)
200     {
201         return
202             functionDelegateCall(
203                 target,
204                 data,
205                 "Address: low-level delegate call failed"
206             );
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
211      * but performing a delegate call.
212      *
213      * _Available since v3.4._
214      */
215     function functionDelegateCall(
216         address target,
217         bytes memory data,
218         string memory errorMessage
219     ) internal returns (bytes memory) {
220         require(isContract(target), "Address: delegate call to non-contract");
221 
222         (bool success, bytes memory returndata) = target.delegatecall(data);
223         return _verifyCallResult(success, returndata, errorMessage);
224     }
225 
226     function _verifyCallResult(
227         bool success,
228         bytes memory returndata,
229         string memory errorMessage
230     ) private pure returns (bytes memory) {
231         if (success) {
232             return returndata;
233         } else {
234             // Look for revert reason and bubble it up if present
235             if (returndata.length > 0) {
236                 // The easiest way to bubble the revert reason is using memory via assembly
237 
238                 assembly {
239                     let returndata_size := mload(returndata)
240                     revert(add(32, returndata), returndata_size)
241                 }
242             } else {
243                 revert(errorMessage);
244             }
245         }
246     }
247 }
248 
249 /**
250  * @dev String operations.
251  */
252 library Strings {
253     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
254 
255     /**
256      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
257      */
258     function toString(uint256 value) internal pure returns (string memory) {
259         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
260 
261         if (value == 0) {
262             return "0";
263         }
264         uint256 temp = value;
265         uint256 digits;
266         while (temp != 0) {
267             digits++;
268             temp /= 10;
269         }
270         bytes memory buffer = new bytes(digits);
271         while (value != 0) {
272             digits -= 1;
273             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
274             value /= 10;
275         }
276         return string(buffer);
277     }
278 
279     /**
280      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
281      */
282     function toHexString(uint256 value) internal pure returns (string memory) {
283         if (value == 0) {
284             return "0x00";
285         }
286         uint256 temp = value;
287         uint256 length = 0;
288         while (temp != 0) {
289             length++;
290             temp >>= 8;
291         }
292         return toHexString(value, length);
293     }
294 
295     /**
296      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
297      */
298     function toHexString(uint256 value, uint256 length)
299         internal
300         pure
301         returns (string memory)
302     {
303         bytes memory buffer = new bytes(2 * length + 2);
304         buffer[0] = "0";
305         buffer[1] = "x";
306         for (uint256 i = 2 * length + 1; i > 1; --i) {
307             buffer[i] = _HEX_SYMBOLS[value & 0xf];
308             value >>= 4;
309         }
310         require(value == 0, "Strings: hex length insufficient");
311         return string(buffer);
312     }
313 }
314 
315 /*
316  * @dev Provides information about the current execution context, including the
317  * sender of the transaction and its data. While these are generally available
318  * via msg.sender and msg.data, they should not be accessed in such a direct
319  * manner, since when dealing with meta-transactions the account sending and
320  * paying for execution may not be the actual sender (as far as an application
321  * is concerned).
322  *
323  * This contract is only required for intermediate, library-like contracts.
324  */
325 abstract contract Context {
326     function _msgSender() internal view virtual returns (address) {
327         return msg.sender;
328     }
329 
330     function _msgData() internal view virtual returns (bytes calldata) {
331         return msg.data;
332     }
333 }
334 
335 abstract contract Ownable is Context {
336     address private _owner;
337 
338     event OwnershipTransferred(
339         address indexed previousOwner,
340         address indexed newOwner
341     );
342 
343     /**
344      * @dev Initializes the contract setting the deployer as the initial owner.
345      */
346     constructor() {
347         _setOwner(_msgSender());
348     }
349 
350     /**
351      * @dev Returns the address of the current owner.
352      */
353     function owner() public view virtual returns (address) {
354         return _owner;
355     }
356 
357     /**
358      * @dev Throws if called by any account other than the owner.
359      */
360     modifier onlyOwner() {
361         require(owner() == _msgSender(), "Ownable: caller is not the owner");
362         _;
363     }
364 
365     /**
366      * @dev Leaves the contract without owner. It will not be possible to call
367      * `onlyOwner` functions anymore. Can only be called by the current owner.
368      *
369      * NOTE: Renouncing ownership will leave the contract without an owner,
370      * thereby removing any functionality that is only available to the owner.
371      */
372     function renounceOwnership() public virtual onlyOwner {
373         _setOwner(address(0));
374     }
375 
376     /**
377      * @dev Transfers ownership of the contract to a new account (`newOwner`).
378      * Can only be called by the current owner.
379      */
380     function transferOwnership(address newOwner) public virtual onlyOwner {
381         require(
382             newOwner != address(0),
383             "Ownable: new owner is the zero address"
384         );
385         _setOwner(newOwner);
386     }
387 
388     function _setOwner(address newOwner) private {
389         address oldOwner = _owner;
390         _owner = newOwner;
391         emit OwnershipTransferred(oldOwner, newOwner);
392     }
393 }
394 
395 /**
396  * @dev Contract module that helps prevent reentrant calls to a function.
397  *
398  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
399  * available, which can be applied to functions to make sure there are no nested
400  * (reentrant) calls to them.
401  *
402  * Note that because there is a single `nonReentrant` guard, functions marked as
403  * `nonReentrant` may not call one another. This can be worked around by making
404  * those functions `private`, and then adding `external` `nonReentrant` entry
405  * points to them.
406  *
407  * TIP: If you would like to learn more about reentrancy and alternative ways
408  * to protect against it, check out our blog post
409  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
410  */
411 abstract contract ReentrancyGuard {
412     // Booleans are more expensive than uint256 or any type that takes up a full
413     // word because each write operation emits an extra SLOAD to first read the
414     // slot's contents, replace the bits taken up by the boolean, and then write
415     // back. This is the compiler's defense against contract upgrades and
416     // pointer aliasing, and it cannot be disabled.
417 
418     // The values being non-zero value makes deployment a bit more expensive,
419     // but in exchange the refund on every call to nonReentrant will be lower in
420     // amount. Since refunds are capped to a percentage of the total
421     // transaction's gas, it is best to keep them low in cases like this one, to
422     // increase the likelihood of the full refund coming into effect.
423     uint256 private constant _NOT_ENTERED = 1;
424     uint256 private constant _ENTERED = 2;
425 
426     uint256 private _status;
427 
428     constructor() {
429         _status = _NOT_ENTERED;
430     }
431 
432     /**
433      * @dev Prevents a contract from calling itself, directly or indirectly.
434      * Calling a `nonReentrant` function from another `nonReentrant`
435      * function is not supported. It is possible to prevent this from happening
436      * by making the `nonReentrant` function external, and make it call a
437      * `private` function that does the actual work.
438      */
439     modifier nonReentrant() {
440         // On the first call to nonReentrant, _notEntered will be true
441         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
442 
443         // Any calls to nonReentrant after this point will fail
444         _status = _ENTERED;
445 
446         _;
447 
448         // By storing the original value once again, a refund is triggered (see
449         // https://eips.ethereum.org/EIPS/eip-2200)
450         _status = _NOT_ENTERED;
451     }
452 }
453 
454 /**
455  * @dev Interface of the ERC165 standard, as defined in the
456  * https://eips.ethereum.org/EIPS/eip-165[EIP].
457  *
458  * Implementers can declare support of contract interfaces, which can then be
459  * queried by others ({ERC165Checker}).
460  *
461  * For an implementation, see {ERC165}.
462  */
463 interface IERC165 {
464     /**
465      * @dev Returns true if this contract implements the interface defined by
466      * `interfaceId`. See the corresponding
467      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
468      * to learn more about how these ids are created.
469      *
470      * This function call must use less than 30 000 gas.
471      */
472     function supportsInterface(bytes4 interfaceId) external view returns (bool);
473 }
474 
475 /**
476  * @title ERC721 token receiver interface
477  * @dev Interface for any contract that wants to support safeTransfers
478  * from ERC721 asset contracts.
479  */
480 interface IERC721Receiver {
481     /**
482      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
483      * by `operator` from `from`, this function is called.
484      *
485      * It must return its Solidity selector to confirm the token transfer.
486      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
487      *
488      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
489      */
490     function onERC721Received(
491         address operator,
492         address from,
493         uint256 tokenId,
494         bytes calldata data
495     ) external returns (bytes4);
496 }
497 
498 /**
499  * @dev Required interface of an ERC721 compliant contract.
500  */
501 interface IERC721 is IERC165 {
502     /**
503      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
504      */
505     event Transfer(
506         address indexed from,
507         address indexed to,
508         uint256 indexed tokenId
509     );
510 
511     /**
512      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
513      */
514     event Approval(
515         address indexed owner,
516         address indexed approved,
517         uint256 indexed tokenId
518     );
519 
520     /**
521      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
522      */
523     event ApprovalForAll(
524         address indexed owner,
525         address indexed operator,
526         bool approved
527     );
528 
529     /**
530      * @dev Returns the number of tokens in ``owner``'s account.
531      */
532     function balanceOf(address owner) external view returns (uint256 balance);
533 
534     /**
535      * @dev Returns the owner of the `tokenId` token.
536      *
537      * Requirements:
538      *
539      * - `tokenId` must exist.
540      */
541     function ownerOf(uint256 tokenId) external view returns (address owner);
542 
543     /**
544      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
545      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
546      *
547      * Requirements:
548      *
549      * - `from` cannot be the zero address.
550      * - `to` cannot be the zero address.
551      * - `tokenId` token must exist and be owned by `from`.
552      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
553      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
554      *
555      * Emits a {Transfer} event.
556      */
557     function safeTransferFrom(
558         address from,
559         address to,
560         uint256 tokenId
561     ) external;
562 
563     /**
564      * @dev Transfers `tokenId` token from `from` to `to`.
565      *
566      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
567      *
568      * Requirements:
569      *
570      * - `from` cannot be the zero address.
571      * - `to` cannot be the zero address.
572      * - `tokenId` token must be owned by `from`.
573      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
574      *
575      * Emits a {Transfer} event.
576      */
577     function transferFrom(
578         address from,
579         address to,
580         uint256 tokenId
581     ) external;
582 
583     /**
584      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
585      * The approval is cleared when the token is transferred.
586      *
587      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
588      *
589      * Requirements:
590      *
591      * - The caller must own the token or be an approved operator.
592      * - `tokenId` must exist.
593      *
594      * Emits an {Approval} event.
595      */
596     function approve(address to, uint256 tokenId) external;
597 
598     /**
599      * @dev Returns the account approved for `tokenId` token.
600      *
601      * Requirements:
602      *
603      * - `tokenId` must exist.
604      */
605     function getApproved(uint256 tokenId)
606         external
607         view
608         returns (address operator);
609 
610     /**
611      * @dev Approve or remove `operator` as an operator for the caller.
612      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
613      *
614      * Requirements:
615      *
616      * - The `operator` cannot be the caller.
617      *
618      * Emits an {ApprovalForAll} event.
619      */
620     function setApprovalForAll(address operator, bool _approved) external;
621 
622     /**
623      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
624      *
625      * See {setApprovalForAll}
626      */
627     function isApprovedForAll(address owner, address operator)
628         external
629         view
630         returns (bool);
631 
632     /**
633      * @dev Safely transfers `tokenId` token from `from` to `to`.
634      *
635      * Requirements:
636      *
637      * - `from` cannot be the zero address.
638      * - `to` cannot be the zero address.
639      * - `tokenId` token must exist and be owned by `from`.
640      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
641      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
642      *
643      * Emits a {Transfer} event.
644      */
645     function safeTransferFrom(
646         address from,
647         address to,
648         uint256 tokenId,
649         bytes calldata data
650     ) external;
651 }
652 
653 /**
654  * @dev Implementation of the {IERC165} interface.
655  *
656  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
657  * for the additional interface id that will be supported. For example:
658  *
659  * ```solidity
660  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
661  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
662  * }
663  * ```
664  *
665  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
666  */
667 abstract contract ERC165 is IERC165 {
668     /**
669      * @dev See {IERC165-supportsInterface}.
670      */
671     function supportsInterface(bytes4 interfaceId)
672         public
673         view
674         virtual
675         override
676         returns (bool)
677     {
678         return interfaceId == type(IERC165).interfaceId;
679     }
680 }
681 
682 /**
683  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
684  * @dev See https://eips.ethereum.org/EIPS/eip-721
685  */
686 interface IERC721Metadata is IERC721 {
687     /**
688      * @dev Returns the token collection name.
689      */
690     function name() external view returns (string memory);
691 
692     /**
693      * @dev Returns the token collection symbol.
694      */
695     function symbol() external view returns (string memory);
696 
697     /**
698      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
699      */
700     function tokenURI(uint256 tokenId) external view returns (string memory);
701 }
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
766             "ERC721: balance query for the zero address"
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
784             "ERC721: owner query for nonexistent token"
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
815             "ERC721Metadata: URI query for nonexistent token"
816         );
817 
818         string memory baseURI = _baseURI();
819         return
820             bytes(baseURI).length > 0
821                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
822                 : "";
823     }
824 
825     /**
826      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
827      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
828      * by default, can be overriden in child contracts.
829      */
830     function _baseURI() internal view virtual returns (string memory) {
831         return "";
832     }
833 
834     /**
835      * @dev See {IERC721-approve}.
836      */
837     function approve(address to, uint256 tokenId) public virtual override {
838         address owner = ERC721.ownerOf(tokenId);
839         require(to != owner, "ERC721: approval to current owner");
840 
841         require(
842             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
843             "ERC721: approve caller is not owner nor approved for all"
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
861             "ERC721: approved query for nonexistent token"
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
875         require(operator != _msgSender(), "ERC721: approve to caller");
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
905             "ERC721: transfer caller is not owner nor approved"
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
919         safeTransferFrom(from, to, tokenId, "");
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
933             "ERC721: transfer caller is not owner nor approved"
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
965             "ERC721: transfer to non ERC721Receiver implementer"
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
996             "ERC721: operator query for nonexistent token"
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
1015         _safeMint(to, tokenId, "");
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
1030             "ERC721: transfer to non ERC721Receiver implementer"
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
1047         require(to != address(0), "ERC721: mint to the zero address");
1048         require(!_exists(tokenId), "All are OfferCreated out");
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
1100             "ERC721: transfer of token that is not own"
1101         );
1102         require(to != address(0), "ERC721: transfer to the zero address");
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
1151                 return retval == IERC721Receiver(to).onERC721Received.selector;
1152             } catch (bytes memory reason) {
1153                 if (reason.length == 0) {
1154                     revert(
1155                         "ERC721: transfer to non ERC721Receiver implementer"
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
1189 /**
1190  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1191  * @dev See https://eips.ethereum.org/EIPS/eip-721
1192  */
1193 interface IERC721Enumerable is IERC721 {
1194     /**
1195      * @dev Returns the total amount of tokens stored by the contract.
1196      */
1197     function totalSupply() external view returns (uint256);
1198 
1199     /**
1200      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1201      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1202      */
1203     function tokenOfOwnerByIndex(address owner, uint256 index)
1204         external
1205         view
1206         returns (uint256 tokenId);
1207 
1208     /**
1209      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1210      * Use along with {totalSupply} to enumerate all tokens.
1211      */
1212     function tokenByIndex(uint256 index) external view returns (uint256);
1213 }
1214 
1215 /**
1216  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1217  * enumerability of all the token ids in the contract as well as all token ids owned by each
1218  * account.
1219  */
1220 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1221     // Mapping from owner to list of owned token IDs
1222     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1223 
1224     // Mapping from token ID to index of the owner tokens list
1225     mapping(uint256 => uint256) private _ownedTokensIndex;
1226 
1227     // Array with all token ids, used for enumeration
1228     uint256[] private _allTokens;
1229 
1230     // Mapping from token id to position in the allTokens array
1231     mapping(uint256 => uint256) private _allTokensIndex;
1232 
1233     /**
1234      * @dev See {IERC165-supportsInterface}.
1235      */
1236     function supportsInterface(bytes4 interfaceId)
1237         public
1238         view
1239         virtual
1240         override(IERC165, ERC721)
1241         returns (bool)
1242     {
1243         return
1244             interfaceId == type(IERC721Enumerable).interfaceId ||
1245             super.supportsInterface(interfaceId);
1246     }
1247 
1248     /**
1249      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1250      */
1251     function tokenOfOwnerByIndex(address owner, uint256 index)
1252         public
1253         view
1254         virtual
1255         override
1256         returns (uint256)
1257     {
1258         require(
1259             index < ERC721.balanceOf(owner),
1260             "ERC721Enumerable: owner index out of bounds"
1261         );
1262         return _ownedTokens[owner][index];
1263     }
1264 
1265     /**
1266      * @dev See {IERC721Enumerable-totalSupply}.
1267      */
1268     function totalSupply() public view virtual override returns (uint256) {
1269         return _allTokens.length;
1270     }
1271 
1272     /**
1273      * @dev See {IERC721Enumerable-tokenByIndex}.
1274      */
1275     function tokenByIndex(uint256 index)
1276         public
1277         view
1278         virtual
1279         override
1280         returns (uint256)
1281     {
1282         require(
1283             index < ERC721Enumerable.totalSupply(),
1284             "ERC721Enumerable: global index out of bounds"
1285         );
1286         return _allTokens[index];
1287     }
1288 
1289     /**
1290      * @dev Hook that is called before any token transfer. This includes minting
1291      * and burning.
1292      *
1293      * Calling conditions:
1294      *
1295      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1296      * transferred to `to`.
1297      * - When `from` is zero, `tokenId` will be minted for `to`.
1298      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1299      * - `from` cannot be the zero address.
1300      * - `to` cannot be the zero address.
1301      *
1302      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1303      */
1304     function _beforeTokenTransfer(
1305         address from,
1306         address to,
1307         uint256 tokenId
1308     ) internal virtual override {
1309         super._beforeTokenTransfer(from, to, tokenId);
1310 
1311         if (from == address(0)) {
1312             _addTokenToAllTokensEnumeration(tokenId);
1313         } else if (from != to) {
1314             _removeTokenFromOwnerEnumeration(from, tokenId);
1315         }
1316         if (to == address(0)) {
1317             _removeTokenFromAllTokensEnumeration(tokenId);
1318         } else if (to != from) {
1319             _addTokenToOwnerEnumeration(to, tokenId);
1320         }
1321     }
1322 
1323     /**
1324      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1325      * @param to address representing the new owner of the given token ID
1326      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1327      */
1328     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1329         uint256 length = ERC721.balanceOf(to);
1330         _ownedTokens[to][length] = tokenId;
1331         _ownedTokensIndex[tokenId] = length;
1332     }
1333 
1334     /**
1335      * @dev Private function to add a token to this extension's token tracking data structures.
1336      * @param tokenId uint256 ID of the token to be added to the tokens list
1337      */
1338     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1339         _allTokensIndex[tokenId] = _allTokens.length;
1340         _allTokens.push(tokenId);
1341     }
1342 
1343     /**
1344      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1345      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1346      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1347      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1348      * @param from address representing the previous owner of the given token ID
1349      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1350      */
1351     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1352         private
1353     {
1354         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1355         // then delete the last slot (swap and pop).
1356 
1357         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1358         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1359 
1360         // When the token to delete is the last token, the swap operation is unnecessary
1361         if (tokenIndex != lastTokenIndex) {
1362             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1363 
1364             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1365             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1366         }
1367 
1368         // This also deletes the contents at the last position of the array
1369         delete _ownedTokensIndex[tokenId];
1370         delete _ownedTokens[from][lastTokenIndex];
1371     }
1372 
1373     /**
1374      * @dev Private function to remove a token from this extension's token tracking data structures.
1375      * This has O(1) time complexity, but alters the order of the _allTokens array.
1376      * @param tokenId uint256 ID of the token to be removed from the tokens list
1377      */
1378     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1379         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1380         // then delete the last slot (swap and pop).
1381 
1382         uint256 lastTokenIndex = _allTokens.length - 1;
1383         uint256 tokenIndex = _allTokensIndex[tokenId];
1384 
1385         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1386         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1387         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1388         uint256 lastTokenId = _allTokens[lastTokenIndex];
1389 
1390         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1391         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1392 
1393         // This also deletes the contents at the last position of the array
1394         delete _allTokensIndex[tokenId];
1395         _allTokens.pop();
1396     }
1397 }
1398 
1399 /**
1400  * @dev ERC721 token with storage based token URI management.
1401  */
1402 abstract contract ERC721URIStorage is ERC721 {
1403     using Strings for uint256;
1404 
1405     // Optional mapping for token URIs
1406     mapping(uint256 => string) private _tokenURIs;
1407 
1408     /**
1409      * @dev See {IERC721Metadata-tokenURI}.
1410      */
1411     function tokenURI(uint256 tokenId)
1412         public
1413         view
1414         virtual
1415         override
1416         returns (string memory)
1417     {
1418         require(
1419             _exists(tokenId),
1420             "ERC721URIStorage: URI query for nonexistent token"
1421         );
1422 
1423         string memory _tokenURI = _tokenURIs[tokenId];
1424         string memory base = _baseURI();
1425 
1426         // If there is no base URI, return the token URI.
1427         if (bytes(base).length == 0) {
1428             return _tokenURI;
1429         }
1430         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1431         if (bytes(_tokenURI).length > 0) {
1432             return string(abi.encodePacked(base, _tokenURI));
1433         }
1434 
1435         return super.tokenURI(tokenId);
1436     }
1437 
1438     /**
1439      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1440      *
1441      * Requirements:
1442      *
1443      * - `tokenId` must exist.
1444      */
1445     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
1446         internal
1447         virtual
1448     {
1449         require(
1450             _exists(tokenId),
1451             "ERC721URIStorage: URI set of nonexistent token"
1452         );
1453         _tokenURIs[tokenId] = _tokenURI;
1454     }
1455 
1456     /**
1457      * @dev Destroys `tokenId`.
1458      * The approval is cleared when the token is burned.
1459      *
1460      * Requirements:
1461      *
1462      * - `tokenId` must exist.
1463      *
1464      * Emits a {Transfer} event.
1465      */
1466     function _burn(uint256 tokenId) internal virtual override {
1467         super._burn(tokenId);
1468 
1469         if (bytes(_tokenURIs[tokenId]).length != 0) {
1470             delete _tokenURIs[tokenId];
1471         }
1472     }
1473 }
1474 
1475 // CAUTION
1476 // This version of SafeMath should only be used with Solidity 0.8 or later,
1477 // because it relies on the compiler's built in overflow checks.
1478 
1479 /**
1480  * @dev Wrappers over Solidity's arithmetic operations.
1481  *
1482  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1483  * now has built in overflow checking.
1484  */
1485 library SafeMath {
1486     /**
1487      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1488      *
1489      * _Available since v3.4._
1490      */
1491     function tryAdd(uint256 a, uint256 b)
1492         internal
1493         pure
1494         returns (bool, uint256)
1495     {
1496         unchecked {
1497             uint256 c = a + b;
1498             if (c < a) return (false, 0);
1499             return (true, c);
1500         }
1501     }
1502 
1503     /**
1504      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1505      *
1506      * _Available since v3.4._
1507      */
1508     function trySub(uint256 a, uint256 b)
1509         internal
1510         pure
1511         returns (bool, uint256)
1512     {
1513         unchecked {
1514             if (b > a) return (false, 0);
1515             return (true, a - b);
1516         }
1517     }
1518 
1519     /**
1520      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1521      *
1522      * _Available since v3.4._
1523      */
1524     function tryMul(uint256 a, uint256 b)
1525         internal
1526         pure
1527         returns (bool, uint256)
1528     {
1529         unchecked {
1530             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1531             // benefit is lost if 'b' is also tested.
1532             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1533             if (a == 0) return (true, 0);
1534             uint256 c = a * b;
1535             if (c / a != b) return (false, 0);
1536             return (true, c);
1537         }
1538     }
1539 
1540     /**
1541      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1542      *
1543      * _Available since v3.4._
1544      */
1545     function tryDiv(uint256 a, uint256 b)
1546         internal
1547         pure
1548         returns (bool, uint256)
1549     {
1550         unchecked {
1551             if (b == 0) return (false, 0);
1552             return (true, a / b);
1553         }
1554     }
1555 
1556     /**
1557      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1558      *
1559      * _Available since v3.4._
1560      */
1561     function tryMod(uint256 a, uint256 b)
1562         internal
1563         pure
1564         returns (bool, uint256)
1565     {
1566         unchecked {
1567             if (b == 0) return (false, 0);
1568             return (true, a % b);
1569         }
1570     }
1571 
1572     /**
1573      * @dev Returns the addition of two unsigned integers, reverting on
1574      * overflow.
1575      *
1576      * Counterpart to Solidity's `+` operator.
1577      *
1578      * Requirements:
1579      *
1580      * - Addition cannot overflow.
1581      */
1582     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1583         return a + b;
1584     }
1585 
1586     /**
1587      * @dev Returns the subtraction of two unsigned integers, reverting on
1588      * overflow (when the result is negative).
1589      *
1590      * Counterpart to Solidity's `-` operator.
1591      *
1592      * Requirements:
1593      *
1594      * - Subtraction cannot overflow.
1595      */
1596     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1597         return a - b;
1598     }
1599 
1600     /**
1601      * @dev Returns the multiplication of two unsigned integers, reverting on
1602      * overflow.
1603      *
1604      * Counterpart to Solidity's `*` operator.
1605      *
1606      * Requirements:
1607      *
1608      * - Multiplication cannot overflow.
1609      */
1610     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1611         return a * b;
1612     }
1613 
1614     /**
1615      * @dev Returns the integer division of two unsigned integers, reverting on
1616      * division by zero. The result is rounded towards zero.
1617      *
1618      * Counterpart to Solidity's `/` operator.
1619      *
1620      * Requirements:
1621      *
1622      * - The divisor cannot be zero.
1623      */
1624     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1625         return a / b;
1626     }
1627 
1628     /**
1629      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1630      * reverting when dividing by zero.
1631      *
1632      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1633      * opcode (which leaves remaining gas untouched) while Solidity uses an
1634      * invalid opcode to revert (consuming all remaining gas).
1635      *
1636      * Requirements:
1637      *
1638      * - The divisor cannot be zero.
1639      */
1640     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1641         return a % b;
1642     }
1643 
1644     /**
1645      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1646      * overflow (when the result is negative).
1647      *
1648      * CAUTION: This function is deprecated because it requires allocating memory for the error
1649      * message unnecessarily. For custom revert reasons use {trySub}.
1650      *
1651      * Counterpart to Solidity's `-` operator.
1652      *
1653      * Requirements:
1654      *
1655      * - Subtraction cannot overflow.
1656      */
1657     function sub(
1658         uint256 a,
1659         uint256 b,
1660         string memory errorMessage
1661     ) internal pure returns (uint256) {
1662         unchecked {
1663             require(b <= a, errorMessage);
1664             return a - b;
1665         }
1666     }
1667 
1668     /**
1669      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1670      * division by zero. The result is rounded towards zero.
1671      *
1672      * Counterpart to Solidity's `/` operator. Note: this function uses a
1673      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1674      * uses an invalid opcode to revert (consuming all remaining gas).
1675      *
1676      * Requirements:
1677      *
1678      * - The divisor cannot be zero.
1679      */
1680     function div(
1681         uint256 a,
1682         uint256 b,
1683         string memory errorMessage
1684     ) internal pure returns (uint256) {
1685         unchecked {
1686             require(b > 0, errorMessage);
1687             return a / b;
1688         }
1689     }
1690 
1691     /**
1692      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1693      * reverting with custom message when dividing by zero.
1694      *
1695      * CAUTION: This function is deprecated because it requires allocating memory for the error
1696      * message unnecessarily. For custom revert reasons use {tryMod}.
1697      *
1698      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1699      * opcode (which leaves remaining gas untouched) while Solidity uses an
1700      * invalid opcode to revert (consuming all remaining gas).
1701      *
1702      * Requirements:
1703      *
1704      * - The divisor cannot be zero.
1705      */
1706     function mod(
1707         uint256 a,
1708         uint256 b,
1709         string memory errorMessage
1710     ) internal pure returns (uint256) {
1711         unchecked {
1712             require(b > 0, errorMessage);
1713             return a % b;
1714         }
1715     }
1716 }
1717 
1718 contract NFT is Ownable, ERC721 {
1719     using Strings for string;
1720 
1721     uint public constant OG_SALE_MAX_TOKENS = 150;
1722 
1723     string private _baseTokenURI;
1724 
1725     uint public supply = 0;
1726 
1727     constructor() ERC721("Ancient Shrooms", "ANCIENTSHROOM") {}
1728 
1729     function mintToken(uint256 amount) external payable
1730     {
1731         require(supply + amount <= OG_SALE_MAX_TOKENS, "Purchase would exceed max supply");
1732 
1733         for (uint i = 0; i < amount; i++)
1734         {
1735             _safeMint(msg.sender, supply);
1736             supply++;
1737         }
1738     }
1739 
1740     function withdraw() external
1741     {
1742         require(msg.sender == owner(), "Invalid sender");
1743 
1744         payable(owner()).transfer(address(this).balance);
1745     }
1746 
1747     ////
1748     //URI management part
1749     ////
1750 
1751     function _setBaseURI(string memory baseURI) internal virtual {
1752         _baseTokenURI = baseURI;
1753     }
1754 
1755     function _baseURI() internal view override returns (string memory) {
1756         return _baseTokenURI;
1757     }
1758 
1759     function setBaseURI(string memory baseURI) external onlyOwner {
1760         _setBaseURI(baseURI);
1761     }
1762 
1763     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1764         string memory _tokenURI = super.tokenURI(tokenId);
1765         return bytes(_tokenURI).length > 0 ? string(abi.encodePacked(_tokenURI)) : "";
1766     }
1767 }