1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 /**
27  * @dev Required interface of an ERC721 compliant contract.
28  */
29 interface IERC721 is IERC165 {
30     /**
31      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
32      */
33     event Transfer(
34         address indexed from,
35         address indexed to,
36         uint256 indexed tokenId
37     );
38 
39     /**
40      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
41      */
42     event Approval(
43         address indexed owner,
44         address indexed approved,
45         uint256 indexed tokenId
46     );
47 
48     /**
49      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
50      */
51     event ApprovalForAll(
52         address indexed owner,
53         address indexed operator,
54         bool approved
55     );
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
73      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId
89     ) external;
90 
91     /**
92      * @dev Transfers `tokenId` token from `from` to `to`.
93      *
94      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must be owned by `from`.
101      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
113      * The approval is cleared when the token is transferred.
114      *
115      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
116      *
117      * Requirements:
118      *
119      * - The caller must own the token or be an approved operator.
120      * - `tokenId` must exist.
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Returns the account approved for `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function getApproved(uint256 tokenId)
134         external
135         view
136         returns (address operator);
137 
138     /**
139      * @dev Approve or remove `operator` as an operator for the caller.
140      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
141      *
142      * Requirements:
143      *
144      * - The `operator` cannot be the caller.
145      *
146      * Emits an {ApprovalForAll} event.
147      */
148     function setApprovalForAll(address operator, bool _approved) external;
149 
150     /**
151      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
152      *
153      * See {setApprovalForAll}
154      */
155     function isApprovedForAll(address owner, address operator)
156         external
157         view
158         returns (bool);
159 
160     /**
161      * @dev Safely transfers `tokenId` token from `from` to `to`.
162      *
163      * Requirements:
164      *
165      * - `from` cannot be the zero address.
166      * - `to` cannot be the zero address.
167      * - `tokenId` token must exist and be owned by `from`.
168      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
169      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
170      *
171      * Emits a {Transfer} event.
172      */
173     function safeTransferFrom(
174         address from,
175         address to,
176         uint256 tokenId,
177         bytes calldata data
178     ) external;
179 }
180 
181 /**
182  * @dev String operations.
183  */
184 library Stattitude {
185     bytes16 private constant _HEX_SYMBOLS = '0123456789abcdef';
186 
187     /**
188      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
189      */
190     function toString(uint256 value) internal pure returns (string memory) {
191         // Inspired by OraclizeAPI's implementation - MIT licence
192         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
193 
194         if (value == 0) {
195             return '0';
196         }
197         uint256 temp = value;
198         uint256 digits;
199         while (temp != 0) {
200             digits++;
201             temp /= 10;
202         }
203         bytes memory buffer = new bytes(digits);
204         while (value != 0) {
205             digits -= 1;
206             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
207             value /= 10;
208         }
209         return string(buffer);
210     }
211 
212     /**
213      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
214      */
215     function toHexString(uint256 value) internal pure returns (string memory) {
216         if (value == 0) {
217             return '0x00';
218         }
219         uint256 temp = value;
220         uint256 length = 0;
221         while (temp != 0) {
222             length++;
223             temp >>= 8;
224         }
225         return toHexString(value, length);
226     }
227 
228     /**
229      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
230      */
231     function toHexString(uint256 value, uint256 length)
232         internal
233         pure
234         returns (string memory)
235     {
236         bytes memory buffer = new bytes(2 * length + 2);
237         buffer[0] = '0';
238         buffer[1] = 'x';
239         for (uint256 i = 2 * length + 1; i > 1; --i) {
240             buffer[i] = _HEX_SYMBOLS[value & 0xf];
241             value >>= 4;
242         }
243         require(value == 0, 'Stattitude: hex length insufficient');
244         return string(buffer);
245     }
246 }
247 
248 /*
249  * @dev Provides information about the current execution context, including the
250  * sender of the transaction and its data. While these are generally available
251  * via msg.sender and msg.data, they should not be accessed in such a direct
252  * manner, since when dealing with meta-transactions the account sending and
253  * paying for execution may not be the actual sender (as far as an application
254  * is concerned).
255  *
256  * This contract is only required for intermediate, library-like contracts.
257  */
258 abstract contract Context {
259     function _msgSender() internal view virtual returns (address) {
260         return msg.sender;
261     }
262 
263     function _msgData() internal view virtual returns (bytes calldata) {
264         return msg.data;
265     }
266 }
267 
268 /**
269  * @dev Contract module which provides a basic access control mechanism, where
270  * there is an account (an owner) that can be granted exclusive access to
271  * specific functions.
272  *
273  * By default, the owner account will be the one that deploys the contract. This
274  * can later be changed with {transferOwnership}.
275  *
276  * This module is used through inheritance. It will make available the modifier
277  * `onlyOwner`, which can be applied to your functions to restrict their use to
278  * the owner.
279  */
280 abstract contract Ownable is Context {
281     address private _owner;
282 
283     event OwnershipTransferred(
284         address indexed previousOwner,
285         address indexed newOwner
286     );
287 
288     /**
289      * @dev Initializes the contract setting the deployer as the initial owner.
290      */
291     constructor() {
292         _setOwner(_msgSender());
293     }
294 
295     /**
296      * @dev Returns the address of the current owner.
297      */
298     function owner() public view virtual returns (address) {
299         return _owner;
300     }
301 
302     /**
303      * @dev Throws if called by any account other than the owner.
304      */
305     modifier onlyOwner() {
306         require(owner() == _msgSender(), 'Ownable: caller is not the owner');
307         _;
308     }
309 
310     /**
311      * @dev Leaves the contract without owner. It will not be possible to call
312      * `onlyOwner` functions anymore. Can only be called by the current owner.
313      *
314      * NOTE: Renouncing ownership will leave the contract without an owner,
315      * thereby removing any functionality that is only available to the owner.
316      */
317     function renounceOwnership() public virtual onlyOwner {
318         _setOwner(address(0));
319     }
320 
321     /**
322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
323      * Can only be called by the current owner.
324      */
325     function transferOwnership(address newOwner) public virtual onlyOwner {
326         require(
327             newOwner != address(0),
328             'Ownable: new owner is the zero address'
329         );
330         _setOwner(newOwner);
331     }
332 
333     function _setOwner(address newOwner) private {
334         address oldOwner = _owner;
335         _owner = newOwner;
336         emit OwnershipTransferred(oldOwner, newOwner);
337     }
338 }
339 
340 /**
341  * @dev Contract module that helps prevent reentrant calls to a function.
342  *
343  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
344  * available, which can be applied to functions to make sure there are no nested
345  * (reentrant) calls to them.
346  *
347  * Note that because there is a single `nonReentrant` guard, functions marked as
348  * `nonReentrant` may not call one another. This can be worked around by making
349  * those functions `private`, and then adding `external` `nonReentrant` entry
350  * points to them.
351  *
352  * TIP: If you would like to learn more about reentrancy and alternative ways
353  * to protect against it, check out our blog post
354  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
355  */
356 abstract contract ReentrancyGuard {
357     // Booleans are more expensive than uint256 or any type that takes up a full
358     // word because each write operation emits an extra SLOAD to first read the
359     // slot's contents, replace the bits taken up by the boolean, and then write
360     // back. This is the compiler's defense against contract upgrades and
361     // pointer aliasing, and it cannot be disabled.
362 
363     // The values being non-zero value makes deployment a bit more expensive,
364     // but in exchange the refund on every call to nonReentrant will be lower in
365     // amount. Since refunds are capped to a percentage of the total
366     // transaction's gas, it is best to keep them low in cases like this one, to
367     // increase the likelihood of the full refund coming into effect.
368     uint256 private constant _NOT_ENTERED = 1;
369     uint256 private constant _ENTERED = 2;
370 
371     uint256 private _status;
372 
373     constructor() {
374         _status = _NOT_ENTERED;
375     }
376 
377     /**
378      * @dev Prevents a contract from calling itself, directly or indirectly.
379      * Calling a `nonReentrant` function from another `nonReentrant`
380      * function is not supported. It is possible to prevent this from happening
381      * by making the `nonReentrant` function external, and make it call a
382      * `private` function that does the actual work.
383      */
384     modifier nonReentrant() {
385         // On the first call to nonReentrant, _notEntered will be true
386         require(_status != _ENTERED, 'ReentrancyGuard: reentrant call');
387 
388         // Any calls to nonReentrant after this point will fail
389         _status = _ENTERED;
390 
391         _;
392 
393         // By storing the original value once again, a refund is triggered (see
394         // https://eips.ethereum.org/EIPS/eip-2200)
395         _status = _NOT_ENTERED;
396     }
397 }
398 
399 /**
400  * @title ERC721 token receiver interface
401  * @dev Interface for any contract that wants to support safeTransfers
402  * from ERC721 asset contracts.
403  */
404 interface IERC721Receiver {
405     /**
406      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
407      * by `operator` from `from`, this function is called.
408      *
409      * It must return its Solidity selector to confirm the token transfer.
410      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
411      *
412      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
413      */
414     function onERC721Received(
415         address operator,
416         address from,
417         uint256 tokenId,
418         bytes calldata data
419     ) external returns (bytes4);
420 }
421 
422 /**
423  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
424  * @dev See https://eips.ethereum.org/EIPS/eip-721
425  */
426 interface IERC721Metadata is IERC721 {
427     /**
428      * @dev Returns the token collection name.
429      */
430     function name() external view returns (string memory);
431 
432     /**
433      * @dev Returns the token collection symbol.
434      */
435     function symbol() external view returns (string memory);
436 
437     /**
438      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
439      */
440     function tokenURI(uint256 tokenId) external view returns (string memory);
441 }
442 
443 /**
444  * @dev Collection of functions related to the address type
445  */
446 library Address {
447     /**
448      * @dev Returns true if `account` is a contract.
449      *
450      * [IMPORTANT]
451      * ====
452      * It is unsafe to assume that an address for which this function returns
453      * false is an externally-owned account (EOA) and not a contract.
454      *
455      * Among others, `isContract` will return false for the following
456      * types of addresses:
457      *
458      *  - an externally-owned account
459      *  - a contract in construction
460      *  - an address where a contract will be created
461      *  - an address where a contract lived, but was destroyed
462      * ====
463      */
464     function isContract(address account) internal view returns (bool) {
465         // This method relies on extcodesize, which returns 0 for contracts in
466         // construction, since the code is only stored at the end of the
467         // constructor execution.
468 
469         uint256 size;
470         assembly {
471             size := extcodesize(account)
472         }
473         return size > 0;
474     }
475 
476     /**
477      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
478      * `recipient`, forwarding all available gas and reverting on errors.
479      *
480      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
481      * of certain opcodes, possibly making contracts go over the 2300 gas limit
482      * imposed by `transfer`, making them unable to receive funds via
483      * `transfer`. {sendValue} removes this limitation.
484      *
485      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
486      *
487      * IMPORTANT: because control is transferred to `recipient`, care must be
488      * taken to not create reentrancy vulnerabilities. Consider using
489      * {ReentrancyGuard} or the
490      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
491      */
492     function sendValue(address payable recipient, uint256 amount) internal {
493         require(
494             address(this).balance >= amount,
495             'Address: insufficient balance'
496         );
497 
498         (bool success, ) = recipient.call{value: amount}('');
499         require(
500             success,
501             'Address: unable to send value, recipient may have reverted'
502         );
503     }
504 
505     /**
506      * @dev Performs a Solidity function call using a low level `call`. A
507      * plain `call` is an unsafe replacement for a function call: use this
508      * function instead.
509      *
510      * If `target` reverts with a revert reason, it is bubbled up by this
511      * function (like regular Solidity function calls).
512      *
513      * Returns the raw returned data. To convert to the expected return value,
514      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
515      *
516      * Requirements:
517      *
518      * - `target` must be a contract.
519      * - calling `target` with `data` must not revert.
520      *
521      * _Available since v3.1._
522      */
523     function functionCall(address target, bytes memory data)
524         internal
525         returns (bytes memory)
526     {
527         return functionCall(target, data, 'Address: low-level call failed');
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
532      * `errorMessage` as a fallback revert reason when `target` reverts.
533      *
534      * _Available since v3.1._
535      */
536     function functionCall(
537         address target,
538         bytes memory data,
539         string memory errorMessage
540     ) internal returns (bytes memory) {
541         return functionCallWithValue(target, data, 0, errorMessage);
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
546      * but also transferring `value` wei to `target`.
547      *
548      * Requirements:
549      *
550      * - the calling contract must have an ETH balance of at least `value`.
551      * - the called Solidity function must be `payable`.
552      *
553      * _Available since v3.1._
554      */
555     function functionCallWithValue(
556         address target,
557         bytes memory data,
558         uint256 value
559     ) internal returns (bytes memory) {
560         return
561             functionCallWithValue(
562                 target,
563                 data,
564                 value,
565                 'Address: low-level call with value failed'
566             );
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
571      * with `errorMessage` as a fallback revert reason when `target` reverts.
572      *
573      * _Available since v3.1._
574      */
575     function functionCallWithValue(
576         address target,
577         bytes memory data,
578         uint256 value,
579         string memory errorMessage
580     ) internal returns (bytes memory) {
581         require(
582             address(this).balance >= value,
583             'Address: insufficient balance for call'
584         );
585         require(isContract(target), 'Address: call to non-contract');
586 
587         (bool success, bytes memory returndata) = target.call{value: value}(
588             data
589         );
590         return _verifyCallResult(success, returndata, errorMessage);
591     }
592 
593     /**
594      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
595      * but performing a static call.
596      *
597      * _Available since v3.3._
598      */
599     function functionStaticCall(address target, bytes memory data)
600         internal
601         view
602         returns (bytes memory)
603     {
604         return
605             functionStaticCall(
606                 target,
607                 data,
608                 'Address: low-level static call failed'
609             );
610     }
611 
612     /**
613      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
614      * but performing a static call.
615      *
616      * _Available since v3.3._
617      */
618     function functionStaticCall(
619         address target,
620         bytes memory data,
621         string memory errorMessage
622     ) internal view returns (bytes memory) {
623         require(isContract(target), 'Address: static call to non-contract');
624 
625         (bool success, bytes memory returndata) = target.staticcall(data);
626         return _verifyCallResult(success, returndata, errorMessage);
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
631      * but performing a delegate call.
632      *
633      * _Available since v3.4._
634      */
635     function functionDelegateCall(address target, bytes memory data)
636         internal
637         returns (bytes memory)
638     {
639         return
640             functionDelegateCall(
641                 target,
642                 data,
643                 'Address: low-level delegate call failed'
644             );
645     }
646 
647     /**
648      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
649      * but performing a delegate call.
650      *
651      * _Available since v3.4._
652      */
653     function functionDelegateCall(
654         address target,
655         bytes memory data,
656         string memory errorMessage
657     ) internal returns (bytes memory) {
658         require(isContract(target), 'Address: delegate call to non-contract');
659 
660         (bool success, bytes memory returndata) = target.delegatecall(data);
661         return _verifyCallResult(success, returndata, errorMessage);
662     }
663 
664     function _verifyCallResult(
665         bool success,
666         bytes memory returndata,
667         string memory errorMessage
668     ) private pure returns (bytes memory) {
669         if (success) {
670             return returndata;
671         } else {
672             // Look for revert reason and bubble it up if present
673             if (returndata.length > 0) {
674                 // The easiest way to bubble the revert reason is using memory via assembly
675 
676                 assembly {
677                     let returndata_size := mload(returndata)
678                     revert(add(32, returndata), returndata_size)
679                 }
680             } else {
681                 revert(errorMessage);
682             }
683         }
684     }
685 }
686 
687 /**
688  * @dev Implementation of the {IERC165} interface.
689  *
690  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
691  * for the additional interface id that will be supported. For example:
692  *
693  * ```solidity
694  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
695  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
696  * }
697  * ```
698  *
699  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
700  */
701 abstract contract ERC165 is IERC165 {
702     /**
703      * @dev See {IERC165-supportsInterface}.
704      */
705     function supportsInterface(bytes4 interfaceId)
706         public
707         view
708         virtual
709         override
710         returns (bool)
711     {
712         return interfaceId == type(IERC165).interfaceId;
713     }
714 }
715 
716 /**
717  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
718  * the Metadata extension, but not including the Enumerable extension, which is available separately as
719  * {ERC721Enumerable}.
720  */
721 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
722     using Address for address;
723     using Stattitude for uint256;
724 
725     // Token name
726     string private _name;
727 
728     // Token symbol
729     string private _symbol;
730 
731     // Mapping from token ID to owner address
732     mapping(uint256 => address) private _owners;
733 
734     // Mapping owner address to token count
735     mapping(address => uint256) private _balances;
736 
737     // Mapping from token ID to approved address
738     mapping(uint256 => address) private _tokenApprovals;
739 
740     // Mapping from owner to operator approvals
741     mapping(address => mapping(address => bool)) private _operatorApprovals;
742 
743     /**
744      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
745      */
746     constructor(string memory name_, string memory symbol_) {
747         _name = name_;
748         _symbol = symbol_;
749     }
750 
751     /**
752      * @dev See {IERC165-supportsInterface}.
753      */
754     function supportsInterface(bytes4 interfaceId)
755         public
756         view
757         virtual
758         override(ERC165, IERC165)
759         returns (bool)
760     {
761         return
762             interfaceId == type(IERC721).interfaceId ||
763             interfaceId == type(IERC721Metadata).interfaceId ||
764             super.supportsInterface(interfaceId);
765     }
766 
767     /**
768      * @dev See {IERC721-balanceOf}.
769      */
770     function balanceOf(address owner)
771         public
772         view
773         virtual
774         override
775         returns (uint256)
776     {
777         require(
778             owner != address(0),
779             'ERC721: balance query for the zero address'
780         );
781         return _balances[owner];
782     }
783 
784     /**
785      * @dev See {IERC721-ownerOf}.
786      */
787     function ownerOf(uint256 tokenId)
788         public
789         view
790         virtual
791         override
792         returns (address)
793     {
794         address owner = _owners[tokenId];
795         require(
796             owner != address(0),
797             'ERC721: owner query for nonexistent token'
798         );
799         return owner;
800     }
801 
802     /**
803      * @dev See {IERC721Metadata-name}.
804      */
805     function name() public view virtual override returns (string memory) {
806         return _name;
807     }
808 
809     /**
810      * @dev See {IERC721Metadata-symbol}.
811      */
812     function symbol() public view virtual override returns (string memory) {
813         return _symbol;
814     }
815 
816     /**
817      * @dev See {IERC721Metadata-tokenURI}.
818      */
819     function tokenURI(uint256 tokenId)
820         public
821         view
822         virtual
823         override
824         returns (string memory)
825     {
826         require(
827             _exists(tokenId),
828             'ERC721Metadata: URI query for nonexistent token'
829         );
830 
831         string memory baseURI = _baseURI();
832         return
833             bytes(baseURI).length > 0
834                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
835                 : '';
836     }
837 
838     /**
839      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
840      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
841      * by default, can be overriden in child contracts.
842      */
843     function _baseURI() internal view virtual returns (string memory) {
844         return '';
845     }
846 
847     /**
848      * @dev See {IERC721-approve}.
849      */
850     function approve(address to, uint256 tokenId) public virtual override {
851         address owner = ERC721.ownerOf(tokenId);
852         require(to != owner, 'ERC721: approval to current owner');
853 
854         require(
855             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
856             'ERC721: approve caller is not owner nor approved for all'
857         );
858 
859         _approve(to, tokenId);
860     }
861 
862     /**
863      * @dev See {IERC721-getApproved}.
864      */
865     function getApproved(uint256 tokenId)
866         public
867         view
868         virtual
869         override
870         returns (address)
871     {
872         require(
873             _exists(tokenId),
874             'ERC721: approved query for nonexistent token'
875         );
876 
877         return _tokenApprovals[tokenId];
878     }
879 
880     /**
881      * @dev See {IERC721-setApprovalForAll}.
882      */
883     function setApprovalForAll(address operator, bool approved)
884         public
885         virtual
886         override
887     {
888         require(operator != _msgSender(), 'ERC721: approve to caller');
889 
890         _operatorApprovals[_msgSender()][operator] = approved;
891         emit ApprovalForAll(_msgSender(), operator, approved);
892     }
893 
894     /**
895      * @dev See {IERC721-isApprovedForAll}.
896      */
897     function isApprovedForAll(address owner, address operator)
898         public
899         view
900         virtual
901         override
902         returns (bool)
903     {
904         return _operatorApprovals[owner][operator];
905     }
906 
907     /**
908      * @dev See {IERC721-transferFrom}.
909      */
910     function transferFrom(
911         address from,
912         address to,
913         uint256 tokenId
914     ) public virtual override {
915         //solhint-disable-next-line max-line-length
916         require(
917             _isApprovedOrOwner(_msgSender(), tokenId),
918             'ERC721: transfer caller is not owner nor approved'
919         );
920 
921         _transfer(from, to, tokenId);
922     }
923 
924     /**
925      * @dev See {IERC721-safeTransferFrom}.
926      */
927     function safeTransferFrom(
928         address from,
929         address to,
930         uint256 tokenId
931     ) public virtual override {
932         safeTransferFrom(from, to, tokenId, '');
933     }
934 
935     /**
936      * @dev See {IERC721-safeTransferFrom}.
937      */
938     function safeTransferFrom(
939         address from,
940         address to,
941         uint256 tokenId,
942         bytes memory _data
943     ) public virtual override {
944         require(
945             _isApprovedOrOwner(_msgSender(), tokenId),
946             'ERC721: transfer caller is not owner nor approved'
947         );
948         _safeTransfer(from, to, tokenId, _data);
949     }
950 
951     /**
952      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
953      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
954      *
955      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
956      *
957      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
958      * implement alternative mechanisms to perform token transfer, such as signature-based.
959      *
960      * Requirements:
961      *
962      * - `from` cannot be the zero address.
963      * - `to` cannot be the zero address.
964      * - `tokenId` token must exist and be owned by `from`.
965      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _safeTransfer(
970         address from,
971         address to,
972         uint256 tokenId,
973         bytes memory _data
974     ) internal virtual {
975         _transfer(from, to, tokenId);
976         require(
977             _checkOnERC721Received(from, to, tokenId, _data),
978             'ERC721: transfer to non ERC721Receiver implementer'
979         );
980     }
981 
982     /**
983      * @dev Returns whether `tokenId` exists.
984      *
985      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
986      *
987      * Tokens start existing when they are minted (`_mint`),
988      * and stop existing when they are burned (`_burn`).
989      */
990     function _exists(uint256 tokenId) internal view virtual returns (bool) {
991         return _owners[tokenId] != address(0);
992     }
993 
994     /**
995      * @dev Returns whether `spender` is allowed to manage `tokenId`.
996      *
997      * Requirements:
998      *
999      * - `tokenId` must exist.
1000      */
1001     function _isApprovedOrOwner(address spender, uint256 tokenId)
1002         internal
1003         view
1004         virtual
1005         returns (bool)
1006     {
1007         require(
1008             _exists(tokenId),
1009             'ERC721: operator query for nonexistent token'
1010         );
1011         address owner = ERC721.ownerOf(tokenId);
1012         return (spender == owner ||
1013             getApproved(tokenId) == spender ||
1014             isApprovedForAll(owner, spender));
1015     }
1016 
1017     /**
1018      * @dev Safely mints `tokenId` and transfers it to `to`.
1019      *
1020      * Requirements:
1021      *
1022      * - `tokenId` must not exist.
1023      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1024      *
1025      * Emits a {Transfer} event.
1026      */
1027     function _safeMint(address to, uint256 tokenId) internal virtual {
1028         _safeMint(to, tokenId, '');
1029     }
1030 
1031     /**
1032      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1033      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1034      */
1035     function _safeMint(
1036         address to,
1037         uint256 tokenId,
1038         bytes memory _data
1039     ) internal virtual {
1040         _mint(to, tokenId);
1041         require(
1042             _checkOnERC721Received(address(0), to, tokenId, _data),
1043             'ERC721: transfer to non ERC721Receiver implementer'
1044         );
1045     }
1046 
1047     /**
1048      * @dev Mints `tokenId` and transfers it to `to`.
1049      *
1050      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1051      *
1052      * Requirements:
1053      *
1054      * - `tokenId` must not exist.
1055      * - `to` cannot be the zero address.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _mint(address to, uint256 tokenId) internal virtual {
1060         require(to != address(0), 'ERC721: mint to the zero address');
1061         require(!_exists(tokenId), 'ERC721: token already minted');
1062 
1063         _beforeTokenTransfer(address(0), to, tokenId);
1064 
1065         _balances[to] += 1;
1066         _owners[tokenId] = to;
1067 
1068         emit Transfer(address(0), to, tokenId);
1069     }
1070 
1071     /**
1072      * @dev Destroys `tokenId`.
1073      * The approval is cleared when the token is burned.
1074      *
1075      * Requirements:
1076      *
1077      * - `tokenId` must exist.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _burn(uint256 tokenId) internal virtual {
1082         address owner = ERC721.ownerOf(tokenId);
1083 
1084         _beforeTokenTransfer(owner, address(0), tokenId);
1085 
1086         // Clear approvals
1087         _approve(address(0), tokenId);
1088 
1089         _balances[owner] -= 1;
1090         delete _owners[tokenId];
1091 
1092         emit Transfer(owner, address(0), tokenId);
1093     }
1094 
1095     /**
1096      * @dev Transfers `tokenId` from `from` to `to`.
1097      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1098      *
1099      * Requirements:
1100      *
1101      * - `to` cannot be the zero address.
1102      * - `tokenId` token must be owned by `from`.
1103      *
1104      * Emits a {Transfer} event.
1105      */
1106     function _transfer(
1107         address from,
1108         address to,
1109         uint256 tokenId
1110     ) internal virtual {
1111         require(
1112             ERC721.ownerOf(tokenId) == from,
1113             'ERC721: transfer of token that is not own'
1114         );
1115         require(to != address(0), 'ERC721: transfer to the zero address');
1116 
1117         _beforeTokenTransfer(from, to, tokenId);
1118 
1119         // Clear approvals from the previous owner
1120         _approve(address(0), tokenId);
1121 
1122         _balances[from] -= 1;
1123         _balances[to] += 1;
1124         _owners[tokenId] = to;
1125 
1126         emit Transfer(from, to, tokenId);
1127     }
1128 
1129     /**
1130      * @dev Approve `to` to operate on `tokenId`
1131      *
1132      * Emits a {Approval} event.
1133      */
1134     function _approve(address to, uint256 tokenId) internal virtual {
1135         _tokenApprovals[tokenId] = to;
1136         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1137     }
1138 
1139     /**
1140      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1141      * The call is not executed if the target address is not a contract.
1142      *
1143      * @param from address representing the previous owner of the given token ID
1144      * @param to target address that will receive the tokens
1145      * @param tokenId uint256 ID of the token to be transferred
1146      * @param _data bytes optional data to send along with the call
1147      * @return bool whether the call correctly returned the expected magic value
1148      */
1149     function _checkOnERC721Received(
1150         address from,
1151         address to,
1152         uint256 tokenId,
1153         bytes memory _data
1154     ) private returns (bool) {
1155         if (to.isContract()) {
1156             try
1157                 IERC721Receiver(to).onERC721Received(
1158                     _msgSender(),
1159                     from,
1160                     tokenId,
1161                     _data
1162                 )
1163             returns (bytes4 retval) {
1164                 return retval == IERC721Receiver(to).onERC721Received.selector;
1165             } catch (bytes memory reason) {
1166                 if (reason.length == 0) {
1167                     revert(
1168                         'ERC721: transfer to non ERC721Receiver implementer'
1169                     );
1170                 } else {
1171                     assembly {
1172                         revert(add(32, reason), mload(reason))
1173                     }
1174                 }
1175             }
1176         } else {
1177             return true;
1178         }
1179     }
1180 
1181     /**
1182      * @dev Hook that is called before any token transfer. This includes minting
1183      * and burning.
1184      *
1185      * Calling conditions:
1186      *
1187      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1188      * transferred to `to`.
1189      * - When `from` is zero, `tokenId` will be minted for `to`.
1190      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1191      * - `from` and `to` are never both zero.
1192      *
1193      * To learn more about hooks, food to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1194      */
1195     function _beforeTokenTransfer(
1196         address from,
1197         address to,
1198         uint256 tokenId
1199     ) internal virtual {}
1200 }
1201 
1202 /**
1203  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1204  * @dev See https://eips.ethereum.org/EIPS/eip-721
1205  */
1206 interface IERC721Enumerable is IERC721 {
1207     /**
1208      * @dev Returns the total amount of tokens stored by the contract.
1209      */
1210     function totalSupply() external view returns (uint256);
1211 
1212     /**
1213      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1214      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1215      */
1216     function tokenOfOwnerByIndex(address owner, uint256 index)
1217         external
1218         view
1219         returns (uint256 tokenId);
1220 
1221     /**
1222      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1223      * Use along with {totalSupply} to enumerate all tokens.
1224      */
1225     function tokenByIndex(uint256 index) external view returns (uint256);
1226 }
1227 
1228 /**
1229  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1230  * enumerability of all the token ids in the contract as well as all token ids owned by each
1231  * account.
1232  */
1233 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1234     // Mapping from owner to list of owned token IDs
1235     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1236 
1237     // Mapping from token ID to index of the owner tokens list
1238     mapping(uint256 => uint256) private _ownedTokensIndex;
1239 
1240     // Array with all token ids, used for enumeration
1241     uint256[] private _allTokens;
1242 
1243     // Mapping from token id to position in the allTokens array
1244     mapping(uint256 => uint256) private _allTokensIndex;
1245 
1246     /**
1247      * @dev See {IERC165-supportsInterface}.
1248      */
1249     function supportsInterface(bytes4 interfaceId)
1250         public
1251         view
1252         virtual
1253         override(IERC165, ERC721)
1254         returns (bool)
1255     {
1256         return
1257             interfaceId == type(IERC721Enumerable).interfaceId ||
1258             super.supportsInterface(interfaceId);
1259     }
1260 
1261     /**
1262      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1263      */
1264     function tokenOfOwnerByIndex(address owner, uint256 index)
1265         public
1266         view
1267         virtual
1268         override
1269         returns (uint256)
1270     {
1271         require(
1272             index < ERC721.balanceOf(owner),
1273             'ERC721Enumerable: owner index out of bounds'
1274         );
1275         return _ownedTokens[owner][index];
1276     }
1277 
1278     /**
1279      * @dev See {IERC721Enumerable-totalSupply}.
1280      */
1281     function totalSupply() public view virtual override returns (uint256) {
1282         return _allTokens.length;
1283     }
1284 
1285     /**
1286      * @dev See {IERC721Enumerable-tokenByIndex}.
1287      */
1288     function tokenByIndex(uint256 index)
1289         public
1290         view
1291         virtual
1292         override
1293         returns (uint256)
1294     {
1295         require(
1296             index < ERC721Enumerable.totalSupply(),
1297             'ERC721Enumerable: global index out of bounds'
1298         );
1299         return _allTokens[index];
1300     }
1301 
1302     /**
1303      * @dev Hook that is called before any token transfer. This includes minting
1304      * and burning.
1305      *
1306      * Calling conditions:
1307      *
1308      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1309      * transferred to `to`.
1310      * - When `from` is zero, `tokenId` will be minted for `to`.
1311      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1312      * - `from` cannot be the zero address.
1313      * - `to` cannot be the zero address.
1314      *
1315      * To learn more about hooks, food to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1316      */
1317     function _beforeTokenTransfer(
1318         address from,
1319         address to,
1320         uint256 tokenId
1321     ) internal virtual override {
1322         super._beforeTokenTransfer(from, to, tokenId);
1323 
1324         if (from == address(0)) {
1325             _addTokenToAllTokensEnumeration(tokenId);
1326         } else if (from != to) {
1327             _removeTokenFromOwnerEnumeration(from, tokenId);
1328         }
1329         if (to == address(0)) {
1330             _removeTokenFromAllTokensEnumeration(tokenId);
1331         } else if (to != from) {
1332             _addTokenToOwnerEnumeration(to, tokenId);
1333         }
1334     }
1335 
1336     /**
1337      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1338      * @param to address representing the new owner of the given token ID
1339      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1340      */
1341     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1342         uint256 length = ERC721.balanceOf(to);
1343         _ownedTokens[to][length] = tokenId;
1344         _ownedTokensIndex[tokenId] = length;
1345     }
1346 
1347     /**
1348      * @dev Private function to add a token to this extension's token tracking data structures.
1349      * @param tokenId uint256 ID of the token to be added to the tokens list
1350      */
1351     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1352         _allTokensIndex[tokenId] = _allTokens.length;
1353         _allTokens.push(tokenId);
1354     }
1355 
1356     /**
1357      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1358      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1359      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1360      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1361      * @param from address representing the previous owner of the given token ID
1362      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1363      */
1364     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1365         private
1366     {
1367         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1368         // then delete the last slot (swap and pop).
1369 
1370         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1371         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1372 
1373         // When the token to delete is the last token, the swap operation is unnecessary
1374         if (tokenIndex != lastTokenIndex) {
1375             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1376 
1377             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1378             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1379         }
1380 
1381         // This also deletes the contents at the last position of the array
1382         delete _ownedTokensIndex[tokenId];
1383         delete _ownedTokens[from][lastTokenIndex];
1384     }
1385 
1386     /**
1387      * @dev Private function to remove a token from this extension's token tracking data structures.
1388      * This has O(1) time complexity, but alters the order of the _allTokens array.
1389      * @param tokenId uint256 ID of the token to be removed from the tokens list
1390      */
1391     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1392         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1393         // then delete the last slot (swap and pop).
1394 
1395         uint256 lastTokenIndex = _allTokens.length - 1;
1396         uint256 tokenIndex = _allTokensIndex[tokenId];
1397 
1398         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1399         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1400         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1401         uint256 lastTokenId = _allTokens[lastTokenIndex];
1402 
1403         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1404         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1405 
1406         // This also deletes the contents at the last position of the array
1407         delete _allTokensIndex[tokenId];
1408         _allTokens.pop();
1409     }
1410 }
1411 
1412 contract emLoot is ERC721Enumerable, ReentrancyGuard, Ownable {
1413     string[] private face = [
1414         unicode'😀',
1415         unicode'😂',
1416         unicode'😍',
1417         unicode'😎',
1418         unicode'😡',
1419         unicode'🥺',
1420         unicode'😩',
1421         unicode'😴',
1422         unicode'😷',
1423         unicode'😈',
1424         unicode'👻',
1425         unicode'🤖',
1426         unicode'🤮',
1427         unicode'😱',
1428         unicode'😭',
1429         unicode'🤪',
1430         unicode'🤡',
1431         unicode'👽'
1432     ];
1433 
1434     string[] private pet = [
1435         unicode'🐶',
1436         unicode'🐱',
1437         unicode'🐭',
1438         unicode'🐰',
1439         unicode'🦊',
1440         unicode'🐻',
1441         unicode'🐯',
1442         unicode'🦁',
1443         unicode'🐮',
1444         unicode'🐷',
1445         unicode'🐸',
1446         unicode'🐵',
1447         unicode'🐔',
1448         unicode'🦉',
1449         unicode'🦄',
1450         unicode'🐟',
1451         unicode'🐳',
1452         unicode'🐏'
1453     ];
1454 
1455     string[] private food = [
1456         unicode'🍳',
1457         unicode'🍔',
1458         unicode'🍕',
1459         unicode'🍣',
1460         unicode'🍵',
1461         unicode'🍺',
1462         unicode'🍎',
1463         unicode'🍉',
1464         unicode'🍒',
1465         unicode'🍋',
1466         unicode'🍌',
1467         unicode'🍜',
1468         unicode'🍭',
1469         unicode'🍼',
1470         unicode'🦴',
1471         unicode'🧋',
1472         unicode'🎂',
1473         unicode'🧀'
1474     ];
1475 
1476     string[] private sport = [
1477         unicode'⚽️',
1478         unicode'🏀',
1479         unicode'🏈',
1480         unicode'🎾',
1481         unicode'🏐',
1482         unicode'🎱',
1483         unicode'🏓',
1484         unicode'🏸',
1485         unicode'🏒',
1486         unicode'⛳️',
1487         unicode'🏹',
1488         unicode'🎣',
1489         unicode'🥊',
1490         unicode'🤿',
1491         unicode'🥋',
1492         unicode'⛷',
1493         unicode'🏊️',
1494         unicode'🚴️'
1495     ];
1496 
1497     string[] private traffic = [
1498         unicode'🚗',
1499         unicode'🚕',
1500         unicode'🚌',
1501         unicode'🚜',
1502         unicode'🛴',
1503         unicode'🦽',
1504         unicode'🚲',
1505         unicode'🛵',
1506         unicode'🚄',
1507         unicode'✈️',
1508         unicode'🚀',
1509         unicode'⛵️',
1510         unicode'🚁',
1511         unicode'🦵'
1512     ];
1513 
1514     string[] private job = [
1515         unicode'👮',
1516         unicode'👷',
1517         unicode'🧑‍💻',
1518         unicode'🧑‍🎓',
1519         unicode'🧑‍🌾',
1520         unicode'🧑‍🎨',
1521         unicode'🧑‍🔬',
1522         unicode'🧑‍🏫',
1523         unicode'🧑‍🍳',
1524         unicode'🧑‍⚕️',
1525         unicode'🕵️',
1526         unicode'🧑‍🚒',
1527         unicode'🧑‍🚀',
1528         unicode'🥷',
1529         unicode'🧞️',
1530         unicode'🧛'
1531     ];
1532 
1533     string[] private tool = [
1534         unicode'💊',
1535         unicode'📱',
1536         unicode'💻',
1537         unicode'🎙',
1538         unicode'🎥',
1539         unicode'🛠',
1540         unicode'🔪',
1541         unicode'⛓',
1542         unicode'💣',
1543         unicode'🔫',
1544         unicode'🚽',
1545         unicode'🎁',
1546         unicode'🎉',
1547         unicode'💎',
1548         unicode'💰'
1549     ];
1550 
1551     string[] private attitude = [
1552         unicode'👍',
1553         unicode'👎',
1554         unicode'✊',
1555         unicode'🤘',
1556         unicode'🤏',
1557         unicode'🤙',
1558         unicode'🙏',
1559         unicode'🖕',
1560         unicode'👌',
1561         unicode'👏',
1562         unicode'💩',
1563         unicode'👄',
1564         unicode'👋',
1565         unicode'✌️',
1566         unicode'💪'
1567     ];
1568 
1569     string[] private suffixes = [
1570         unicode'at 🌅',
1571         unicode'at 🌄',
1572         unicode'at 🎆',
1573         unicode'at 🏞',
1574         unicode'at 🌃',
1575         unicode'at 🏦',
1576         unicode'at 🏥',
1577         unicode'at 🏠',
1578         unicode'at 🎡',
1579         unicode'at 🏖',
1580         unicode'at 🏛'
1581     ];
1582 
1583     string[] private namePrefixes = [
1584         unicode'🔥',
1585         unicode'🌈',
1586         unicode'⭐️',
1587         unicode'🌎',
1588         unicode'❤️',
1589         unicode'💡',
1590         unicode'💯'
1591     ];
1592 
1593     string[] private nameSuffixes = [
1594         unicode'❗️',
1595         unicode'❓',
1596         unicode'🎉',
1597         unicode'💎',
1598         unicode'💰',
1599         unicode'🎖'
1600     ];
1601 
1602     function random(string memory input) internal pure returns (uint256) {
1603         return uint256(keccak256(abi.encodePacked(input)));
1604     }
1605 
1606     function getFace(uint256 tokenId) public view returns (string memory) {
1607         return pluck(tokenId, 'FACE', face);
1608     }
1609 
1610     function getPet(uint256 tokenId) public view returns (string memory) {
1611         return pluck(tokenId, 'PET', pet);
1612     }
1613 
1614     function getFood(uint256 tokenId) public view returns (string memory) {
1615         return pluck(tokenId, 'FOOD', food);
1616     }
1617 
1618     function getSport(uint256 tokenId) public view returns (string memory) {
1619         return pluck(tokenId, 'SPORT', sport);
1620     }
1621 
1622     function getTraffic(uint256 tokenId) public view returns (string memory) {
1623         return pluck(tokenId, 'TRAFFIC', traffic);
1624     }
1625 
1626     function getJob(uint256 tokenId) public view returns (string memory) {
1627         return pluck(tokenId, 'JOB', job);
1628     }
1629 
1630     function getTool(uint256 tokenId) public view returns (string memory) {
1631         return pluck(tokenId, 'TOOL', tool);
1632     }
1633 
1634     function getAttitude(uint256 tokenId) public view returns (string memory) {
1635         return pluck(tokenId, 'ATTITUDE', attitude);
1636     }
1637 
1638     function pluck(
1639         uint256 tokenId,
1640         string memory keyPrefix,
1641         string[] memory sourceArray
1642     ) internal view returns (string memory) {
1643         uint256 rand = random(
1644             string(abi.encodePacked(keyPrefix, toString(tokenId)))
1645         );
1646         string memory output = sourceArray[rand % sourceArray.length];
1647         uint256 greatness = rand % 21;
1648         if (greatness > 14) {
1649             output = string(
1650                 abi.encodePacked(output, ' ', suffixes[rand % suffixes.length])
1651             );
1652         }
1653         if (greatness >= 19) {
1654             string[2] memory name;
1655             name[0] = namePrefixes[rand % namePrefixes.length];
1656             name[1] = nameSuffixes[rand % nameSuffixes.length];
1657             if (greatness == 19) {
1658                 output = string(
1659                     abi.encodePacked(
1660                         '#',
1661                         name[0],
1662                         ' ',
1663                         name[1],
1664                         '# ',
1665                         output,
1666                         unicode' 🏆'
1667                     )
1668                 );
1669             } else {
1670                 output = string(
1671                     abi.encodePacked('#', name[0], ' ', name[1], '# ', output)
1672                 );
1673             }
1674         }
1675         return output;
1676     }
1677 
1678     function tokenURI(uint256 tokenId)
1679         public
1680         view
1681         override
1682         returns (string memory)
1683     {
1684         string[17] memory parts;
1685         parts[
1686             0
1687         ] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';
1688 
1689         parts[1] = getFace(tokenId);
1690 
1691         parts[2] = '</text><text x="10" y="40" class="base">';
1692 
1693         parts[3] = getPet(tokenId);
1694 
1695         parts[4] = '</text><text x="10" y="60" class="base">';
1696 
1697         parts[5] = getFood(tokenId);
1698 
1699         parts[6] = '</text><text x="10" y="80" class="base">';
1700 
1701         parts[7] = getSport(tokenId);
1702 
1703         parts[8] = '</text><text x="10" y="100" class="base">';
1704 
1705         parts[9] = getTraffic(tokenId);
1706 
1707         parts[10] = '</text><text x="10" y="120" class="base">';
1708 
1709         parts[11] = getJob(tokenId);
1710 
1711         parts[12] = '</text><text x="10" y="140" class="base">';
1712 
1713         parts[13] = getTool(tokenId);
1714 
1715         parts[14] = '</text><text x="10" y="160" class="base">';
1716 
1717         parts[15] = getAttitude(tokenId);
1718 
1719         parts[16] = '</text></svg>';
1720 
1721         string memory output = string(
1722             abi.encodePacked(
1723                 parts[0],
1724                 parts[1],
1725                 parts[2],
1726                 parts[3],
1727                 parts[4],
1728                 parts[5],
1729                 parts[6],
1730                 parts[7],
1731                 parts[8]
1732             )
1733         );
1734         output = string(
1735             abi.encodePacked(
1736                 output,
1737                 parts[9],
1738                 parts[10],
1739                 parts[11],
1740                 parts[12],
1741                 parts[13],
1742                 parts[14],
1743                 parts[15],
1744                 parts[16]
1745             )
1746         );
1747 
1748         string memory json = Base64.encode(
1749             bytes(
1750                 string(
1751                     abi.encodePacked(
1752                         '{"name": "Person #',
1753                         toString(tokenId),
1754                         '", "description": "Emoji Loot uses emoji to describe an abstract person", "image": "data:image/svg+xml;base64,',
1755                         Base64.encode(bytes(output)),
1756                         '","attributes": [',
1757                         abi.encodePacked(
1758                             '{"trait_type": "Face", "value": "',
1759                             parts[1],
1760                             '"},',
1761                             '{"trait_type": "Pet", "value": "',
1762                             parts[3],
1763                             '"},',
1764                             '{"trait_type": "Food", "value": "',
1765                             parts[5],
1766                             '"},'
1767                         ),
1768                         abi.encodePacked(
1769                             '{"trait_type": "Sport", "value": "',
1770                             parts[7],
1771                             '"},',
1772                             '{"trait_type": "Traffic", "value": "',
1773                             parts[9],
1774                             '"},',
1775                             '{"trait_type": "Job", "value": "',
1776                             parts[11],
1777                             '"},'
1778                         ),
1779                         abi.encodePacked(
1780                             '{"trait_type": "Tool", "value": "',
1781                             parts[13],
1782                             '"},',
1783                             '{"trait_type": "Attitude", "value": "',
1784                             parts[15],
1785                             '"}'
1786                         ),
1787                         ']}'
1788                     )
1789                 )
1790             )
1791         );
1792         output = string(
1793             abi.encodePacked('data:application/json;base64,', json)
1794         );
1795 
1796         return output;
1797     }
1798 
1799     function claim(uint256 tokenId) public nonReentrant {
1800         require(tokenId > 0 && tokenId < 7778, 'Token ID invalid');
1801         _safeMint(_msgSender(), tokenId);
1802     }
1803 
1804     function ownerClaim(uint256 tokenId) public nonReentrant onlyOwner {
1805         require(tokenId > 7777 && tokenId < 8001, 'Token ID invalid');
1806         _safeMint(owner(), tokenId);
1807     }
1808 
1809     function toString(uint256 value) internal pure returns (string memory) {
1810         // Inspired by OraclizeAPI's implementation - MIT license
1811         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1812 
1813         if (value == 0) {
1814             return '0';
1815         }
1816         uint256 temp = value;
1817         uint256 digits;
1818         while (temp != 0) {
1819             digits++;
1820             temp /= 10;
1821         }
1822         bytes memory buffer = new bytes(digits);
1823         while (value != 0) {
1824             digits -= 1;
1825             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1826             value /= 10;
1827         }
1828         return string(buffer);
1829     }
1830 
1831     constructor() ERC721('emLoot', 'emLoot') Ownable() {}
1832 }
1833 
1834 library Base64 {
1835     bytes internal constant TABLE =
1836         'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
1837 
1838     /// @notice Encodes some bytes to the base64 representation
1839     function encode(bytes memory data) internal pure returns (string memory) {
1840         uint256 len = data.length;
1841         if (len == 0) return '';
1842 
1843         // multiply by 4/3 rounded up
1844         uint256 encodedLen = 4 * ((len + 2) / 3);
1845 
1846         // Add some extra buffer at the end
1847         bytes memory result = new bytes(encodedLen + 32);
1848 
1849         bytes memory table = TABLE;
1850 
1851         assembly {
1852             let tablePtr := add(table, 1)
1853             let resultPtr := add(result, 32)
1854 
1855             for {
1856                 let i := 0
1857             } lt(i, len) {
1858 
1859             } {
1860                 i := add(i, 3)
1861                 let input := and(mload(add(data, i)), 0xffffff)
1862 
1863                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1864                 out := shl(8, out)
1865                 out := add(
1866                     out,
1867                     and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
1868                 )
1869                 out := shl(8, out)
1870                 out := add(
1871                     out,
1872                     and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
1873                 )
1874                 out := shl(8, out)
1875                 out := add(
1876                     out,
1877                     and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
1878                 )
1879                 out := shl(224, out)
1880 
1881                 mstore(resultPtr, out)
1882 
1883                 resultPtr := add(resultPtr, 4)
1884             }
1885 
1886             switch mod(len, 3)
1887             case 1 {
1888                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1889             }
1890             case 2 {
1891                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1892             }
1893 
1894             mstore(result, encodedLen)
1895         }
1896 
1897         return string(result);
1898     }
1899 }